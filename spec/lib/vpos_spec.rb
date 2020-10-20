require "spec_helper"
require_relative "../../lib/vpos"

describe Vpos, type: :request do
  it "should get a transaction" do
    transaction = Vpos.get_transaction("1j9LV1qIiqwy8NlOFdgo7bsk0DO")
    expect(transaction["id"]).to eq("1j9LV1qIiqwy8NlOFdgo7bsk0DO") 
  end

  it "should get all transactions" do
    transactions = Vpos.get_transactions
    expect(transactions.size).to be > 1 
  end

  it "should create new payment transaction" do
    payment = Vpos.new_payment("925888553", "1250.34")
    expect(payment["mobile"]).to eq("925888553")
    expect(payment["amount"]).to eq("1250.34")
    expect(payment["status"]).to eq("pending")
    expect(payment["type"]).to eq("payment")
  end

  it "should create new refund transaction" do
    pending
    payment = Vpos.new_refund("1j9LV1qIiqwy8NlOFdgo7bsk0DO")
    expect(payment["status"]).to eq("pending")
    expect(payment["type"]).to eq("refund")
  end
end
