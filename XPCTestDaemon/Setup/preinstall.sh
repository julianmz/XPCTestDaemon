#!/bin/bash

XPCTD_PREINST_NAME_LAUNCHD_SERVICE="com.jmz.xpctestdaemon"
XPCTD_PREINST_NAME_LAUNCHD_SERVICE_PLIST="${XPCTD_PREINST_NAME_LAUNCHD_SERVICE}.plist"
XPCTD_PREINST_NAME_LAUNCHD_SERVICE_PLIST_FILE="/Library/LaunchDaemons/${XPCTD_PREINST_NAME_LAUNCHD_SERVICE_PLIST}"

if [[ "$(id -u)" -ne "0" ]]; then

    echo "This script needs to be run with root privileges"
    exit 1
fi

launchctl bootout system ${XPCTD_PREINST_NAME_LAUNCHD_SERVICE_PLIST_FILE}

rm ${XPCTD_PREINST_NAME_LAUNCHD_SERVICE_PLIST_FILE}

exit 0


