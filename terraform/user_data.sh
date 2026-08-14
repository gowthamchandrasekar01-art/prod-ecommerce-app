#!/bin/bash
set -e

LOG_FILE="/var/log/prod-ecommerce-bootstrap.log"
exec > >(tee -a "$LOG_FILE") 2>&1

echo "=== Starting production e-commerce bootstrap ==="

dnf update -y
dnf install -y git awscli python3

curl -fsSL https://rpm.nodesource.com/setup_22.x | bash -
dnf install -y nodejs

node --version
npm --version

npm install -g pm2

APP_DIR="/opt/prod-ecommerce-app"

if [ ! -d "$APP_DIR/.git" ]; then
    git clone https://github.com/gowthamchandrasekar01-art/prod-ecommerce-app.git "$APP_DIR"
else
    cd "$APP_DIR"
    git pull
fi

cd "$APP_DIR/backend"

npm install --omit=dev

SECRET_JSON=$(aws secretsmanager get-secret-value \
    --secret-id 'rds!db-ec91278d-0b6e-48e6-b85b-6be2e0e872b4' \
    --region ap-south-1 \
    --query SecretString \
    --output text
)

DB_PASSWORD=$(echo "$SECRET_JSON" | python3 -c '
import sys
import json
data = json.load(sys.stdin)
print(data["password"])
')

DB_USER=$(echo "$SECRET_JSON" | python3 -c '
import sys
import json
data = json.load(sys.stdin)
print(data["username"])
')

cat > "$APP_DIR/backend/.env" <<EOF
PORT=3000
AWS_REGION=ap-south-1
S3_BUCKET=prod-ecommerce-assets-809311528378-ap-south-1-an
KMS_KEY_ID=arn:aws:kms:ap-south-1:809311528378:key/e83a80b6-d4ad-4394-978d-0e91587551e9
DB_HOST=prod-ecommerce-db.cjueoqouego9.ap-south-1.rds.amazonaws.com
DB_PORT=3306
DB_NAME=ecommerce
DB_USER=${DB_USER}
DB_PASSWORD=${DB_PASSWORD}
EOF

chmod 600 "$APP_DIR/backend/.env"

cd "$APP_DIR/backend"

pm2 start server.js --name prod-ecommerce-api
pm2 save

pm2 startup systemd -u ec2-user --hp /home/ec2-user | tail -n 1 | bash || true

sleep 5

curl -f http://localhost:3000/health

echo "=== Production e-commerce bootstrap completed successfully ==="