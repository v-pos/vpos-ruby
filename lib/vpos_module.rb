require "vpos/version"
require "httparty"
require "securerandom"

module VposModule
  class Error < StandardError; end
  include HTTParty
  follow_redirects false

  def new_payment(customer, amount, pos_id: default_pos_id, callback_url: default_payment_callback_url)
    content = set_headers
    content[:body] = {type:"payment", pos_id: pos_id, mobile: customer, amount: amount, callback_url: callback_url}.to_json
    request = HTTParty.post("#{host}/transactions", content)
    return_vpos_object(request)
  end

  def new_refund(transaction_id, supervisor_card: default_supervisor_card, callback_url: default_refund_callback_url)
    content = set_headers
    content[:body] = {type: "refund", parent_transaction_id: transaction_id, supervisor_card: supervisor_card, callback_url: callback_url}.to_json
    request = HTTParty.post("#{host}/transactions", content)
    return_vpos_object(request)
  end

  def get_transaction(transaction_id)
    request = HTTParty.get("#{host}/transactions/#{transaction_id}", set_headers)
    return_vpos_object(request)
  end

  def get_transactions
    request = HTTParty.get("#{host}/transactions", set_headers)
    return_vpos_object(request)
  end

  def get_request_id(response)
    if response[:location].nil?
      HTTParty.get("#{host}/references/invalid", set_headers)
    else
      if response[:status_code] == 202
        response[:location].gsub("/api/v1/requests/", "")
      else
        response[:location].gsub("/api/v1/transactions/", "")
      end
    end
  end

  def get_request(request_id)
    request = HTTParty.get("#{host}/requests/#{request_id}", set_headers)
    return_vpos_object(request)
  end

  private
    def return_vpos_object(request)
      case request.response.code.to_i
      when 200, 201
        return {status_code: request.response.code.to_i, message: request.response.message, data: request.parsed_response}
      when 202, 303
        return {status_code: request.response.code.to_i, message: request.response.message, location: request.headers["location"]}
      else
        return {status_code: request.response.code.to_i, message: request.response.message, details: request.parsed_response["errors"]}
      end
    end

    def set_headers
      content = {}
      headers = {'Content-Type' => "application/json", 'Accept' => "application/json", 'Authorization' => set_token, 'Idempotency-Key' => SecureRandom.uuid}
      content[:headers] = headers
      content
    end

    def default_pos_id
      pos_id = ENV["GPO_POS_ID"]
      "#{pos_id}".to_i
    end

    def default_supervisor_card
      supervisor_card = ENV["GPO_SUPERVISOR_CARD"]
      "#{supervisor_card}"
    end

    def set_token
      token = ENV["MERCHANT_VPOS_TOKEN"]
      "Bearer #{token}"
    end

    def default_payment_callback_url
      ENV["PAYMENT_CALLBACK_URL"]
    end

    def default_refund_callback_url
      ENV["REFUND_CALLBACK_URL"]
    end

    def host
      if ENV["VPOS_ENVIRONMENT"] == "PRD"
        "https://api.vpos.ao/api/v1"
      else
        "https://sandbox.vpos.ao/api/v1"
      end
    end
end
