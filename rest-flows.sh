#!/bin/bash
# usage: ./rest-flows.sh {site} {ONOS IP}
# ex): ./rest-flows.sh co1 10.128.14.121

SITE=$1
ONOS_IP=$2

API_ENDPOINT="http://"${ONOS_IP}":8181/onos/v1/flows/"
USER_PASS="karaf:karaf"
LEAF101="of:0000000000000065"
LEAF102="of:0000000000000066"
SPINE12="of:000000000000000c"
LEAF201="of:00000000000000c9"
LEAF202="of:00000000000000ca"
SPINE22="of:0000000000000016"
LEAF301="of:000000000000012d"
LEAF302="of:000000000000012e"
SPINE32="of:0000000000000020"

function curl_req_post () {
    curl -X POST --header "Content-Type: application/json" --header "Accept: application/json" -d@${1} ${API_ENDPOINT}${2} --user $USER_PASS
}

function curl_req_get () {
    curl -X GET --header "Content-Type: application/json" --header "Accept: application/json" ${API_ENDPOINT}${1} --user $USER_PASS
}

function getDeviceId () {
    if [ $1 = "leaf101" ]; then
	echo $LEAF101
    elif [ $1 = "spine12" ]; then
	echo $SPINE12
    elif [ $1 = "leaf102" ]; then
	echo $LEAF102
    elif [ $1 = "leaf201" ]; then
	echo $LEAF201
    elif [ $1 = "spine22" ]; then
	echo $SPINE22
    elif [ $1 = "leaf202" ]; then
	echo $LEAF202
    elif [ $1 = "leaf301" ]; then
	echo $LEAF301
    elif [ $1 = "spine32" ]; then
	echo $SPINE32
    elif [ $1 = "leaf302" ]; then
	echo $LEAF302
    fi
}

function vlan () {
    deviceId=`getDeviceId $1`
    inport=$2
    outport=$3
    vlanId=$4
    filepath=/tmp/${deviceId}-${inport}-${outport}-vlan-${vlanId}.json
    json=`cat << EOF
{
    "priority": 65000,
    "isPermanent": true,
    "deviceId": "${deviceId}",
    "treatment": {
	"instructions":[
	    { "type": "OUTPUT",
	      "port": "${outport}"
	    }
	]
    },
    "selector": {
	"criteria": [
	    {
		"type": "IN_PORT",
		"port": "${inport}"
	    },
	    {
		"type": "VLAN_VID",
		"vlanId": "${vlanId}"
	    }
	]
    }
}
EOF`
    echo $json > $filepath
    curl_req_post $filepath $deviceId
}

function pass () {
    deviceId=`getDeviceId $1`
    inport=$2
    outport=$3
    filepath=/tmp/${deviceId}-${inport}-${outport}-pass.json
    json=`cat << EOF
{
    "priority": 30000,
    "isPermanent": true,
    "deviceId": "${deviceId}",
    "treatment": {
	"instructions":[
	    { "type": "OUTPUT",
	      "port": "${outport}"
	    }
	]
    },
    "selector": {
	"criteria": [
	    {
		"type": "IN_PORT",
		"port": "${inport}"
	    }
	]
    }
}
EOF`
    echo $json > $filepath
    curl_req_post $filepath $deviceId
}

function ip () {
    deviceId=`getDeviceId $1`
    inport=$2
    outport=$3
    ipsrc=$4
    ipdst=$5
    filepath=/tmp/${deviceId}-${inport}-${outport}-ip.json
    json=`cat << EOF
{
    "priority": 65000,
    "isPermanent": true,
    "deviceId": "${deviceId}",
    "treatment": {
	"instructions":[
	    { "type": "OUTPUT",
	      "port": "${outport}"
	    }
	]
    },
    "selector": {
	"criteria": [
	    {
		"type": "IN_PORT",
		"port": "${inport}"
	    },
	    {
		"type": "ETH_TYPE",
		"ethType": "0x800"
	    },
            {
                "type": "IPV4_SRC",
                "ip": "${ipsrc}"
            },
            {
                "type": "IPV4_DST",
                "ip": "${ipdst}"
            }
	]
    }
}
EOF`
    echo $json > $filepath
    curl_req_post $filepath $deviceId
}



if [ $SITE = "co1" ]; then
    vlan leaf101 1 4 100
    vlan leaf101 4 1 100
    vlan leaf101 1 4 200
    vlan leaf101 4 1 200
    pass leaf101 4 3
    pass leaf101 3 4
    pass spine12 1 2
    pass spine12 2 1
    ip leaf102 1 3 192.168.4.1/32 192.168.4.2/32
    ip leaf102 3 1 192.168.4.2/32 192.168.4.1/32
    ip leaf102 1 4 192.168.4.1/32 192.168.4.3/32
    ip leaf102 4 1 192.168.4.3/32 192.168.4.1/32
elif [ $SITE = "co2" ]; then
    vlan leaf201 1 4 100
    vlan leaf201 4 1 100
    pass leaf201 4 2
    pass leaf201 2 4
    pass spine22 1 2
    pass spine22 2 1
    ip leaf202 1 3 192.168.4.2/32 192.168.4.1/32
    ip leaf202 3 1 192.168.4.1/32 192.168.4.2/32
elif [ $SITE = "co3" ]; then
    vlan leaf301 3 4 200
    vlan leaf301 4 3 200
    pass leaf301 4 1
    pass leaf301 1 4
    pass spine32 1 2
    pass spine32 2 1
    ip leaf302 2 3 192.168.4.3/32 192.168.4.1/32
    ip leaf302 3 2 192.168.4.1/32 192.168.4.3/32
fi
