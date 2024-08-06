#!/bin/bash


# set the permissions of the parent directory of inventory to 755
# example:
# sudo chmod 755 "/var/lib/pssid"

# chmod +x defaults.sh
# run this script with argument to specify the destination directory
# provide the path of inventory /var/lib/pssid/<inventory name>/
# example:
# sudo ./defaults.sh /var/lib/pssid/ansible-inventory-pssid-probes-example/


if [ "$1" == "" ]; then
  directory="inventory"
else
  directory=$1
fi

# make directory if it doesn't exist
mkdir -p $directory/group_vars
mkdir -p $directory/host_vars
mkdir -p $directory/files

# copy the source file to the destination directory and rename it
cp "/var/lib/pssid/output/hosts.ini" "$directory/group_vars/hosts"

# copy pssid.conf to files directory under the inventory directory
cp "/var/lib/pssid/output/pssid_config.json" "$directory/files/pssid_config.json"

# copy the default group variable files to the group_vars directory
if ! [ -f $directory/group_vars/ansible-role-pssid-daemon.yml ]; then
    cp roles/ansible-role-pssid-daemon/defaults/main.yml \
       ${directory}/group_vars/ansible-role-pssid-daemon.yml
fi

if ! [ -f $directory/group_vars/ansible-role-pssid-VT-tools.yml ]; then
    cp roles/ansible-role-pssid-VT-tools/defaults/main.yml \
       ${directory}/group_vars/ansible-role-pssid-VT-tools.yml
fi

if ! [ -f $directory/group_vars/wpa_supplicant_profiles.yml ]; then
    cp roles/ansible-role-pssid-VT-tools/defaults/wpa_supplicant_profiles.yml \
       ${directory}/group_vars/wpa_supplicant_profiles.yml
fi
