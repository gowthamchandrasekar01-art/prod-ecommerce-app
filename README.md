# Production E-Commerce Application

A deliberately small Node.js + Express + MySQL application used as the application layer for the **AWS Highly Available E-Commerce Application Architecture** project.

## Stack

- Node.js
- Express
- MySQL
- Amazon RDS for MySQL in AWS
- AWS Secrets Manager for database credentials
- Application Load Balancer health checks

## API

| Method | Endpoint | Purpose |
|---|---|---|
| GET | `/` | Application information |
| GET | `/health` | Load balancer health check |
| GET | `/api/products` | List products |
| GET | `/api/products/:id` | Get one product |

The application listens on port `3000` by default.

## Local setup

Requirements:

- Node.js 20+
- MySQL 8+

### 1. Create the database

Run:

```sql
SOURCE database/schema.sql;
```

### 2. Configure the backend

```bash
cd backend
cp .env.example .env
```

Set the local MySQL values in `.env`.

### 3. Install dependencies

```bash
npm install
```

### 4. Start

```bash
npm start
```

Test:

```text
http://localhost:3000/health
http://localhost:3000/api/products
```

## AWS deployment notes

In the AWS project, the backend will run on private EC2 instances behind an Application Load Balancer.

Expected architecture:

```text
Internet
   |
Application Load Balancer
   |
Private EC2 Auto Scaling Group
   |
Amazon RDS for MySQL
```

The EC2 instance role should have only the permissions required by the application. Database credentials should be retrieved from AWS Secrets Manager at runtime.

Do not commit `.env`, passwords, access keys, or other secrets.