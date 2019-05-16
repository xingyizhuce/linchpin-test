#!/usr/bin/env bash

PinFile=./entitlement-tests/CCI/Linchpin/beaker/simple/PinFile

if [ $Product_Type = "RHEL8" ]; then
  sed -i -e "s/DISTRO/$Distro/g" -e "s/ARCH/$Arch/g" -e "s/VARIANT/BaseOS/g" $PinFile
else
  sed -i -e "s/DISTRO/$Distro/g" -e "s/ARCH/$Arch/g" -e "s/VARIANT/$Variant/g" $PinFile
fi


pushd entitlement-tests/
linchpin -w ./CCI/Linchpin/beaker/simple -vvvv up
PROVISION_STATUS=$?

if [ "$PROVISION_STATUS" == 0 ]; then
  cat ./CCI/Linchpin/beaker/simple/resources/linchpin.latest
else
  echo "ERROR: Failed to provision beaker system!"
fi
