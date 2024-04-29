#!/bin/bash

export DEPLOY_NAME=$1
export DEPLOY_FQDN=$2

export RG_NAME=$(terraform output -raw resource_group_name)
export SA_NAME=$(terraform output -raw storage_account_name)
export SA_ACC_KEY=$(terraform output -raw storage_account_key)
export WS_ID=$(terraform output -raw loganalitycs_ws_id)
export WS_RES_ID=$(terraform output -raw loganalitycs_ws_resid)
export WS_ACC_KEY=$(terraform output -raw loganalitycs_ws_key)
export PG_SRV_FQDN=$(terraform output -raw pg_flex_serv_fqdn)
export DB_USER_NAME=$(terraform output -raw pg_user_name)
export DB_PASS=$(terraform output -raw pg_admin_pass)
export DB_NAME=$(terraform output -raw db_name)
export JDBC_URL="jdbc:postgresql://$PG_SRV_FQDN/$DB_NAME?currentSchema=public"

echo "Deploy Name: $DEPLOY_NAME"
echo "Deploy FQDN: $DEPLOY_FQDN"
echo "Resource Group Name: $RG_NAME"
echo "Storage Account Name: $SA_NAME"
echo "Storage Account Access key: $SA_ACC_KEY"
echo "Log Analytics Workspace ID: $WS_ID"
echo "Log Analytics Workspace Resource ID: $WS_RES_ID"
echo "Log Analytics Workspace Key: $WS_ACC_KEY"
echo "PG server FQDN: $PG_SRV_FQDN"
echo "PG server Admin Login: $DB_USER_NAME"
echo "PG server Admin Password: $DB_PASS"
echo "PG Database: $DB_NAME"
echo "JDBC URL: $JDBC_URL"