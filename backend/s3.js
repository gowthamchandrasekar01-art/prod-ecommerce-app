const {
  S3Client,
  PutObjectCommand,
  GetObjectCommand,
} = require("@aws-sdk/client-s3");

const { getSignedUrl } = require("@aws-sdk/s3-request-presigner");

const s3 = new S3Client({
  region: process.env.AWS_REGION || "ap-south-1",
});

async function uploadToS3({ key, body, contentType }) {
  const command = new PutObjectCommand({
    Bucket: process.env.S3_BUCKET,
    Key: key,
    Body: body,
    ContentType: contentType,
    ServerSideEncryption: "aws:kms",
    SSEKMSKeyId: process.env.KMS_KEY_ID,
  });

  await s3.send(command);

  return key;
}

async function getPresignedDownloadUrl(key) {
  const command = new GetObjectCommand({
    Bucket: process.env.S3_BUCKET,
    Key: key,
  });

  return getSignedUrl(s3, command, {
    expiresIn: 3600,
  });
}

module.exports = {
  uploadToS3,
  getPresignedDownloadUrl,
};
