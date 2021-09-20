require "spec_helper"
require "httparty"
require_relative "../../lib/vpos"

describe "vPOS" do
  context "Payments" do
    context "when is not valid" do
      it "should not create new payment transaction if customer invalid" do
        merchant = Vpos.new
        payment = merchant.new_payment("92588855", "1250.34", callback_url: "")

        expect(payment).to be_an(Hash)
        expect(payment[:status_code]).to eq(400)
        expect(payment[:message]).to eq("Bad Request")
      end

      it "should not create new payment transaction if amount is invalid" do
        merchant = Vpos.new
        payment = merchant.new_payment("925888553", "1250.34.94", callback_url: "")

        expect(payment).to be_an(Hash)
        expect(payment[:details]["amount"]).to eq(["is invalid"])
        expect(payment[:status_code]).to eq(400)
      end
    end

    context "when is valid" do
      it "should create new payment transaction" do
        merchant = Vpos.new
        payment = merchant.new_payment("900000000", "1234.56", callback_url: "")
        request_id = merchant.get_request_id(payment)

        sleep(15)
        transaction = merchant.get_transaction(request_id)

        expect(payment).to be_an(Hash)
        expect(payment[:status_code]).to eq(202)
        expect(payment[:message]).to eq("Accepted")

        expect(transaction).to be_an(Hash)
        expect(transaction[:status_code]).to eq(200)
        expect(transaction[:message]).to eq("OK")
        expect(transaction[:data]["amount"]).to eq("1234.56")
        expect(transaction[:data]["status"]).to eq("accepted")
      end
    end
  end

  context "Requests" do
    context "when is not valid" do
      it "should not get request" do
        merchant = Vpos.new
        payment = merchant.new_payment("92588855", "1250.34", callback_url: "")
        request = merchant.get_request(payment[:location])

        expect(request).to be_an(Hash)
        expect(request[:status_code]).to eq(404)
        expect(request[:message]).to eq("Not Found")
      end
    end

    context "when is valid" do
      it "should get request" do
        merchant = Vpos.new
        payment = merchant.new_payment("925721924", "1250.34", callback_url: "")

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
        payment = merchant.new_payment("925888553", "1250.34", callback_url: "")
        payment_id = merchant.get_request_id(payment)

        transaction = merchant.await.get_transaction(payment_id)

        expect(transaction.value).to be_an(Hash)
        expect(transaction.value[:data]["id"]).to eq(payment_id)
        expect(transaction.value[:status_code]).to eq(200)
      end
    end
  end

  context "Refunds" do
    context "when is not valid" do
      it "should not create new refund transaction if parent transaction does not exist" do
        merchant = Vpos.new
        refund = merchant.new_refund("9kOmKgxWQuCXpUzUB6", callback_url: "")
        refund_id = merchant.get_request_id(refund)

        transaction = merchant.await.get_transaction(refund_id)

        expect(transaction.value).to be_an(Hash)
        expect(transaction.value[:status_code]).to eq(200)
        expect(transaction.value[:data]["status"]).to eq('rejected')
        expect(transaction.value[:data]["status_reason"]).to eq(1003)
        expect(transaction.value[:data]).to be_an(Hash)
      end
    end

    context "when is valid" do
      it "should create new refund transaction" do
        merchant = Vpos.new
        refund = merchant.new_refund("9kOmKgxWQuCXpUzUB6c", callback_url: "")

        expect(refund).to be_an(Hash)
        expect(refund[:status_code]).to eq(202)
      end
    end
  end
end