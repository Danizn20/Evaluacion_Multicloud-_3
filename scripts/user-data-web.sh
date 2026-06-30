#!/bin/bash
set -e

systemctl enable --now docker
cd /srv/cruz_azul-erp
docker compose up -d
