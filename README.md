# ansible-playbook-pssid-daemon
install and configure pSSID daemon on probes

make sure  sudo apt-get update  


## File structure
User needs to create inventory file structure on the GUI server before performing provisioning.
```bash
/var/lib/pssid/
    ├──ansible_inventory/ # user defined folder name
        ├──inventory/
           ├──group_vars/
           ├──host_vars/
           ├──host.ini
           ├──README.md    
           ├──files/       # site specific files, if any
           ├──playbooks/   # site specific playbook
        
/usr/lib/pssid/playbooks
    ├──ansible-playbook-pssid-daemon
       ├──roles/
       ├──playbook.yml
       ├──requirements.yml
       ├──defaults.sh
       ├──ansible.cfg
       ...
    ├──ansible-playbook-bootstrap  
```


# Encrpyt wap_supplicant.conf file
`Encryption`
User will be prompted to set up encryption password.
```bash
ansible-vault encrypt wpa_supplicant_profiles.yml
```

`Decryption file`
Create a local vault_pass.txt with user defined password. This file should be provided when running Ansible provisioning script. 
```bash
vi vault_pass.txt
```


# Usage
#### Run default.sh  # check if run?
Assuming the inventory file structure has been created and bootstrap performed, user then needs to run the defualt.sh to ensure variable or files are initialized properly. For example, host.ini file will be copied to the inventory folder.
`cd` to the playbook folder `ansible-playbook-pssid-daemon` in console, 
```bash
./default.sh
``` 

#### How to run the ansible script. 
`--vault-password-file` is optional depending on whether wpa_supplicant_profiles.yml is encrypted or not. 

#### Inline inventory
Run the Ansible script with decryption file. Note: '-i "198.111.226.182,"' specifies an inline inventory with a single host.
<!-- ```bash
ansible-playbook -i "198.111.226.182," playbook.yml --become   --become-method su   --become-user root   --ask-become-pass --vault-password-file ./vault_pass.txt
``` -->

<!-- not sure work or not -->
```bash
ansible-playbook \
    --become \  
    --become-method su \
    --become-user root \  
    --ask-become-pass \
    --vault-password-file ./vault_pass.txt \
    -i "198.111.226.182," playbook.yml 
```

#### External inventory
<!-- ```bash
ansible-playbook --inventory /var/lib/pssid/ --become   --become-method su   --become-user root   --ask-become-pass --vault-password-file ./vault_pass.txt  playbook.yml
``` -->

```bash
ansible-playbook \
    --inventory /var/lib/pssid/ansible_inventory/inventory/host.ini \
    --become \
    --become-method su \
    --become-user root \  
    --ask-become-pass\
    --vault-password-file ./vault_pass.txt \
    playbook.yml
```
