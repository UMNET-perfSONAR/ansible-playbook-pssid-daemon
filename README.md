# ansible-playbook-pssid-daemon
install and configure pSSID daemon on probes

make sure  sudo apt-get update  


## File structure
User needs to create inventory file structure on the GUI server before performing provisioning.
```bash
/var/lib/pssid/
    ├──ansible-inventory-pssid-probes-example
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
To manually provision probes. Use root to clone repos if it requres permission on /var/lib/pssid path. 

#### Clone the inventory example
Clone ansible-inventory-pssid-probes-example repository 
```bash
cd /var/lib/pssid
git clone https://github.com/UMNET-perfSONAR/ansible-inventory-pssid-probes-example.git
```

#### Clone the playbook
```bash
cd /var/lib/pssid
git clone https://github.com/UMNET-perfSONAR/ansible-playbook-pssid-daemon.git
ansible-galaxy install -r requirements.yml --roles-path roles
```

#### Run default.sh
Assuming provisioning and bootstrap have been performed, user needs to run the defualt.sh to ensure variable or files are copy to inventory properly. Modify roles' variables in inventory if necessary since playbook's roles should be immutable.
```bash
cd /var/lib/pssid/playbooks/ansible-playbook-pssid-daemon
chmod +x defaults.sh
```

```bash
sudo ./defaults.sh /var/lib/pssid ansible-inventory-pssid-probes-example/
``` 

#### Change permission
Locate the parent folder for playbook and inventory
``` bash
chmod 755 -R * /var/lib/pssid
cd /var/lib/pssid/playbooks/ansible-playbook-pssid-daemon
chmod 644 vault_pass.txt
```

#### How to run the ansible script. 
`--vault-password-file` is optional depending on whether wpa_supplicant_profiles.yml is encrypted or not. 

Run the playbook as a normal user instead of root.
```bash
cd /var/lib/pssid/playbooks/ansible-playbook-pssid-daemon
```

#### Inline inventory
Run the Ansible script with decryption file. Note: '-i "198.111.226.182,"' specifies an inline inventory with a single host.

```bash
ansible-playbook \
  -i "198.111.226.182," \
  --become \
  --become-method su \
  --become-user root \
  --ask-become-pass \
  --vault-password-file ./vault_pass.txt \
  playbook.yml
```

#### External inventory
``` bash
ansible-playbook \
  --inventory ../../ansible-inventory-pssid-probes-example/inventory/ \
  --become \
  --become-method su \
  --become-user root \
  --ask-become-pass \
  --vault-password-file ./vault_pass.txt \
  playbook.yml
```