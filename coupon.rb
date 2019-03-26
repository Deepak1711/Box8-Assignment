module Coupon
  COUPON_HASH = {
    BOX8LOVE: {
      id: 1,
      type: "Percentage",
      value: 10,
      cashback_value: 0,
      start_date: "2015-07-01",
      end_date: "2019-12-31",
      active: true,
      applicable_outlet_ids: [1, 2, 3, 4, 5, 6],
      minimum_delivery_amount_after_discount: 150,
      maximum_discount: 200
    },
    HELLOBOX8: {
      id: 2,
      type: "Discount",
      value: 150,
      cashback_value: 0,
      start_date: "2015-07-01",
      end_date: "2019-12-31",
      active: true,
      applicable_outlet_ids: [],
      minimum_delivery_amount_after_discount: 100,
      maximum_discount: 150
    },
    GETCASHBACK: {
      id: 3,
      type: "Discount&Cashback",
      value: 150,
      cashback_value: 150,
      start_date: "2015-07-01",
      end_date: "2019-12-31",
      active: true,
      applicable_outlet_ids: [],
      minimum_delivery_amount_after_discount: 200,
      maximum_discount: 150
    },
    BOGO: {
      id: 4,
      type: "Bogo",
      value: 0,
      cashback_value: 0,
      start_date: "2015-07-01",
      end_date: "2019-12-31",
      active: true,
      applicable_outlet_ids: [2, 3, 10],
      minimum_delivery_amount_after_discount: 200,
      maximum_discount: 150
    }
  }

  APPLICABLE_RESPONSE = {
    success: 'Coupon applied',
    not_active: 'Coupon is no more active.',
    not_applicable_on_outlet: 'Coupon is not applicable on this outlet.',
    minimum_cart_value: 'Coupon is applicable on purchase of 2 or more items'
  }
end
