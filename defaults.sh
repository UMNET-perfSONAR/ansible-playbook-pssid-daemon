#!/bin/bash


# set the permissions of the parent directory of inventory to 755 to make it accessible
# example:
# sudo chmod 755 "/var/lib/pssid"
# Then run this to make defaults.sh executable:
# chmod +x defaults.sh
# run this script with argument to specify the destination directory
# provide the path of inventory /var/lib/pssid/<inventory-name>/
# the script will create/use:
#   <inventory-name>/inventory/
#   <inventory-name>/files/
# example:
# sudo ./defaults.sh /var/lib/pssid/ansible-inventory-pssid-probes-example/


if [ "$1" == "" ]; then
  echo "Usage: sudo ./defaults.sh /path/to/ansible-inventory-pssid-repository"
  exit 1
fi

directory="$1"

# make directory if it doesn't exist
mkdir -p "$directory/inventory"
mkdir -p "$directory/inventory/group_vars/all"
mkdir -p "$directory/inventory/host_vars"
mkdir -p "$directory/files"  # is this supposed to be here?? daemon role expects it

# copy the source file to the destination directory and rename it
cp "/var/lib/pssid/output/hosts.ini" "$directory/inventory/group_vars/hosts"

# copy pssid.conf to files directory under the inventory directory
cp "/var/lib/pssid/output/pssid_config.json" "$directory/files/pssid_config.json"

# copy the default group variable files to the group_vars directory
if ! [ -f $directory/group_vars/all/ansible-role-pssid-daemon.yml ]; then
    cp roles/ansible-role-pssid-daemon/defaults/main.yml \
       ${directory}/inventory/group_vars/all/ansible-role-pssid-daemon.yml
fi

if ! [ -f $directory/group_vars/all/ansible-role-pssid-VT-tools.yml ]; then
    cp roles/ansible-role-pssid-VT-tools/defaults/main.yml \
       ${directory}/inventory/group_vars/all/ansible-role-pssid-VT-tools.yml
fi

if ! [ -f $directory/group_vars/all/wpa_supplicant_profiles.yml ]; then
    cp roles/ansible-role-pssid-VT-tools/defaults/wpa_supplicant_profiles.yml \
       ${directory}/inventory/group_vars/all/wpa_supplicant_profiles.yml
fi

if ! [ -f $directory/group_vars/all/install_filebeat.yml ]; then
  cp roles/ansible-role-filebeat/defaults/main.yml \
    $directory/inventory/group_vars/all/install_filebeat.yml
fi
