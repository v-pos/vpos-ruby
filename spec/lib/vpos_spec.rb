require "spec_helper"
require "httparty"
require_relative "../../lib/vpos"

describe "vPOS" do
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

  it "should create new payment transaction" do
    payment = Vpos.new_payment("925888553", "1250.34")
    expect(payment).to be_an(HTTParty::Response)
    expect(payment.parsed_response["status"]).to eq("pending")
    expect(payment.parsed_response["type"]).to eq("payment")
    expect(payment.response.code).to eq("201")
    expect(payment.parsed_response).to be_an(Hash)
  end

  it "should create new refund transaction" do
    pending("A payment at accept status is needed to test the refund")
    refund = Vpos.new_refund("1j9LV1qIiqwy8NlOFdgo7bsk0DO")
    expect(refund).to be_an(HTTParty::Response)
    expect(refund.parsed_response["status"]).to eq("pending")
    expect(refund.parsed_response["type"]).to eq("refund")
    expect(refund.response.code).to eq("201")
    expect(refund.parsed_response).to be_an(Hash)
  end
end
