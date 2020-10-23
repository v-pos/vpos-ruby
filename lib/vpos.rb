require "vpos/version"
require "httparty"
require "securerandom"

module Vpos
  class Error < StandardError; end
  include HTTParty
  base_uri "http://178.79.144.59:4000/api/v1"

  def self.new_payment(customer, amount, pos_id: default_pos_id, callback_url: default_payment_callback_url)
    content = set_headers
    content[:body] = {type:"payment", pos_id: pos_id, mobile: customer, amount: amount, callback_url: callback_url}.to_json
    post("/transactions", content)
  end

  def self.new_refund(transaction_id, supervisor_card: default_supervisor_card, callback_url: default_refund_callback_url)
    content = set_headers
    content[:body] = {type: "refund", parent_transaction_id: transaction_id, supervisor_card: supervisor_card, callback_url: callback_url}.to_json
    post("/transactions", content)
  end

  def self.get_transaction(transaction_id)
    content = set_headers
    get("/transactions/#{transaction_id}", content)
  end

  def self.get_transactions
    content = set_headers
    get("/transactions", content)
  end

  def self.get_request(location)
    content = set_headers
    if location == nil
      get("/references/invalid", content)
    else
      get(location.gsub("/api/v1", ""), content)
    end
  end

  private
    def self.set_headers
      content = {}
      headers = {'Content-Type' => "application/json", 'Accept' => "application/json", 'Authorization' => set_token, 'Idempotency-Key' => SecureRandom.uuid}
      content[:headers] = headers
      return content
    end

    def self.default_pos_id
      pos_id = ENV["GPO_POS_ID"]
      return "#{pos_id}".to_i
    end

    def self.default_supervisor_card
      supervisor_card = ENV["GPO_SUPERVISOR_CARD"]
      return "#{supervisor_card}"
    end
    
    def self.set_token
      token = ENV["MERCHANT_VPOS_TOKEN"]
      return "Bearer #{token}"
    end

    def self.default_payment_callback_url
      url = ENV["PAYMENT_CALLBACK_URL"]
      return url
    end

    def self.default_refund_callback_url
      url = ENV["REFUND_CALLBACK_URL"]
      return url
    end
end
