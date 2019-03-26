require './coupon.rb'
require 'date'

class Order
  include Coupon
  attr_accessor :cart_items

  # cart items being passed when order is initialized,
  # as they may be useful for any other behavior as well such as calculating net total
  def initialize(cart_items)
    @cart_items = cart_items.to_hash
  end

  def apply_promocode(coupon_code, outlet_id)
    @coupon_details = COUPON_HASH[coupon_code.to_sym]
    apply_coupon(outlet_id)
    render_response
  end

  private

  def apply_coupon(outlet_id)
    return unless coupon_active?
    return unless applicable_on_outlet?(@coupon_details[:applicable_outlet_ids], outlet_id)
    apply_discount_and_cashback
  end

  def apply_discount_and_cashback
    items = cart_items[:cart_items]
    total_amount = 0
    item_amounts = []
    items.each do |item|
      total_amount += item[:unit_cost] * item[:quantity]
      item[:quantity].times { item_amounts << item[:unit_cost] }
    end
    calculate_discount_and_cashback(item_amounts, total_amount)
    net_amount = total_amount - @discount
    check_for_minimum_delivery_amount(net_amount)
  end

  def calculate_discount_and_cashback(item_amounts, total_amount)
    if @coupon_details[:type].eql?('Percentage')
      @discount = ((total_amount * @coupon_details[:value]) / 100).round(2)
    elsif @coupon_details[:type].eql?('Discount') || @coupon_details[:type].eql?('Discount&Cashback')
      @discount = @coupon_details[:value]
    elsif @coupon_details[:type].eql?('Bogo')
      @error_key = :minimum_cart_value if item_amounts.size < 2
      @discount = item_amounts.sort.first(item_amounts.size/2).inject(0){ |sum, value| sum + value }
    end
    @discount = @coupon_details[:maximum_discount] if @discount > @coupon_details[:maximum_discount]
    @cashback = @coupon_details[:cashback_value]
  end

  def coupon_active?
    valid = @coupon_details[:active] && applicable_on_date?
    @error_key = :not_active unless valid
    valid
  end

  def applicable_on_date?
    Date.today.between?(Date.parse(@coupon_details[:start_date]), Date.parse(@coupon_details[:end_date]))
  end

  def applicable_on_outlet?(coupon_applicable_outlets, order_outlet)
    valid = coupon_applicable_outlets.empty? || coupon_applicable_outlets.include?(order_outlet)
    @error_key = :not_applicable_on_outlet unless valid
    valid
  end

  def check_for_minimum_delivery_amount(net_amount)
    unless net_amount >= @coupon_details[:minimum_delivery_amount_after_discount]
      @discount = @cashback = 0.0
      @error_key = :below_minimum_delivery_amount
      APPLICABLE_RESPONSE.merge!({ below_minimum_delivery_amount:
        "Delivery amount should be greater than or equal to #{@coupon_details[:minimum_delivery_amount_after_discount]}"
      })
    end
  end

  def render_response
    {
      valid: @error_key ? false : true,
      message: APPLICABLE_RESPONSE[@error_key] || APPLICABLE_RESPONSE[:success],
      discount: @discount || 0.0,
      cashback: @cashback || 0.0
    }
  end
end
