#! /bin/bash

cd $(dirname $0)

IBMCLOUD=$(pwd)/Bluemix_CLI/bin/ibmcloud
CF=~/.bluemix/.cf/cfcli/cf
#BLUE="\e[00;34m"
#RED="\e[00;31m"
#END="\e[0m"
BLUE=""
RED=""
END="==================================="

if [ ! -f "$IBMCLOUD" ]; then
    echo "${BLUE}download ibm-cloud-cli-release${END}"
    ver=$(curl -s https://github.com/IBM-Cloud/ibm-cloud-cli-release/releases/latest | grep -Po "(\d+\.){2}\d+")
    #ver=1.1.0
    wget -q -Oibm_cli.tgz https://clis.cloud.ibm.com/download/bluemix-cli/$ver/linux64
    if [ $? -eq 0 ]; then
        tar xzf ibm_cli.tgz
    else
        echo "${RED}download new version failed!${END}"
        exit 1
    fi
    rm -fv ibm_cli.tgz
fi

if [ ! -f "$CF" ]; then
    echo "${BLUE}ibmcloud cf install${END}"
    $IBMCLOUD cf install -f
fi

echo "${BLUE}cf login${END}"
$CF login -a https://api.eu-gb.cf.cloud.ibm.com <<EOF
$IBM_ACCOUNT
EOF

$CF restart $IBM_APP_NAME
