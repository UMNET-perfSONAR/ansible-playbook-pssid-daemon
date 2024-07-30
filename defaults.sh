# run by provision script?
#!/bin/bash

if [ "$1" == "" ]; then
  directory="/var/lib/pssid/pssid_inventory/inventory"
else
  directory=$1
fi

host_group = "iLab"
pssid_daemon_role_name = "ansible-role-pssid-daemon"
pssid_VT_tools_role_name = "ansible-role-pssid-VT-tools"

mkdir -p ${directory}/group_vars

# function to initialize group variable files
initialize_group_vars() {
    local role_name=$1
    if ! [ -f ${directory}/group_vars/${host_group}/${role_name}.yml ]; then
        cp roles/${role_name}/defaults/main.yml \
           ${directory}/group_vars/${host_group}/${role_name}.yml
    fi
}

# initialize group variable files for each role
initialize_group_vars ${pssid_daemon_role_name}
initialize_group_vars ${pssid_VT_tools_role_name}