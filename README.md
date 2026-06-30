# Evaluación 4 – Arquitectura Multicloud Cruz Azul ERP

## Integrantes
- Daniel Castillo
- Raúl Matus
- Rocío Huanaco

## Objetivo
Implementar una infraestructura AWS segura, escalable y monitoreada para el ERP de Farmacias Cruz Azul.

## Arquitectura implementada
- Application Load Balancer público.
- Target Group HTTP puerto 3000 con health check /health.
- Auto Scaling Group: mínimo 1, deseada 4 y máximo 8 instancias.
- EC2 privadas con Node.js, Express y Docker.
- PostgreSQL 16 dockerizado en una EC2 privada.
- Amazon S3 privado con ACL para respaldos PostgreSQL.
- CloudWatch y SNS para monitoreo, alertas y notificaciones.
- MFA TOTP y JWT para acceso protegido al ERP.

## Seguridad
- SG-ALB: HTTP 80 desde Internet.
- SG-WEB: TCP 3000 solo desde el ALB.
- SG-DB: PostgreSQL 5432 solo desde las instancias web.
- Aplicación y base de datos en subredes privadas.
- Administración mediante Session Manager, sin SSH público.

## Pruebas realizadas
- Conexión frontend con PostgreSQL privado.
- Health check del ALB mediante /health.
- Registro automático de instancias en Target Group.
- Escalamiento y terminación automática según CPU.
- Alarmas CloudWatch y notificaciones SNS.
- Backup PostgreSQL hacia S3 con ACL privada.

## Backup PostgreSQL hacia S3
Desde la EC2 de base de datos ejecutar:
cd /srv/cruz_azul-erp
./scripts/backup_postgres_to_s3.sh

## Repositorio
https://github.com/Danizn20/Evaluacion_Multicloud_4
