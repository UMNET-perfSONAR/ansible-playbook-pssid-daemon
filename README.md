# ansible-playbook-pssid-daemon
This repository installs and configures the pSSID daemon on probes.

Make sure the Ansible controller has an up-to-date package cache by running:

`sudo apt-get update`


# Usage
Before running this playbook, the GUI server should already be deployed and the target probes should already be added through it. This should generate the required Ansible input files, such as (`hosts.ini` and `pssid_config.json`), under `/var/lib/pssid/output/` on the host machine.

## Expected final file structure

```bash
/var/lib/pssid/
    ├──ansible-inventory-pssid-probes-example/
      ├──inventory/
          ├──group_vars/
             ├──all/
          ├──host_vars/
          ├──README.md    
      ├──files/
      ├──playbook/
        
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

## Create Directories
To manually provision probes. Use root or sudo to finish the following processes if it requires permission.

#### Clone the sample inventory
```bash
cd /var/lib/pssid
git clone https://github.com/UMNET-perfSONAR/ansible-inventory-pssid-probes-example.git
```

#### Clone the playbook
```bash
cd /usr/lib/pssid/playbooks
git clone https://github.com/UMNET-perfSONAR/ansible-playbook-pssid-daemon.git
cd ansible-playbook-pssid-daemon/
ansible-galaxy install -r requirements.yml --roles-path roles
```

#### Run defaults.sh
The script expects generated files to exist under `/var/lib/pssid/output/`, including:

`/var/lib/pssid/output/hosts.ini`
`/var/lib/pssid/output/pssid_config.json`

Run `defaults.sh` from the playbook directory and pass the inventory example root as the argument:

```bash
cd /usr/lib/pssid/playbooks/ansible-playbook-pssid-daemon
chmod +x defaults.sh
./defaults.sh /var/lib/pssid/ansible-inventory-pssid-probes-example/
```

This creates or updates the Ansible inventory directory and copies necessary files to locations in the inventory. See `defaults.sh` for more.

# Setup and encrypt wpa_supplicant profiles

The `ansible-role-pssid-VT-tools` role includes a template for generating `wpa_supplicant` configuration files under `/usr/lib/pssid/playbooks/ansible-playbook-pssid-daemon/roles/ansible-role-pssid-VT-tools/templates`. 

Create your specific `wpa_supplicant_profiles.yml` file under the inventory's `group_vars/all/` directory:
```bash
/var/lib/pssid/ansible-inventory-pssid-probes-example/inventory/group_vars/all/wpa_supplicant_profiles.yml
```

The `wpa_supplicant_profiles.yml` file should follow the structure below:

```yml
wpa_supplicant_profiles:
  global_settings:
    ctrl_interface: "example-interface"

  networks:
    - ssid: "example-ssid"
      key_mgmt: example-key
      eap: example-eap
      proto: example-rsn
      pairwise: example-pairwise
      group: example-group
      phase2: "example-auth"
      identity: "example-identity"
      password: "example-password"
```

After creating `wpa_supplicant_profiles.yml`, create a local vault password file in the playbook repository:

```bash
cd /usr/lib/pssid/playbooks/ansible-playbook-pssid-daemon
vi .vault_pass.txt
```

Add the shared Ansible Vault password to `.vault_pass.txt`. Do not commit this file to Git.

Then encrypt the inventory copy of `wpa_supplicant_profiles.yml` using the shared vault password:

```
ansible-vault encrypt \
  /var/lib/pssid/ansible-inventory-pssid-probes-example/inventory/group_vars/all/wpa_supplicant_profiles.yml \
  --vault-password-file /usr/lib/pssid/playbooks/ansible-playbook-pssid-daemon/.vault_pass.txt
```

#### Change permissions
Ensure the user running Ansible can access the inventory and playbook parent directories and the vault password file:

```bash
chmod 755 -R * /var/lib/pssid/
chmod 755 -R * /usr/lib/pssid/

cd /var/lib/pssid/playbooks/ansible-playbook-pssid-daemon
chmod 644 .vault_pass.txt
```

#### How to run the Ansible playbook

The playbook should be run from the playbook repository:

```bash
cd /usr/lib/pssid/playbooks/ansible-playbook-pssid-daemon
```

Run the playbook as a user with SSH access to the probes. Use privilege escalation to become root on the probes.

The `--vault-password-file` option is required if any inventory files, such as `wpa_supplicant_profiles.yml`, are encrypted with Ansible Vault.

#### Inline inventory
Run the Ansible script with decryption file. Note: '-i "198.111.226.182,"' specifies an inline inventory with a single host.
```
ansible-playbook \
  -i "198.111.226.182," \
  --become \
  --become-method su \
  --become-user root \
  --ask-become-pass \
  --vault-password-file ./.vault_pass.txt \
  playbook.yml
```

If SSH password authentication is required, add --ask-pass:
```bash
ansible-playbook \
  -i "198.111.226.182," \
  --ask-pass \
  --become \
  --become-method su \
  --become-user root \
  --ask-become-pass \
  --vault-password-file ./.vault_pass.txt \
  playbook.yml
```


#### External inventory

Use the inventory directory created by `defaults.sh`:
```bash
ansible-playbook \
  --inventory /var/lib/pssid/ansible-inventory-pssid-probes-example/inventory \
  --become \
  --become-method su \
  --become-user root \
  --ask-become-pass \
  --vault-password-file ./.vault_pass.txt \
  playbook.yml
```