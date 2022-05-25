require_relative "vpos_module"

class Vpos
  include VposModule

  def initialize(token: set_token, pos_id: default_pos_id, payment_callback_url: default_payment_callback_url, refund_callback_url: default_refund_callback_url)
    @token = token
    @pos_id = pos_id
    @payment_callback_url = payment_callback_url
    @refund_callback_url = refund_callback_url
  end

  private
    def default_pos_id
      pos_id = ENV['GPO_POS_ID']
      unless !pos_id.nil?
        return 111
      end
      "#{pos_id}".to_i
    end

    def set_token
      token = ENV['MERCHANT_VPOS_TOKEN']
      "Bearer #{token}"
    end

    def default_payment_callback_url
      url = ENV['PAYMENT_CALLBACK_URL']
      unless !url.nil?
        return ""
      end
    end

    def default_refund_callback_url
      url = ENV['REFUND_CALLBACK_URL']
      unless !url.nil?
        return ""
      end
    end
end
