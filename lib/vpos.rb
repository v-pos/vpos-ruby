require_relative "vpos_module"
require "concurrent"

class Vpos
  include VposModule
  include Concurrent::Async

  def initialize(token: set_token, pos_id: default_pos_id, supervisor_card: default_supervisor_card, payment_callback_url: default_payment_callback_url, refund_callback_url: default_refund_callback_url)
    @token = token
    @pos_id = pos_id
    @supervisor_card = supervisor_card
    @payment_callback_url = payment_callback_url
    @refund_callback_url = refund_callback_url
  end

  private

  def default_pos_id
    pos_id = ENV['GPO_POS_ID']
    "#{pos_id}".to_i
  end

  def default_supervisor_card
    supervisor_card = ENV['GPO_SUPERVISOR_CARD']
    "#{supervisor_card}"
  end

  def set_token
    token = ENV['MERCHANT_VPOS_TOKEN']
    "Bearer #{token}"
  end

  def default_payment_callback_url
    ENV['PAYMENT_CALLBACK_URL']
  end

  def default_refund_callback_url
    ENV['REFUND_CALLBACK_URL']
  end
end
