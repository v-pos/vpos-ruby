require "spec_helper"
require "httparty"
require_relative "../../lib/vpos"

describe "vPOS" do
  context "Payments" do
    context "when is not valid" do
      it "should not create new payment transaction if customer invalid" do
        merchant = Vpos.new
        payment = merchant.new_payment("92588855", "1250.34")

        expect(payment).to be_an(Hash)
        expect(payment[:status_code]).to eq(400)
        expect(payment[:message]).to eq("Bad Request")
      end

      it "should not create new payment transaction if amount is invalid" do
        merchant = Vpos.new
        payment = merchant.new_payment("925888553", "1250.34.94")

        expect(payment).to be_an(Hash)
        expect(payment[:details]["amount"]).to eq(["is invalid"])
        expect(payment[:status_code]).to eq(400)
      end
    end

    context "when is valid" do
      it "should create new payment transaction" do
        merchant = Vpos.new
        payment = merchant.new_payment("925888553", "1250.34")

        expect(payment).to be_an(Hash)
        expect(payment[:status_code]).to eq(202)
        expect(payment[:message]).to eq("Accepted")
      end
    end
  end

  context "Requests" do
    context "when is not valid" do
      it "should not get request" do
        merchant = Vpos.new
        payment = merchant.new_payment("92588855", "1250.34")
        request = merchant.get_request(payment[:location])

        expect(request).to be_an(Hash)
        expect(request[:status_code]).to eq(404)
        expect(request[:message]).to eq("Not Found")
      end
    end

    context "when is valid" do
      it "should get request" do
        merchant = Vpos.new
        payment = merchant.new_payment("925721924", "1250.34")

        request_id = merchant.get_request_id(payment)
        request = merchant.get_request(request_id)

        expect(request).to be_an(Hash)
        expect(request[:status_code]).to eq(200)
        expect(request[:message]).to eq("OK")
      end
    end
  end

 context "Transactions" do
    context "when is not valid" do
      it "should not get a transaction if id does not exist" do
        merchant = Vpos.new
        transaction = merchant.get_transaction("invalid_id")

        expect(transaction).to be_an(Hash)
        expect(transaction[:status_code]).to eq(404)
        expect(transaction[:message]).to eq("Not Found")
      end
    end

    context "when is valid" do
      it "should get a transaction" do
        merchant = Vpos.new
        payment = merchant.new_payment("925888553", "1250.34")
        payment_id = merchant.get_request_id(payment)

        sleep(10)

        transaction = merchant.get_transaction(payment_id)

        expect(transaction).to be_an(Hash)
        expect(transaction[:status_code]).to eq(200)
        expect(transaction[:data]).to be_an(Hash)
      end

      it "should get all transactions" do
        merchant = Vpos.new
        transactions = merchant.get_transactions

        expect(transactions).to be_an(Hash)
        expect(transactions[:status_code]).to eq(200)
        expect(transactions[:data]).to be_an(Array)
      end
    end
  end

  context "Refunds" do
    context "when is not valid" do
      it "should not create new refund transaction if parent transaction does not exist" do
        merchant = Vpos.new
        refund = merchant.new_refund("9kOmKgxWQuCXpUzUB6")
        refund_id = merchant.get_request_id(refund)
        request = merchant.get_transaction(refund_id)

        expect(refund[:status]).to eq(202)
        expect(request[:data]["status_code"]).to eq("rejected")
        expect(request[:data]["status_reason"]).to eq(1003)
        expect(request[:data]).to be_an(Hash)
      end
    end

    context "when is valid" do
      it "should create new refund transaction" do
        merchant = Vpos.new
        refund = merchant.new_refund("9kOmKgxWQuCXpUzUB6c")

        expect(refund).to be_an(Hash)
        expect(refund[:status_code]).to eq(202)
      end
    end
  end
end
