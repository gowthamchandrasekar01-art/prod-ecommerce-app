const express = require("express");
const dotenv = require("dotenv");
const { createPool } = require("./db");

dotenv.config();

const app = express();
const port = Number(process.env.PORT || 3000);
const pool = createPool();

app.disable("x-powered-by");
app.use(express.json());

app.get("/health", async (req, res) => {
  try {
    await pool.query("SELECT 1");
    res.status(200).json({ status: "healthy", database: "connected" });
  } catch (error) {
    console.error("Health check failed:", error.message);
    res.status(503).json({ status: "unhealthy", database: "unavailable" });
  }
});

app.get("/", (req, res) => {
  res.json({
    name: "Production E-Commerce API",
    version: "1.0.0",
    status: "running",
    endpoints: ["/health", "/api/products"]
  });
});

app.get("/api/products", async (req, res) => {
  try {
    const [rows] = await pool.query(
      "SELECT id, name, description, price, stock, created_at FROM products ORDER BY id DESC"
    );
    res.json(rows);
  } catch (error) {
    console.error("Products query failed:", error.message);
    res.status(500).json({ error: "Unable to fetch products" });
  }
});

app.get("/api/products/:id", async (req, res) => {
  try {
    const [rows] = await pool.query(
      "SELECT id, name, description, price, stock, created_at FROM products WHERE id = ?",
      [req.params.id]
    );

    if (rows.length === 0) {
      return res.status(404).json({ error: "Product not found" });
    }

    res.json(rows[0]);
  } catch (error) {
    console.error("Product query failed:", error.message);
    res.status(500).json({ error: "Unable to fetch product" });
  }
});

app.use((req, res) => {
  res.status(404).json({ error: "Route not found" });
});

app.listen(port, "0.0.0.0", () => {
  console.log(`E-commerce API listening on port ${port}`);
});

process.on("SIGTERM", async () => {
  console.log("SIGTERM received. Closing database pool.");
  await pool.end();
  process.exit(0);
});

process.on("SIGINT", async () => {
  console.log("SIGINT received. Closing database pool.");
  await pool.end();
  process.exit(0);
});