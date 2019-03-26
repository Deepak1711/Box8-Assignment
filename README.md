# Box8-Assignment

cart_items = {
        "cart_items": [
          {
            "product_id": 1,
            "quantity": 1,
            "unit_cost": 200
          }
        ]
      }
      
 - Cart items are passed while creating order, because they can be used in any other action on order, hence making it generic for future.     
 Order.new(cart_items).apply_promocode('BOGO', 2)
 
 - Each test case is mentioned for any one of the coupon, not repetitively for all the coupons. The intention is to just give the idea of it.
 - To run the test cases
 ruby order_test.rb
