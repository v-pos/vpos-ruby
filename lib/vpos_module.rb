require "vpos/version"
require "faraday"
require "json"
require "securerandom"

module VposModule
  class Error < StandardError; end

  def new_payment(
    customer: required,
    amount: required,
    pos_id: @pos_id,
    callback_url: @payment_callback_url,
    token: @token
  )
    conn = connection
    response = conn.post('transactions') do |req|
      req.headers['Authorization'] = token
      req.body = { type: "payment", pos_id: pos_id, mobile: customer, amount: amount, callback_url: callback_url }.to_json
    end
    return_vpos_object(response)
  end

  def new_refund(parent_transaction_id: required, token: @token, callback_url: @refund_callback_url)
    conn = connection
    response = conn.post('transactions') do |req|
      req.headers['Authorization'] = token
      req.body = { type: "refund", parent_transaction_id: parent_transaction_id, callback_url: callback_url }.to_json
    end
    return_vpos_object(response)
  end

  def get_transaction(transaction_id: required, token: @token)
    conn = connection
    response = conn.get("transactions/#{transaction_id}") do |req|
      req.headers['Authorization'] = token
    end
    return_vpos_object(response)
  end

  def get_request_id(response)
    if response[:location].nil?
      conn = connection
      response = conn.get("references/invalid") do |req|
        req.headers['Authorization'] = token
      end
    else
      if response[:status_code] == 202
        response[:location].gsub("/api/v1/requests/", "")
      else
        response[:location].gsub("/api/v1/transactions/", "")
      end
    end
  end

  def get_request(request_id: required, token: @token)
    conn = connection
    response = conn.get("requests/#{request_id}") do |req|
      req.headers['Authorization'] = token
    end
    return_vpos_object(response)
  end

  private
    def return_vpos_object(response)
      case response.status
      when 200
        return { status_code: response.status, message: 'OK', data: JSON.parse(response.body).transform_keys(&:to_sym) }
      when 201
        return { status_code: response.status, message: 'CREATED', data: response.body }
      when 202, 303
        return { status_code: response.status, message: 'ACCEPTED', location: response.headers["location"]}
      when 401
        return { status_code: response.status, message: 'UNAUTHORIZED' }
      when 404
        return { status_code: response.status, message: 'NOT FOUND' }
      else
        return { status_code: response.status, message: response.status, details: JSON.parse(response.body).transform_keys(&:to_sym) }
      end
    end

    def set_headers
      headers = {'Content-Type' => "application/json", 'Accept' => "application/json", 'Idempotency-Key' => SecureRandom.uuid}
    end

    def host
      "https://vpos.ao/api/v1"
    end

    def params
      params = {}
    end

    def connection
      conn = Faraday.new(
        url: host,
        params: params,
        headers: set_headers
      )
    end

    def required
      method = caller_locations(1,1)[0].label
      raise ArgumentError,
        "A required keyword argument was not specified when calling '#{method}'"
    end
end
