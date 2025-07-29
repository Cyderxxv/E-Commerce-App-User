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

-- Create indexes for better performance
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