#!/bin/bash

ROOT_FOLDER=$(dirname $(readlink -m $0))

source $ROOT_FOLDER/conf.d/pulse.conf

# let's check users' id, it should be 0 which is sudo
uid=$(echo $UID)
if [[ ! $uid -eq 0 ]]; then
  echo "This script should be run with sudo privileges."
  exit 1
fi


# generate unit file
cat > /var/$UNIT_FILE_NAME.service << EOF
[Unit]
Description=Bash based simple monitoring system

[Service]
Type=simple
ExecStart=/bin/bash $ROOT_FOLDER/pulse

[Install]
WantedBy=multi-user.target

EOF


# let's move it to /etc/systemd/system
mv /var/$UNIT_FILE_NAME.service /etc/systemd/system

systemctl daemon-reload

systemctl enable --now $UNIT_FILE_NAME.service