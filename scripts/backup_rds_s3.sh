#!/bin/bash

set -e

PROJECT_DIR="/srv/cruz_azul-erp"
ENV_FILE="$PROJECT_DIR/frontend/.env"
BACKUP_DIR="$PROJECT_DIR/backups"
DATE=$(date +"%Y-%m-%d_%H-%M-%S")

S3_BUCKET="cruz-azul-backups-grupo4"
BACKUP_NAME="backup_cruzazul_${DATE}.dump"
BACKUP_FILE="${BACKUP_DIR}/${BACKUP_NAME}"

mkdir -p "$BACKUP_DIR"

set -a
source "$ENV_FILE"
set +a

echo "Iniciando backup de RDS PostgreSQL..."
echo "Base de datos: $DB_NAME"
echo "Host RDS: $DB_HOST"

docker run --rm \
  --network host \
  -e PGPASSWORD="$DB_PASSWORD" \
  -v "$BACKUP_DIR:/backup" \
  postgres:18-alpine \
  pg_dump \
  -h "$DB_HOST" \
  -p "$DB_PORT" \
  -U "$DB_USER" \
  -d "$DB_NAME" \
  -F c \
  --no-owner \
  --no-privileges \
  -f "/backup/$BACKUP_NAME"

echo "Backup generado localmente: $BACKUP_FILE"

aws s3 cp "$BACKUP_FILE" "s3://$S3_BUCKET/backups/$BACKUP_NAME" \
  --acl bucket-owner-full-control

echo "Backup enviado correctamente a S3:"
echo "s3://$S3_BUCKET/backups/$BACKUP_NAME"
