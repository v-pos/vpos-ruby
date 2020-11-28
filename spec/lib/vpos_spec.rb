require "spec_helper"
require "httparty"
require_relative "../../lib/vpos"

describe "vPOS" do
  context "Payments" do
    context "when is not valid" do
      it "should not create new payment transaction if customer invalid" do
        payment = Vpos.new_payment("92588855", "1250.34")
        expect(payment).to be_an(Hash)
        expect(payment[:status]).to eq("400")
        expect(payment[:message]).to eq("Bad Request")
      end
      it "should not create new payment transaction if amount is invalid" do
        payment = Vpos.new_payment("925888553", "1250.34.94")
        expect(payment).to be_an(Hash)
        expect(payment[:details]["amount"]).to eq(["is invalid"])
        expect(payment[:status]).to eq("400")
      end
    end

    context "when is valid" do
      it "should create new payment transaction" do
        payment = Vpos.new_payment("925888553", "1250.34")
        expect(payment).to be_an(Hash)
        expect(payment[:status]).to eq("202")
        expect(payment[:message]).to eq("Accepted")
      end
    end
  end

  context "Requests" do
    context "when is not valid" do
      it "should not get request" do
        payment = Vpos.new_payment("92588855", "1250.34")
        request = Vpos.get_request(payment[:location])
        expect(request).to be_an(Hash)
        expect(request[:status]).to eq("404")
        expect(request[:message]).to eq("Not Found")
      end
    end
    context "when is valid" do
      it "should get request" do
        payment = Vpos.new_payment("925721924", "1250.34")
        request_id = Vpos.get_request_id(payment)
        request = Vpos.get_request(request_id)
        expect(request).to be_an(Hash)
        expect(request[:status]).to eq("200")
        expect(request[:message]).to eq("OK")
      end
    end
  end

  context "Transactions" do
    context "when is not valid" do
      it "should not get a transaction if id does not exist" do
        transaction = Vpos.get_transaction("invalid_id")
        expect(transaction).to be_an(Hash)
        expect(transaction[:status]).to eq("404")
        expect(transaction[:message]).to eq("Not Found")
      end
    end

    context "when is valid" do
      it "should get a transaction" do
        payment = Vpos.new_payment("925888553", "1250.34")
        request = Vpos.get_request(Vpos.get_request_id(payment))
        transaction = Vpos.get_transaction(request[:data]["id"])
        expect(transaction).to be_an(Hash)
        expect(transaction[:status]).to eq("200")
        expect(transaction[:data]).to be_an(Array)
      end

      it "should get all transactions" do
        transactions = Vpos.get_transactions
        expect(transactions).to be_an(Hash)
        expect(transactions[:status]).to eq("200")
        expect(transactions[:data]).to be_an(Array)
      end
    end
  end

  context "Refunds" do
    context "when is not valid" do
      it "should not create new refund transaction if parent transaction does not exist" do
        refund = Vpos.new_refund("9kOmKgxWQuCXpUzUB6")
        expect(refund[:status]).to eq("202")
        request = Vpos.get_transaction(Vpos.get_request_id(refund))
        expect(request[:data]["status"]).to eq("rejected")
        expect(request[:data]["status_reason"]).to eq(1003)
        expect(request[:data]).to be_an(Hash)
      end
    end

    context "when is valid" do
      it "should create new refund transaction" do
        refund = Vpos.new_refund("9kOmKgxWQuCXpUzUB6c")
        expect(refund).to be_an(Hash)
        expect(refund[:status]).to eq("202")
      end
    end
  end
end
