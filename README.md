# ansible-playbook-pssid-daemon
install and configure pSSID daemon on probes


# File Structure


# Encrpyt wap_supplicant.conf file
`Encryption`
User will be prompted to set up encryption passward.
```bash
ansible-vault encrypt wpa_supplicant_profiles.yml
```

`Decryption file`
Create a local vault_pass.txt with user defined password.
```bash
vi vault_pass.txt
```


# Usage
In the playbook folder
`cd ansible-playbook-pssid-daemon`

Run the Ansible script with decryption file. Note: '-i "198.111.226.182,"' specifies an inline inventory with a single host.
```bash
ansible-playbook -i "198.111.226.182," playbook.yml --become   --become-method su   --become-user root   --ask-become-pass --vault-password-file ./vault_pass.txt
```

Using inventory folder

