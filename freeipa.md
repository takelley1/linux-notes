## FreeIPA

### Setup

- Set a static hostname
  ```
  hostnamectl set-hostname ipa.example.com
  ```
- Edit /etc/hosts
  ```
  10.128.1.1 ipa.example.com ipa
  127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
  ::1         localhost6 localhost6.localdomain6
  ```
- Create a DNS A record for the static hostname you set in /etc/hostname. Set the A record to resolve to the IPA server's private IP.
  ```
  resolvectl query --cache=false ipa.example.com
  dig ipa.example.com
  ```
- Create a DNS PTR record that resolves the IPA server's private IP to its hostname.
  ```
  # Get the IP of the A record and check if the IP resolves to the hostname.
  resolvectl query --cache=false "$(resolvectl query --cache=false ipa.example.com | awk '{print $2}' | head -1)"
  dig -x <PUT IP HERE>
  ```
