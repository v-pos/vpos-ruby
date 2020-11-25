require "vpos/version"
require "httparty"
require "securerandom"

module Vpos
  class Error < StandardError; end
  include HTTParty
  follow_redirects false

  def self.new_payment(customer, amount, pos_id: default_pos_id, callback_url: default_payment_callback_url)
    content = set_headers
    content[:body] = {type:"payment", pos_id: pos_id, mobile: customer, amount: amount, callback_url: callback_url}.to_json
    post("#{host}/transactions", content)
  end

  def self.new_refund(transaction_id, supervisor_card: default_supervisor_card, callback_url: default_refund_callback_url)
    content = set_headers
    content[:body] = {type: "refund", parent_transaction_id: transaction_id, supervisor_card: supervisor_card, callback_url: callback_url}.to_json
    post("#{host}/transactions", content)
  end

  def self.get_transaction(transaction_id)
    get("#{host}/transactions/#{transaction_id}", set_headers)
  end

  def self.get_transactions
    get("#{host}/transactions", set_headers)
  end

  def self.get_request_id(request)
    if request.headers["location"].nil? 
      get("#{host}/references/invalid", set_headers)
    else
      location = request.headers["location"]
      if request.response.code == "202"
        location.gsub("/api/v1/requests/", "")
      else
        location.gsub("/api/v1/transactions/", "")
      end
    end
  end

  def self.get_request(transaction_id)
    get("#{host}/requests/#{transaction_id}", set_headers)
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

    def self.host
      if ENV["VPOS_ENVIRONMENT"] == "prd"
        return "https://api.vpos.ao/api/v1"
      else
        return "https://sandbox.vpos.ao/api/v1"
      end
    end
end
