const test = require("node:test");
const assert = require("node:assert/strict");
const request = require("supertest");

const { createApp } = require("../app");

function createTestApp() {
  const fakePool = {
  async query(sql, params) {
    if (sql === "SELECT 1") {
      return [[{ 1: 1 }]];
    }

    if (sql.includes("FROM products WHERE id = ?")) {
      const id = Number(params[0]);

      if (id === 1) {
        return [
          [
            {
              id: 1,
              name: "Wireless Headphones",
              description: "Bluetooth over-ear headphones",
              price: "59.99",
              stock: 25,
              image_key: null,
              created_at: new Date().toISOString(),
            },
          ],
        ];
      }

      return [[]];
    }

    if (
      sql.startsWith(
        "SELECT id, name, description, price, stock, image_key, created_at FROM products ORDER BY id DESC"
      )
    ) {
      return [
        [
          {
            id: 1,
            name: "Wireless Headphones",
            description: "Bluetooth over-ear headphones",
            price: "59.99",
            stock: 25,
            image_key: null,
            created_at: new Date().toISOString(),
          },
        ],
      ];
    }

    throw new Error(`Unexpected SQL in test: ${sql}`);
  },
};

  const fakeUploadToS3 = async ({ key }) => key;

  const fakeGetPresignedDownloadUrl = async (key) =>
    `https://example.test/${encodeURIComponent(key)}`;

  return createApp({
    pool: fakePool,
    uploadToS3: fakeUploadToS3,
    getPresignedDownloadUrl: fakeGetPresignedDownloadUrl,
  });
}

test("GET / returns API information", async () => {
  const app = createTestApp();

  const response = await request(app).get("/");

  assert.equal(response.status, 200);
  assert.equal(response.body.name, "Production E-Commerce API");
  assert.equal(response.body.status, "running");
});

test("GET /health returns healthy when database is available", async () => {
  const app = createTestApp();

  const response = await request(app).get("/health");

  assert.equal(response.status, 200);
  assert.deepEqual(response.body, {
    status: "healthy",
    database: "connected",
  });
});

test("GET /api/products returns products", async () => {
  const app = createTestApp();

  const response = await request(app).get("/api/products");

  assert.equal(response.status, 200);
  assert.equal(response.body.length, 1);
  assert.equal(response.body[0].name, "Wireless Headphones");
});

test("GET /api/products/:id returns a product", async () => {
  const app = createTestApp();

  const response = await request(app).get("/api/products/1");

  assert.equal(response.status, 200);
  assert.equal(response.body.id, 1);
});

test("GET /api/products/:id returns 404 for unknown product", async () => {
  const app = createTestApp();

  const response = await request(app).get("/api/products/999");

  assert.equal(response.status, 404);
  assert.equal(response.body.error, "Product not found");
});

test("unknown route returns 404", async () => {
  const app = createTestApp();

  const response = await request(app).get("/does-not-exist");

  assert.equal(response.status, 404);
  assert.equal(response.body.error, "Route not found");
});
