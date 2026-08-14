const dotenv = require("dotenv");

const { createPool } = require("./db");
const {
  uploadToS3,
  getPresignedDownloadUrl,
} = require("./s3");
const { createApp } = require("./app");

dotenv.config();

const port = Number(process.env.PORT || 3000);
const pool = createPool();

const app = createApp({
  pool,
  uploadToS3,
  getPresignedDownloadUrl,
});

const server = app.listen(port, "0.0.0.0", () => {
  console.log(`E-commerce API listening on port ${port}`);
});

async function shutdown(signal) {
  console.log(`${signal} received. Closing server and database pool.`);

  server.close(async () => {
    try {
      await pool.end();
      process.exit(0);
    } catch (error) {
      console.error("Failed to close database pool:", error);
      process.exit(1);
    }
  });
}

process.on("SIGTERM", () => shutdown("SIGTERM"));
process.on("SIGINT", () => shutdown("SIGINT"));
