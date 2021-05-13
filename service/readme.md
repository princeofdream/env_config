# Linux custom service usage introduction

## Common Service

### dnsmasq (for dhcp)

#### 1, enable config path to load extra config

```config
# file: /etc/dnsmasq.conf
conf-dir=/etc/dnsmasq.d/,*.conf
mkdir -p /etc/dnsmasq.d/
```

#### 2, before enable dnsmasq, you should setup your interface

```shell
sudo brctl addbr br-wan
sudo ifconfig br-wan 192.168.7.1
# sudo brctl addif br-wan ethx
```

#### 3, setup config file for br-wan and put it to /etc/dnsmasq.d/

```config
# file: /etc/dnsmasq.d/brwan.conf
strict-order
pid-file=/var/run/dhcp_brwan.pid
except-interface=lo
interface=br-wan
bind-interfaces
dhcp-range=192.168.7.10,192.168.7.254,255.255.255.0
dhcp-no-override
dhcp-authoritative
dhcp-lease-max=253
domain=james.brwan.com
```

#### 4, start dnsmasq service

```shell
sudo systemctl restart dnsmasq
```
#### 5, not using dnsmasq service

if not using dnsmasq service, we can start dhcp by manual with command

```shell
/usr/bin/dnsmasq -k \
  --conf-file=/home/james/Environment/my_c_program/env_config/service/dhcpd.conf
```
or
```shell
/usr/bin/dnsmasq -k \
  --conf-file=/home/james/Environment/my_c_program/env_config/service/dhcpd.conf \
  --enable-dbus --user=dnsmasq --pid-file
```

WARNING: 

if it prompt interface not found or something like that,
make sure interface is up and have ipaddr.

## Special introduction

