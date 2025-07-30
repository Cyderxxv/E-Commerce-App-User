CREATE TABLE users (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    phone_number TEXT UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    photo TEXT,
    full_name TEXT,
    date_of_birth DATE,
    address TEXT,
    gender TEXT,
    status TEXT DEFAULT 'ACTIVE',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE products (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name TEXT NOT NULL,
    description TEXT,
    price NUMERIC(10, 2) NOT NULL,
    stock INT NOT NULL,
    image_url TEXT,
    rating NUMERIC(2,1) DEFAULT 0,
    review_count INT DEFAULT 0,
    brand TEXT,
    is_featured BOOLEAN DEFAULT FALSE,
    is_available BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE carts (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    user_id BIGINT REFERENCES users(id),
    product_id BIGINT REFERENCES products(id),
    quantity INT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE orders (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    user_id BIGINT REFERENCES users(id),
    total_amount NUMERIC(10, 2) NOT NULL,
    status TEXT NOT NULL,
    payment_method_id BIGINT,
    is_installment BOOLEAN DEFAULT FALSE,
    shipping_address TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE order_items (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    order_id BIGINT REFERENCES orders(id),
    product_id BIGINT REFERENCES products(id),
    quantity INT NOT NULL,
    price NUMERIC(10, 2) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE admins (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    username TEXT UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE transactions (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    user_id BIGINT REFERENCES users(id),
    order_id BIGINT REFERENCES orders(id),
    amount NUMERIC(10, 2) NOT NULL,
    transaction_date TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE categories (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name TEXT NOT NULL,
    icon TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE product_categories (
    product_id BIGINT REFERENCES products(id),
    category_id BIGINT REFERENCES categories(id),
    PRIMARY KEY (product_id, category_id)
);

CREATE TABLE payment_methods (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name TEXT NOT NULL,
    is_installment BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE installment_plans (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    order_id BIGINT REFERENCES orders(id),
    user_id BIGINT REFERENCES users(id),
    total_amount NUMERIC(10, 2) NOT NULL,
    total_months INT NOT NULL,
    monthly_payment NUMERIC(10, 2) NOT NULL,
    paid_months INT DEFAULT 0,
    paid_amount NUMERIC(10, 2) DEFAULT 0,
    status TEXT DEFAULT 'ACTIVE', -- ACTIVE, COMPLETED, OVERDUE
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE installment_payments (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    installment_plan_id BIGINT REFERENCES installment_plans(id),
    month_number INT NOT NULL,
    due_date DATE NOT NULL,
    amount NUMERIC(10, 2) NOT NULL,
    paid_date TIMESTAMPTZ,
    status TEXT DEFAULT 'PENDING', -- PENDING, PAID, OVERDUE
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE wishlists (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    user_id BIGINT REFERENCES users(id),
    product_id BIGINT REFERENCES products(id),
    added_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(user_id, product_id)
);

CREATE TABLE reviews (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    user_id BIGINT REFERENCES users(id),
    product_id BIGINT REFERENCES products(id),
    rating NUMERIC(2,1) NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(user_id, product_id)
);

CREATE TABLE purchase_history (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    user_id BIGINT REFERENCES users(id),
    order_id BIGINT REFERENCES orders(id),
    product_id BIGINT REFERENCES products(id),
    product_name TEXT NOT NULL,
    product_image_url TEXT,
    quantity INT NOT NULL,
    unit_price NUMERIC(10, 2) NOT NULL,
    total_price NUMERIC(10, 2) NOT NULL,
    order_status TEXT NOT NULL, -- PENDING, PROCESSING, SHIPPED, DELIVERED, CANCELLED
    payment_method TEXT,
    is_installment BOOLEAN DEFAULT FALSE,
    installment_months INT,
    monthly_payment NUMERIC(10, 2),
    purchase_date TIMESTAMPTZ NOT NULL,
    delivery_date TIMESTAMPTZ,
    tracking_number TEXT,
    shipping_address TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE notifications (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    user_id BIGINT REFERENCES users(id),
    title TEXT NOT NULL,
    message TEXT NOT NULL,
    type TEXT NOT NULL, -- ORDER, PAYMENT, PROMOTION, etc.
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Add foreign key constraint for orders payment_method_id
ALTER TABLE orders ADD CONSTRAINT fk_orders_payment_method 
    FOREIGN KEY (payment_method_id) REFERENCES payment_methods(id);

-- Insert default payment methods
INSERT INTO payment_methods (name, is_installment) VALUES 
('Cash', FALSE),
('Installment', TRUE),
('Credit Card', FALSE),
('Bank Transfer', FALSE);

-- Insert default categories
INSERT INTO categories (name, icon) VALUES 
('Phones', 'phone'),
('Laptops', 'laptop'),
('Tablets', 'tablet'),
('Smart Watches', 'watch'),
('Headphones', 'headphone'),
('Accessories', 'accessory');

-- Insert sample data

-- Sample users
INSERT INTO users (name, email, phone_number, password_hash, photo, full_name, date_of_birth, address, gender) VALUES 
('Test User', 'test@example.com', '+84987654321', '123456', 'https://i.pravatar.cc/150?img=1', 'Test User Demo', '1990-01-01', 'Ho Chi Minh City, Vietnam', 'Male'),
('John Doe', 'john@email.com', '+1234567890', '$2a$10$hashedpassword1', 'https://avatar.com/john.jpg', 'John Michael Doe', '1990-05-15', '123 Main St, City, State', 'Male'),
('Jane Smith', 'jane@email.com', '+1234567891', '$2a$10$hashedpassword2', 'https://avatar.com/jane.jpg', 'Jane Elizabeth Smith', '1988-12-20', '456 Oak Ave, City, State', 'Female'),
('Bob Wilson', 'bob@email.com', '+1234567892', '$2a$10$hashedpassword3', 'https://avatar.com/bob.jpg', 'Robert James Wilson', '1995-03-10', '789 Pine Rd, City, State', 'Male');

-- Sample products
INSERT INTO products (name, description, price, stock, image_url, rating, review_count, brand, is_featured, is_available) VALUES 
('Samsung Galaxy S25 Edge (12/256GB)', 'Samsung flagship with curved-edge design and powerful performance. Display: 6.8" Dynamic AMOLED 2X, QHD+, 144Hz. CPU: Snapdragon 8 Elite for Galaxy. RAM: 12GB. Storage: 256GB UFS 4.0', 25650600, 50, 'https://cdn.viettablet.com/images/detailed/66/samsung-galaxy-s25-edge-111.jpg', 4.9, 256, 'Samsung', TRUE, TRUE),
('Xiaomi 15S PRO (12/256GB)', 'Affordable powerhouse with premium features', 14550200, 30, 'https://cdn.mobilecity.vn/mobilecity-vn/images/2025/05/w300/xiaomi-15s-pro-den-cac-bon.jpg.webp', 4.8, 128, 'Xiaomi', TRUE, TRUE),
('Apple iPhone 16 Pro Max (12/256GB)', 'Apple latest flagship with advanced camera', 32990000, 20, 'https://cdn2.cellphones.com.vn/insecure/rs:fill:0:358/q:90/plain/https://cellphones.com.vn/media/catalog/product/i/p/iphone-16-pro-2.png', 4.7, 300, 'Apple', TRUE, TRUE),
('Samsung Galaxy Z Flip6 (12/256GB)', 'Foldable innovation for the modern user', 20550200, 25, 'https://cdn2.cellphones.com.vn/insecure/rs:fill:0:358/q:90/plain/https://cellphones.com.vn/media/catalog/product/s/a/samsung-galaxy-z-flip-6-xanh-duong-4_2.png', 4.0, 52, 'Samsung', FALSE, TRUE),
('Samsung Galaxy Z Fold6 (12/256GB)', 'Tablet and phone in one foldable device', 30550200, 40, 'https://thetekcoffee.com/wp-content/uploads/2024/07/galaxy-z-fold6-han-quoc.png', 4.5, 72, 'Samsung', FALSE, TRUE),
('Apple MacBook Air M4 13-inch (16/512GB)', 'Sleek and powerful laptop with Apple M4 chip. Display: 13.6" Liquid Retina, 2560x1664. CPU: Apple M4 10-core. RAM: 16GB. Ports: 2x Thunderbolt 4, MagSafe 3', 29990000, 60, 'https://bizweb.dktcdn.net/100/453/356/products/mbair-13inch-m4-midnight-1744562440665.jpg?v=1747827209317', 4.8, 180, 'Apple', TRUE, TRUE),
('Asus Zenbook S 14 (16/1TB)', 'Premium ultrabook with stunning OLED display. Display: 14" 3K OLED, 120Hz. CPU: Intel Core Ultra 7 155H. RAM: 16GB LPDDR5X', 35990000, 80, 'https://sazo.vn/storage/products/zenbook-s14/4.png', 4.7, 95, 'Asus', FALSE, TRUE),
('Apple Watch Series 10 (46mm)', 'Advanced smartwatch with comprehensive health tracking. Display: 46mm OLED Retina, Always-On. Processor: S10 SiP. Features: ECG, Blood Oxygen, Sleep Tracking', 9990000, 35, 'https://store.storeimages.cdn-apple.com/1/as-images.apple.com/is/MXM23ref_FV99_VW_34FR+watch-case-46-aluminum-jetblack-nc-s10_VW_34FR+watch-face-46-aluminum-jetblack-s10_VW_34FR?wid=752&hei=720&bgc=fafafa&trim=1&fmt=p-jpg&qlt=80&.v=TnVrdDZWRlZzTURKbHFqOGh0dGpVRW5TeWJ6QW43NUFnQ2V4cmRFc1VnYUdWejZ5THhpKzJwRmRDYlhxN2o5aXB2QjR6TEZ4ZThxM3VqYkZobmlXM3RGNnlaeXQ4NGFKQTAzc0NGeHR2aVk0VEhOZEFKYmY1ZHNpalQ3YVhOWk9WV', 4.8, 250, 'Apple', TRUE, TRUE);

-- Link products to categories
INSERT INTO product_categories (product_id, category_id) VALUES 
(1, 1), -- Samsung Galaxy S25 -> Phones
(2, 1), -- Xiaomi 15S PRO -> Phones
(3, 1), -- iPhone 16 Pro Max -> Phones
(4, 1), -- Galaxy Z Flip6 -> Phones
(5, 1), -- Galaxy Z Fold6 -> Phones
(6, 2), -- MacBook Air -> Laptops
(7, 2), -- Asus Zenbook -> Laptops
(8, 4); -- Apple Watch -> Smart Watches

-- Sample admin
INSERT INTO admins (username, password_hash) VALUES 
('admin', '$2a$10$hashedadminpassword');

-- Sample cart items
INSERT INTO carts (user_id, product_id, quantity) VALUES 
(1, 1, 1), -- Test User has Samsung Galaxy S25 in cart
(1, 6, 1), -- Test User has MacBook in cart
(2, 2, 2), -- John has 2 Xiaomi 15S in cart
(3, 8, 1); -- Bob has Apple Watch in cart

-- Sample orders
INSERT INTO orders (user_id, total_amount, status, payment_method_id, is_installment, shipping_address) VALUES 
(1, 25650600, 'DELIVERED', 1, FALSE, 'Ho Chi Minh City, Vietnam'),
(2, 29990000, 'PROCESSING', 2, TRUE, '123 Main St, City, State'),
(3, 9990000, 'SHIPPED', 3, FALSE, '789 Pine Rd, City, State');

-- Sample order items
INSERT INTO order_items (order_id, product_id, quantity, price) VALUES 
(1, 1, 1, 25650600),
(2, 6, 1, 29990000),
(3, 8, 1, 9990000);

-- Sample transactions
INSERT INTO transactions (user_id, order_id, amount) VALUES 
(1, 1, 25650600),
(2, 2, 5998000), -- Initial installment payment
(3, 3, 9990000);

-- Sample installment plan
INSERT INTO installment_plans (order_id, user_id, total_amount, total_months, monthly_payment, paid_months, paid_amount) VALUES 
(2, 2, 29990000, 12, 2499167, 2, 4998334);

-- Sample installment payments
INSERT INTO installment_payments (installment_plan_id, month_number, due_date, amount, paid_date, status) VALUES 
(1, 1, '2024-02-01', 2499167, '2024-02-01 10:30:00', 'PAID'),
(1, 2, '2024-03-01', 2499167, '2024-03-01 14:15:00', 'PAID'),
(1, 3, '2024-04-01', 2499167, NULL, 'PENDING'),
(1, 4, '2024-05-01', 2499167, NULL, 'PENDING');

-- Sample wishlists
INSERT INTO wishlists (user_id, product_id) VALUES 
(1, 6), -- John wants MacBook
(1, 3), -- John wants iPhone 16 Pro Max
(2, 1), -- Jane wants Samsung Galaxy S25
(3, 5); -- Bob wants Galaxy Z Fold

-- Sample reviews
INSERT INTO reviews (user_id, product_id, rating, comment) VALUES 
(1, 1, 5.0, 'Amazing phone! The display quality is outstanding and performance is smooth.'),
(1, 7, 4.5, 'Great laptop for productivity, but could be better for gaming.'),
(3, 4, 4.0, 'Good foldable phone, battery life could be improved.');

-- Sample notifications
INSERT INTO notifications (user_id, title, message, type, is_read) VALUES 
(1, 'Order Delivered', 'Your Samsung Galaxy S25 Edge has been delivered successfully.', 'ORDER', TRUE),
(2, 'Payment Due', 'Your MacBook installment payment is due in 3 days.', 'PAYMENT', FALSE),
(3, 'Order Shipped', 'Your Galaxy Z Flip6 is on the way!', 'ORDER', FALSE),
(1, 'Special Offer', 'Get 20% off on all Samsung products this week!', 'PROMOTION', FALSE);

-- Sample purchase history (historical data)
INSERT INTO purchase_history (user_id, order_id, product_id, product_name, product_image_url, quantity, unit_price, total_price, order_status, payment_method, is_installment, purchase_date, delivery_date, shipping_address) VALUES 
-- Test User's delivered Samsung Galaxy S25
(11, 1, 1, 'Samsung Galaxy S25 Edge (12/256GB)', 'https://cdn.viettablet.com/images/detailed/66/samsung-galaxy-s25-edge-111.jpg', 1, 25650600, 25650600, 'DELIVERED', 'Cash', FALSE, '2024-01-15 10:30:00', '2024-01-20 14:30:00', 'Ho Chi Minh City, Vietnam'),

-- John's MacBook with installment
(11, 2, 6, 'Apple MacBook Air M4 13-inch (16/512GB)', 'https://bizweb.dktcdn.net/100/453/356/products/mbair-13inch-m4-midnight-1744562440665.jpg?v=1747827209317', 1, 29990000, 29990000, 'PROCESSING', 'Installment', TRUE, '2024-01-20 09:15:00', NULL, '123 Main St, City, State'),

-- Bob's Apple Watch
(11, 3, 8, 'Apple Watch Series 10 (46mm)', 'https://store.storeimages.cdn-apple.com/1/as-images.apple.com/is/MXM23ref_FV99_VW_34FR+watch-case-46-aluminum-jetblack-nc-s10_VW_34FR+watch-face-46-aluminum-jetblack-s10_VW_34FR?wid=752&hei=720&bgc=fafafa&trim=1&fmt=p-jpg&qlt=80&.v=TnVrdDZWRlZzTURKbHFqOGh0dGpVRW5TeWJ6QW43NUFnQ2V4cmRFc1VnYUdWejZ5THhpKzJwRmRDYlhxN2o5aXB2QjR6TEZ4ZThxM3VqYkZobmlXM3RGNnlaeXQ4NGFKQTAzc0NGeHR2aVk0VEhOZEFKYmY1ZHNpalQ3YVhOWk9WV', 1, 9990000, 9990000, 'SHIPPED', 'Credit Card', FALSE, '2024-01-25 16:45:00', NULL, '789 Pine Rd, City, State'),

-- Additional historical purchases for Test User
(1, NULL, 2, 'Xiaomi 15S PRO (12/256GB)', 'https://cdn.mobilecity.vn/mobilecity-vn/images/2025/05/w300/xiaomi-15s-pro-den-cac-bon.jpg.webp', 1, 14550200, 14550200, 'DELIVERED', 'Bank Transfer', FALSE, '2023-12-10 11:20:00', '2023-12-15 09:30:00', 'Ho Chi Minh City, Vietnam'),

(1, NULL, 4, 'Samsung Galaxy Z Flip6 (12/256GB)', 'https://cdn2.cellphones.com.vn/insecure/rs:fill:0:358/q:90/plain/https://cellphones.com.vn/media/catalog/product/s/a/samsung-galaxy-z-flip-6-xanh-duong-4_2.png', 1, 20550200, 20550200, 'DELIVERED', 'Cash', FALSE, '2023-11-05 14:10:00', '2023-11-10 16:45:00', 'Ho Chi Minh City, Vietnam');

-- Update installment information for John's MacBook
UPDATE purchase_history 
SET installment_months = 12, monthly_payment = 2499167
WHERE user_id = 2 AND order_id = 2;

-- Create view for easy purchase history queries
CREATE VIEW user_purchase_history AS
SELECT 
    ph.id,
    ph.user_id,
    u.name as user_name,
    u.email as user_email,
    ph.order_id,
    ph.product_id,
    ph.product_name,
    ph.product_image_url,
    ph.quantity,
    ph.unit_price,
    ph.total_price,
    ph.order_status,
    ph.payment_method,
    ph.is_installment,
    ph.installment_months,
    ph.monthly_payment,
    ph.purchase_date,
    ph.delivery_date,
    ph.tracking_number,
    ph.shipping_address,
    CASE 
        WHEN ph.order_status = 'DELIVERED' THEN 'Completed'
        WHEN ph.order_status = 'CANCELLED' THEN 'Cancelled'
        WHEN ph.order_status = 'SHIPPED' THEN 'In Transit'
        WHEN ph.order_status = 'PROCESSING' THEN 'Processing'
        ELSE 'Pending'
    END as status_display,
    -- Calculate days since purchase
    EXTRACT(DAYS FROM NOW() - ph.purchase_date) as days_since_purchase,
    -- Calculate remaining installments if applicable
    CASE 
        WHEN ph.is_installment AND ip.paid_months IS NOT NULL 
        THEN ph.installment_months - ip.paid_months 
        ELSE NULL 
    END as remaining_installments,
    -- Calculate paid amount for installments
    CASE 
        WHEN ph.is_installment AND ip.paid_amount IS NOT NULL 
        THEN ip.paid_amount 
        ELSE ph.total_price 
    END as paid_amount
FROM purchase_history ph
JOIN users u ON ph.user_id = u.id
LEFT JOIN installment_plans ip ON ph.order_id = ip.order_id
ORDER BY ph.purchase_date DESC;

-- Create indexes for better performance
CREATE INDEX idx_purchase_history_user_id ON purchase_history(user_id);
CREATE INDEX idx_purchase_history_order_id ON purchase_history(order_id);
CREATE INDEX idx_purchase_history_product_id ON purchase_history(product_id);
CREATE INDEX idx_purchase_history_purchase_date ON purchase_history(purchase_date);
CREATE INDEX idx_purchase_history_order_status ON purchase_history(order_status);
CREATE INDEX idx_wishlists_user_id ON wishlists(user_id);
CREATE INDEX idx_wishlists_product_id ON wishlists(product_id);
CREATE INDEX idx_product_categories_product_id ON product_categories(product_id);
CREATE INDEX idx_product_categories_category_id ON product_categories(category_id);
CREATE INDEX idx_reviews_product_id ON reviews(product_id);
CREATE INDEX idx_reviews_user_id ON reviews(user_id);
CREATE INDEX idx_notifications_user_id ON notifications(user_id);
CREATE INDEX idx_installment_payments_plan_id ON installment_payments(installment_plan_id);
CREATE INDEX idx_orders_user_id ON orders(user_id);
CREATE INDEX idx_carts_user_id ON carts(user_id);

-- Function to automatically create purchase history when order is created
CREATE OR REPLACE FUNCTION create_purchase_history()
RETURNS TRIGGER AS $$
BEGIN
    -- Insert purchase history for each order item
    INSERT INTO purchase_history (
        user_id, 
        order_id, 
        product_id, 
        product_name, 
        product_image_url,
        quantity, 
        unit_price, 
        total_price,
        order_status,
        payment_method,
        is_installment,
        installment_months,
        monthly_payment,
        purchase_date,
        shipping_address
    )
    SELECT 
        NEW.user_id,
        NEW.id,
        oi.product_id,
        p.name,
        p.image_url,
        oi.quantity,
        oi.price,
        oi.quantity * oi.price,
        NEW.status,
        pm.name,
        NEW.is_installment,
        CASE WHEN NEW.is_installment THEN ip.total_months ELSE NULL END,
        CASE WHEN NEW.is_installment THEN ip.monthly_payment ELSE NULL END,
        NEW.created_at,
        NEW.shipping_address
    FROM order_items oi
    JOIN products p ON oi.product_id = p.id
    LEFT JOIN payment_methods pm ON NEW.payment_method_id = pm.id
    LEFT JOIN installment_plans ip ON NEW.id = ip.order_id
    WHERE oi.order_id = NEW.id;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Function to update purchase history when order status changes
CREATE OR REPLACE FUNCTION update_purchase_history_status()
RETURNS TRIGGER AS $$
BEGIN
    -- Update purchase history status when order status changes
    UPDATE purchase_history 
    SET 
        order_status = NEW.status,
        delivery_date = CASE WHEN NEW.status = 'DELIVERED' THEN NOW() ELSE delivery_date END,
        updated_at = NOW()
    WHERE order_id = NEW.id;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Triggers
CREATE TRIGGER trigger_create_purchase_history
    AFTER INSERT ON orders
    FOR EACH ROW
    EXECUTE FUNCTION create_purchase_history();

CREATE TRIGGER trigger_update_purchase_history_status
    AFTER UPDATE ON orders
    FOR EACH ROW
    WHEN (OLD.status IS DISTINCT FROM NEW.status)
    EXECUTE FUNCTION update_purchase_history_status();