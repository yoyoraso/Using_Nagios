#!/bin/bash
yum install -y httpd mariadb-server php php-mysql unzip
mysql_secure_installation
systemctl enable httpd.service
systemctl enable mariadb.service
yum install -y gcc glibc glibc-common wget gd gd-devel perl postfix
cd /tmp
wget -O nagioscore.tar.gz https://github.com/NagiosEnterprises/nagioscore/archive/nagios-4.4.2.tar.gz
tar xzf nagioscore.tar.gz
cd /tmp/nagioscore-nagios-4.4.2
./configure
make all
make install-groups-users
usermod -a -G nagios apache
make install
make install-daemoninit
make install-config
make install-commandmode
make install-webconf
systemctl restart httpd
htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin
yum install -y gcc glibc glibc-common make gettext automake autoconf wget openssl-devel net-snmp net-snmp-utils epel-release perl-Net-SNMP
cd /tmp
wget --no-check-certificate -O nagios-plugins.tar.gz https://github.com/nagios-plugins/nagios-plugins/archive/release-2.2.1.tar.gz
tar zxf nagios-plugins.tar.gz
cd /tmp/nagios-plugins-release-2.2.1/
./tools/setup
./configure
make
make install
systemctl start nagios
firewall-cmd --permanent --add-port=80/tcp
firewall-cmd --reload
