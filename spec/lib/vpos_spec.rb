require "spec_helper"
require "httparty"
require_relative "../../lib/vpos"

describe "vPOS" do
  context "Payments" do
    context "when is not valid" do
      it "should not create new payment transaction if customer invalid" do
        payment, _ = Vpos.new_payment("92588855", "1250.34")
        expect(payment).to be_an(HTTParty::Response)
        expect(payment.response.code).to eq("400")
        expect(payment.parsed_response).to be_an(Hash)
      end
      it "should not create new payment transaction if amount is invalid" do
        payment = Vpos.new_payment("925888553", "1250.34.94")
        expect(payment).to be_an(HTTParty::Response)
        expect(payment.parsed_response["errors"]["amount"]).to eq(["is invalid"])
        expect(payment.response.code).to eq("400")
        expect(payment.parsed_response).to be_an(Hash)
      end
    end

    context "when is valid" do
      it "should create new payment transaction" do
        payment = Vpos.new_payment("925888553", "1250.34")
        expect(payment).to be_an(HTTParty::Response)
        expect(payment.response.code).to eq("202")
      end
    end
  end

  context "Requests" do
    context "when is not valid" do
      it "should not get request" do
        payment = Vpos.new_payment("92588855", "1250.34")
        request = Vpos.get_request(payment.headers["Location"])
        expect(request).to be_an(HTTParty::Response)
        expect(request.response.code).to eq("404")
      end
    end
    context "when is valid" do
      it "should get request" do
        payment = Vpos.new_payment("925721924", "1250.34")
        request_id = Vpos.get_request_id(payment)
        request = Vpos.get_request(request_id)
        expect(request).to be_an(HTTParty::Response)
        expect(request.response.code).to eq("200")
      end
    end
  end

  context "Transactions" do
    context "when is not valid" do
      it "should not get a transaction if id does not exist" do
        transaction = Vpos.get_transaction("invalid_id")
        expect(transaction).to be_an(HTTParty::Response)
        expect(transaction.response.code).to eq("404")
        expect(transaction.parsed_response).to eq("Not Found")
      end
    end

    context "when is valid" do
      it "should get a transaction" do
        payment = Vpos.new_payment("925888553", "1250.34")
        request = Vpos.get_request(payment.headers["Location"])
        transaction = Vpos.get_transaction(request.parsed_response["id"])
        expect(transaction).to be_an(HTTParty::Response)
        expect(transaction.response.code).to eq("200")
        expect(transaction.parsed_response).to be_an(Array)
      end

      it "should get all transactions" do
        transactions = Vpos.get_transactions
        expect(transactions).to be_an(HTTParty::Response)
        expect(transactions.response.code).to eq("200")
        expect(transactions.parsed_response).to be_an(Array)
      end
    end
  end

  context "Refunds" do
    context "when is not valid" do
      it "should not create new refund transaction if parent transaction does not exist" do
        refund = Vpos.new_refund("9kOmKgxWQuCXpUzUB6")
        expect(refund.response.code).to eq("202")
        request_id = Vpos.get_request_id(refund)
        request = Vpos.get_transaction(request_id)
        expect(request.parsed_response["status"]).to eq("rejected")
        expect(request.parsed_response["status_reason"]).to eq(1003)
        expect(request.parsed_response).to be_an(Hash)
      end
    end

    context "when is valid" do
      it "should create new refund transaction" do
        refund = Vpos.new_refund("9kOmKgxWQuCXpUzUB6c")
        expect(refund).to be_an(HTTParty::Response)
        expect(refund.response.code).to eq("202")
      end
    end
  end
end
