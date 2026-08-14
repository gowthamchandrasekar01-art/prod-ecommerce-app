const express = require("express");
const cors = require("cors");

function createApp({ pool, uploadToS3, getPresignedDownloadUrl }) {
  const app = express();

  app.disable("x-powered-by");
  app.use(express.json());

  app.use(
    cors({
      origin: "https://shopnest.gowthamcloud.site",
      methods: ["GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"],
      allowedHeaders: ["Content-Type", "Authorization"],
    })
  );

  app.post("/api/products/:id/image", async (req, res) => {
    try {
      const productId = Number(req.params.id);
      const { fileName, contentType, data } = req.body;

      if (!Number.isInteger(productId)) {
        return res.status(400).json({ error: "Invalid product ID" });
      }

      if (!fileName || !contentType || !data) {
        return res.status(400).json({
          error: "fileName, contentType and data are required",
        });
      }

      const [products] = await pool.query(
        "SELECT id FROM products WHERE id = ?",
        [productId]
      );

      if (products.length === 0) {
        return res.status(404).json({ error: "Product not found" });
      }

      const key = `products/${productId}/${Date.now()}-${fileName}`;
      const body = Buffer.from(data, "base64");

      await uploadToS3({
        key,
        body,
        contentType,
      });

      await pool.query(
        "UPDATE products SET image_key = ? WHERE id = ?",
        [key, productId]
      );

      return res.status(201).json({
        message: "Product image uploaded successfully",
        productId,
        imageKey: key,
      });
    } catch (error) {
      console.error("Product image upload failed:", error.message);

      return res.status(500).json({
        error: "Unable to upload product image",
      });
    }
  });

  app.get("/health", async (req, res) => {
    try {
      await pool.query("SELECT 1");

      return res.status(200).json({
        status: "healthy",
        database: "connected",
      });
    } catch (error) {
      console.error("Health check failed:", error.message);

      return res.status(503).json({
        status: "unhealthy",
        database: "unavailable",
      });
    }
  });

  app.get("/", (req, res) => {
    res.json({
      name: "Production E-Commerce API",
      version: "1.0.0",
      status: "running",
      endpoints: ["/health", "/api/products"],
    });
  });

  app.get("/api/products", async (req, res) => {
    try {
      const [rows] = await pool.query(
        "SELECT id, name, description, price, stock, image_key, created_at FROM products ORDER BY id DESC"
      );

      const products = await Promise.all(
        rows.map(async (product) => ({
          ...product,
          image_url: product.image_key
            ? await getPresignedDownloadUrl(product.image_key)
            : null,
        }))
      );

      return res.json(products);
    } catch (error) {
      console.error("Products query failed:", error.message);

      return res.status(500).json({
        error: "Unable to fetch products",
      });
    }
  });

  app.get("/api/products/:id", async (req, res) => {
    try {
      const [rows] = await pool.query(
        "SELECT id, name, description, price, stock, image_key, created_at FROM products WHERE id = ?",
        [req.params.id]
      );

      if (rows.length === 0) {
        return res.status(404).json({
          error: "Product not found",
        });
      }

      return res.json(rows[0]);
    } catch (error) {
      console.error("Product query failed:", error.message);

      return res.status(500).json({
        error: "Unable to fetch product",
      });
    }
  });

  app.use((req, res) => {
    res.status(404).json({
      error: "Route not found",
    });
  });

  return app;
}

module.exports = { createApp };
