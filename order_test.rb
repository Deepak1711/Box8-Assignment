require_relative "order"
require "test/unit"

class OrderTest < Test::Unit::TestCase
  # to test coupon applicable on outlet and discount calculation
  def test_box8love_coupon_applicable_on_outlet_and_discount_calculation
    cart_items = {
        "cart_items": [
          {
            "product_id": 1,
            "quantity": 1,
            "unit_cost": 200
          }
        ]
      }
    response = Order.new(cart_items).apply_promocode('BOX8LOVE', 1)
    assert_equal(true, response[:valid])
    assert_equal(Coupon::APPLICABLE_RESPONSE[:success], response[:message])
    assert_equal(20.0, response[:discount])
    assert_equal(0.0, response[:cashback])
  end

  # to test coupon not applicable on outlet
  def test_box8love_coupon_not_applicable_on_outlet
    cart_items = {
        "cart_items": [
          {
            "product_id": 1,
            "quantity": 1,
            "unit_cost": 200
          }
        ]
      }
    response = Order.new(cart_items).apply_promocode('BOX8LOVE', 7)
    assert_equal(false, response[:valid])
    assert_equal(Coupon::APPLICABLE_RESPONSE[:not_applicable_on_outlet], response[:message])
    assert_equal(0.0, response[:discount])
    assert_equal(0.0, response[:cashback])
  end

  def test_box8love_minimum_delivery_amount_test
    cart_items = {
        "cart_items": [
          {
            "product_id": 1,
            "quantity": 1,
            "unit_cost": 100
          }
        ]
      }
    response = Order.new(cart_items).apply_promocode('BOX8LOVE', 1)
    assert_equal(false, response[:valid])
    assert_equal('Delivery amount should be greater than or equal to 150', response[:message])
    assert_equal(0.0, response[:discount])
    assert_equal(0.0, response[:cashback])
  end

  def test_box8love_maximum_discount_and_zero_cashback
    cart_items = {
        "cart_items": [
          {
            "product_id": 1,
            "quantity": 5,
            "unit_cost": 500
          }
        ]
      }
    response = Order.new(cart_items).apply_promocode('BOX8LOVE', 1)
    assert_equal(true, response[:valid])
    assert_equal(Coupon::APPLICABLE_RESPONSE[:success], response[:message])
    assert_equal(200.0, response[:discount])
    assert_equal(0.0, response[:cashback])
  end

  def test_bogo_coupon_less_than_2_items_not_acceptible
    cart_items = {
        "cart_items": [
          {
            "product_id": 1,
            "quantity": 1,
            "unit_cost": 200
          }
        ]
      }
    response = Order.new(cart_items).apply_promocode('BOGO', 2)
    assert_equal(false, response[:valid])
    assert_equal(Coupon::APPLICABLE_RESPONSE[:minimum_cart_value], response[:message])
    assert_equal(0.0, response[:discount])
    assert_equal(0.0, response[:cashback])
  end

  def test_discount_and_cashback_calculation_for_odd_no_of_items
    cart_items = {
        "cart_items": [
          {
            "product_id": 1,
            "quantity": 2,
            "unit_cost": 100
          },
          {
            "product_id": 2,
            "quantity": 1,
            "unit_cost": 200
          }
        ]
      }
      response = Order.new(cart_items).apply_promocode('BOGO', 2)
      assert_equal(true, response[:valid])
      assert_equal(Coupon::APPLICABLE_RESPONSE[:success], response[:message])
      assert_equal(100.0, response[:discount])
      assert_equal(0.0, response[:cashback])
  end

  def test_discount_and_cashback_calculation_for_even_no_of_items_with_maximum_discount
    cart_items = {
        "cart_items": [
          {
            "product_id": 1,
            "quantity": 2,
            "unit_cost": 100
          },
          {
            "product_id": 2,
            "quantity": 2,
            "unit_cost": 200
          }
        ]
      }
      response = Order.new(cart_items).apply_promocode('BOGO', 2)
      assert_equal(true, response[:valid])
      assert_equal(Coupon::APPLICABLE_RESPONSE[:success], response[:message])
      # discount calculated is 200 acc to bogo but as maximum discount is 150, the max discount is applied
      assert_equal(150.0, response[:discount])
      assert_equal(0.0, response[:cashback])
  end
end
