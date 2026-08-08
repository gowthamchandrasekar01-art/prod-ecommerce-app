CREATE DATABASE IF NOT EXISTS ecommerce
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE ecommerce;

CREATE TABLE IF NOT EXISTS products (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  name VARCHAR(150) NOT NULL,
  description TEXT,
  price DECIMAL(10,2) NOT NULL,
  stock INT UNSIGNED NOT NULL DEFAULT 0,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  INDEX idx_products_created_at (created_at)
);

INSERT INTO products (name, description, price, stock)
SELECT 'Wireless Headphones', 'Bluetooth over-ear headphones', 59.99, 25
WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Wireless Headphones');

INSERT INTO products (name, description, price, stock)
SELECT 'Mechanical Keyboard', 'Compact mechanical keyboard', 89.99, 18
WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Mechanical Keyboard');

INSERT INTO products (name, description, price, stock)
SELECT 'USB-C Hub', 'Multi-port USB-C connectivity hub', 34.99, 40
WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'USB-C Hub');