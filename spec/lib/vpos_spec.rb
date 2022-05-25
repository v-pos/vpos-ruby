require "spec_helper"
require "faraday"
require_relative "../../lib/vpos"

describe "vPOS" do
  context "Payments" do
    context "when is not valid" do
      it "should not create new payment transaction if customer invalid" do
        merchant = Vpos.new
        payment = merchant.new_payment(customer: "92588855", amount: "1250.34")

        expect(payment).to be_an(Hash)
        expect(payment[:status_code]).to eq(400)
        expect(payment[:message]).to eq(400)
      end

      it "should not create new payment transaction if amount is invalid" do
        merchant = Vpos.new
        payment = merchant.new_payment(customer: "925888553", amount: "1250.34.94")

        expect(payment).to be_an(Hash)
        expect(payment[:details][:errors]["amount"]).to eq(["is invalid"])
        expect(payment[:status_code]).to eq(400)
      end
    end

    context "when is valid" do
      it "should create new payment transaction" do
        merchant = Vpos.new
        payment = merchant.new_payment(customer: "900000000", amount: "1234.56") 
        request_id = merchant.get_request_id(payment)

        transaction = merchant.get_transaction(transaction_id: request_id)

        expect(payment).to be_an(Hash)
        expect(payment[:status_code]).to eq(202)
        expect(payment[:message]).to eq("ACCEPTED")

        while transaction[:status_code] == 404
          sleep(4)
          transaction = merchant.get_transaction(transaction_id: request_id)
        end

        expect(transaction).to be_an(Hash)
        expect(transaction[:status_code]).to eq(200)
        expect(transaction[:message]).to eq("OK")
        expect(transaction[:data][:amount]).to eq("1234.56")
        expect(transaction[:data][:status]).to eq("accepted")
      end
    end
  end

  context "Requests" do
    context "when is not valid" do
      it "should not get request" do
        merchant = Vpos.new
        payment = merchant.new_payment(customer: "92588855", amount: "1250.34")
        request = merchant.get_request(request_id: payment[:location])

        expect(request).to be_an(Hash)
        expect(request[:status_code]).to eq(404)
        expect(request[:message]).to eq("NOT FOUND")
      end
    end

    context "when is valid" do
      it "should get request" do
        merchant = Vpos.new
        payment = merchant.new_payment(customer: "900000000", amount: "1250.34")

        request_id = merchant.get_request_id(payment)
        request = merchant.get_request(request_id: request_id)

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
        transaction = merchant.get_transaction(transaction_id: "invalid_id")

        expect(transaction).to be_an(Hash)
        expect(transaction[:status_code]).to eq(404)
        expect(transaction[:message]).to eq("NOT FOUND")
      end
    end

    context "when is valid" do
      it "should get a transaction" do
        merchant = Vpos.new
        payment = merchant.new_payment(customer: "900000000", amount: "1250.34")
        payment_id = merchant.get_request_id(payment)

        sleep(100)

        transaction = merchant.get_transaction(transaction_id: payment_id)

        expect(transaction[:data]).to be_an(Hash)
      end
    end
  end

  context "Refunds" do
    context "when is not valid" do
      it "should not create new refund transaction if parent transaction does not exist" do
        merchant = Vpos.new
        refund = merchant.new_refund(parent_transaction_id: "9kOmKgxWQuCXpUzUB6")
        refund_id = merchant.get_request_id(refund)

        transaction = merchant.get_transaction(transaction_id: refund_id)

        expect(refund).to be_an(Hash)
        expect(refund[:status_code]).to eq(202)
        expect(refund[:message]).to eq("ACCEPTED")

        while transaction[:status_code] == 404
          sleep(4)
          transaction = merchant.get_transaction(request_id)
        end

        expect(transaction).to be_an(Hash)
        expect(transaction[:status_code]).to eq(200)
        expect(transaction[:data][:status]).to eq('rejected')
        expect(transaction[:data][:status_reason]).to eq(1003)
        expect(transaction[:data]).to be_an(Hash)
      end
    end

    context "when is valid" do
      it "should create new refund transaction" do
        merchant = Vpos.new
        refund = merchant.new_refund(parent_transaction_id: "9kOmKgxWQuCXpUzUB6c")

        expect(refund).to be_an(Hash)
        expect(refund[:status_code]).to eq(202)
      end
    end
  end
end
