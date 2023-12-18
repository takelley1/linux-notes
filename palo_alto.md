## Palo Alto

- **See also:**
  - [Ansible setup](https://pan.dev/ansible/docs/panos/tutorials/setup/)

### Palo Alto VM appliance on AWS

- **See also:**
  - [VM-series deployment guide on AWS](https://docs.paloaltonetworks.com/vm-series/9-1/vm-series-deployment/set-up-the-vm-series-firewall-on-aws/deploy-the-vm-series-firewall-on-aws)

AMI: PA-VM-AWS-9.1.16-h3-f1260463-68e1-4bfb-bf2e-075c2664c1d7

- Create with 2 network interfaces, each in a different subnet
- After creating the instance, attach an elastic public IP to one of the instance's network interfaces
- SSH into the instance using the elastic public IP. You must use an SSH key, username/password doesn't work
<br><br>
- SSH into instance to set admin password for web interface
```
configure
set mgt-config users admin password
```
