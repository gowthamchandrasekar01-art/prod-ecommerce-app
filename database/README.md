# Database

`schema.sql` creates the `ecommerce` database and the `products` table and inserts sample products.

For the AWS deployment, the database will live in Amazon RDS for MySQL. Database credentials should be stored in AWS Secrets Manager rather than committed to this repository.