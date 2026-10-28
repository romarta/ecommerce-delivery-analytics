-- Link orders to customers
ALTER TABLE orders
ADD CONSTRAINT fk_orders_customers
FOREIGN KEY (customer_id)
REFERENCES customers(customer_id);


-- Link order items to orders
ALTER TABLE order_items
ADD CONSTRAINT fk_items_orders
FOREIGN KEY (order_id)
REFERENCES orders(order_id);


-- Link order items to products
ALTER TABLE order_items
ADD CONSTRAINT fk_items_products
FOREIGN KEY (product_id)
REFERENCES products(product_id);


-- Link order items to sellers
ALTER TABLE order_items
ADD CONSTRAINT fk_items_sellers
FOREIGN KEY (seller_id)
REFERENCES sellers(seller_id);


-- Link payments to orders
ALTER TABLE order_payments
ADD CONSTRAINT fk_payments_orders
FOREIGN KEY (order_id)
REFERENCES orders(order_id);


-- Link reviews to orders
ALTER TABLE order_reviews
ADD CONSTRAINT fk_reviews_orders
FOREIGN KEY (order_id)
REFERENCES orders(order_id);