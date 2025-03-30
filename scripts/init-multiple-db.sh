#!/bin/bash

set -e
set -u

# PostgreSQLの複数データベース作成スクリプト
# docker-compose.ymlのPOSTGRES_MULTIPLE_DATABASES環境変数で指定されたデータベースを作成します

function create_user_and_database() {
    local database=$1
    echo "  Creating user and database '$database'"
    psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
        CREATE USER $database WITH PASSWORD '$database';
        CREATE DATABASE $database;
        GRANT ALL PRIVILEGES ON DATABASE $database TO $database;
EOSQL
}

if [ -n "$POSTGRES_MULTIPLE_DATABASES" ]; then
    echo "Multiple database creation requested: $POSTGRES_MULTIPLE_DATABASES"
    for db in $(echo $POSTGRES_MULTIPLE_DATABASES | tr ',' ' '); do
        create_user_and_database $db
    done
    echo "Multiple databases created"
fi

# 各サービス用の特定の設定
echo "Configuring specific permissions for services"

# Keycloak用の設定
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "keycloak" <<-EOSQL
    ALTER USER keycloak WITH SUPERUSER;
EOSQL

# MidPoint用の設定
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "midpoint" <<-EOSQL
    CREATE SCHEMA IF NOT EXISTS midpoint;
    GRANT ALL PRIVILEGES ON SCHEMA midpoint TO midpoint;
EOSQL

# Kong用の設定
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "kong" <<-EOSQL
    ALTER USER kong WITH SUPERUSER;
EOSQL

echo "Database initialization completed"