require "spec_helper"
require "httparty"
require_relative "../../lib/vpos"

describe "vPOS" do
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
        transaction = Vpos.get_transaction("1j9LV1qIiqwy8NlOFdgo7bsk0DO")
        expect(transaction).to be_an(HTTParty::Response)
        expect(transaction.response.code).to eq("200")
        expect(transaction.parsed_response).to be_an(Hash)
      end

      it "should get all transactions" do
        transactions = Vpos.get_transactions
        expect(transactions).to be_an(HTTParty::Response)
        expect(transactions.response.code).to eq("200")
        expect(transactions.parsed_response).to be_an(Array)
      end
    end
  end

  context "Payments" do
    context "when is not valid" do
      it "should not create new payment transaction if customer invalid" do
        payment = Vpos.new_payment("92588855", "1250.34")
        expect(payment).to be_an(HTTParty::Response)
        expect(payment.parsed_response["errors"]["mobile"]).to eq(["has invalid format"])
        expect(payment.response.code).to eq("400")
        expect(payment.parsed_response).to be_an(Hash)
      end
      it "should not create new payment transaction if amount is invalid" do
        pending("The web service is returning 500 and it's being handled by the ws team")
        payment = Vpos.new_payment("925888553", "1250.34.94")
        expect(payment).to be_an(HTTParty::Response)
        expect(payment.parsed_response["errors"]["amount"]).to eq(["has invalid format"])
        expect(payment.response.code).to eq("400")
        expect(payment.parsed_response).to be_an(Hash)
      end
    end
    context "when is valid" do
      it "should create new payment transaction" do
        payment = Vpos.new_payment("925888553", "1250.34")
        expect(payment).to be_an(HTTParty::Response)
        expect(payment.parsed_response["status"]).to eq("pending")
        expect(payment.parsed_response["type"]).to eq("payment")
        expect(payment.response.code).to eq("201")
        expect(payment.parsed_response).to be_an(Hash)
      end
    end
  end

  context "Refunds" do
    context "when is not valid" do
      it "should not create new refund transaction if parent transaction does not exist" do
        refund = Vpos.new_refund("9kOmKgxWQuCXpUzUB6")
        expect(refund).to be_an(HTTParty::Response)
        expect(refund.parsed_response["errors"]["parent_transaction_id"]).to eq(["is invalid"])
        expect(refund.response.code).to eq("400")
        expect(refund.parsed_response).to be_an(Hash)
      end
    end
    context "when is valid" do
      it "should create new refund transaction" do
        pending("A transaction payment with status accepted is needed to request a refund")
        refund = Vpos.new_refund("1j9LV1qIiqwy8NlOFdgo7bsk0DO")
        expect(refund).to be_an(HTTParty::Response)
        expect(refund.parsed_response["status"]).to eq("pending")
        expect(refund.parsed_response["type"]).to eq("refund")
        expect(refund.response.code).to eq("201")
        expect(refund.parsed_response).to be_an(Hash)
      end
    end
  end
end
