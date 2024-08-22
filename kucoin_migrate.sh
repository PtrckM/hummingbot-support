#!/bin/bash
# 
# this script will migrate your main account (trading account and pro account) using your trading api+key
# also supported sub account (trading account and pro account) by using your main account trading api+key
# created by: Patrick
#
# Requirements: openssl and python
# Tested on: macos (intel), aws linux (ubuntu 20.04)
# usage: wget https://raw.githubusercontent.com/PtrckM/hummingbot-support/master/kucoin_migrate.sh
#        chmod +x kucoin_migrate.sh
#        ./kucoin_migrate.sh

# generate KC-API-SIGN
generate_signature() {
    local prehash="$1"
    echo -n "$prehash" | openssl dgst -sha256 -hmac "$API_SECRET" -binary | base64
}

# migrate account
migrate_user_account() {
    echo "Sending POST request to migrate $account_type account..."

    # not compatible with macos
    # TIMESTAMP=$(($(date +%s%N)/1000000))
    # workaround using python
    TIMESTAMP=$(python3 -c 'import time; print(int(time.time() * 1000))')
    PREHASH="$TIMESTAMP""POST""/api/v3/migrate/user/account$withAllSubs""$POST_DATA"
    SIGN=$(generate_signature "$PREHASH")

    response=$(curl -s -X POST "$API_URL/migrate/user/account$withAllSubs" \
    -H "KC-API-KEY: $API_KEY" \
    -H "KC-API-SIGN: $SIGN" \
    -H "KC-API-TIMESTAMP: $TIMESTAMP" \
    -H "KC-API-PASSPHRASE: $API_PASSPHRASE" \
    -H "Content-Type: application/json" \
    -d "$POST_DATA")

    echo "Response from server:"
    echo "$response"
}

# check the migration status
get_migration_status() {
    echo "Sending GET request to check migration status for $account_type account..."

    # not compatible with macos
    # TIMESTAMP=$(($(date +%s%N)/1000000))
    # workaround using python
    TIMESTAMP=$(python3 -c 'import time; print(int(time.time() * 1000))')
    PREHASH="$TIMESTAMP""GET""/api/v3/migrate/user/account/status$withAllSubs"
    SIGN=$(generate_signature "$PREHASH")

    response=$(curl -s -X GET "$API_URL/migrate/user/account/status$withAllSubs" \
    -H "KC-API-KEY: $API_KEY" \
    -H "KC-API-SIGN: $SIGN" \
    -H "KC-API-TIMESTAMP: $TIMESTAMP" \
    -H "KC-API-PASSPHRASE: $API_PASSPHRASE" \
    -H "Content-Type: application/json")

    echo "Response from server:"
    echo "$response"
}

# required api, secret and passphrase needs general and trading restrictions
read -p "Enter your KC-API-KEY: " API_KEY
read -p "Enter your KC-API-SECRET: " API_SECRET
read -p "Enter your KC-API-PASSPHRASE: " API_PASSPHRASE

# prompt main account or sub-account
read -p "Are you migrating a main account or sub-account? (main/sub): " account_type

# check account type
if [ "$account_type" = "sub" ]; then
    withAllSubs="?withAllSubs=true"
else
    withAllSubs=""
    account_type="main"
fi

# API URL
API_URL="https://api.kucoin.com/api/v3"

# response data 
POST_DATA='{}'

# account migration
migrate_user_account

# migration status
get_migration_status
