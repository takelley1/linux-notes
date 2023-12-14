## Palo Alto

### Palo Alto VM appliance on AWS

AMI: PA-VM-AWS-9.1.16-h3-f1260463-68e1-4bfb-bf2e-075c2664c1d7

- Create with 2 network interfaces, each in a different subnet
- After creating the instance, attach an elastic public IP to one of the instance's network interfaces
- SSH into the instance using the elastic public IP. You must use an SSH key, username/password doesn't work
