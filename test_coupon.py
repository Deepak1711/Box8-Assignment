import unittest
from datetime import datetime, timedelta
from coupon import Coupon

class TestCoupon(unittest.TestCase):
    def setUp(self):
        # Create a sample coupon for each test
        self.valid_coupon = Coupon(
            code="SAVE10",
            discount_percent=10,
            expiration_date=datetime.now() + timedelta(days=30),
            min_purchase=50.00
        )

    def test_valid_coupon_code(self):
        self.assertTrue(not self.valid_coupon.is_valid())
        
    def test_expired_coupon(self):
        expired_coupon = Coupon(
            code="EXPIRED",
            discount_percent=20,
            expiration_date=datetime.now() - timedelta(days=1),
            min_purchase=0
        )
        self.assertFalse(expired_coupon.is_valid())

    def test_calculate_discount(self):
        purchase_amount = 100.00
        expected_discount = 10.00  # 10% of 100
        self.assertEqual(
            self.valid_coupon.calculate_discount(purchase_amount),
            expected_discount
        )

    def test_minimum_purchase_requirement(self):
        # Test below minimum purchase
        self.assertFalse(
            self.valid_coupon.is_applicable(purchase_amount=40.00)
        )
        
        # Test at minimum purchase
        self.assertTrue(
            self.valid_coupon.is_applicable(purchase_amount=50.00)
        )
        
        # Test above minimum purchase
        self.assertTrue(
            self.valid_coupon.is_applicable(purchase_amount=60.00)
        )

    def test_invalid_discount_percent(self):
        with self.assertRaises(ValueError):
            Coupon(
                code="INVALID",
                discount_percent=101,  # More than 100%
                expiration_date=datetime.now() + timedelta(days=30),
                min_purchase=0
            )

    def test_empty_coupon_code(self):
        with self.assertRaises(ValueError):
            Coupon(
                code="",
                discount_percent=10,
                expiration_date=datetime.now() + timedelta(days=30),
                min_purchase=0
            )

if __name__ == '__main__':
    unittest.main() 