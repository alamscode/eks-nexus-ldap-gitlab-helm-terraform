#!/bin/bash

apt-get update
apt-get install -y debconf-utils

# Folder used as holder for several configuration files
mkdir /etc/guidespark

# Installation of nslcd libnss-ldapd libpam-ldapd
cat > /etc/guidespark/deb.conf <<EOF
nslcd nslcd/ldap-bindpw password ${bind_pass}
nslcd nslcd/ldap-uris string ${ldap_uri}
nslcd nslcd/ldap-binddn string ${bind_dn}
nslcd nslcd/ldap-base string ${bind_base}
nslcd nslcd/ldap-reqcert string never
libnss-ldapd:amd64 libnss-ldapd/nsswitch multiselect group, passwd, shadow
libnss-ldapd:amd64 libnss-ldapd/clean_nsswitch boolean false
EOF
debconf-set-selections /etc/guidespark/deb.conf
apt-get install -y nslcd libnss-ldapd libpam-ldapd
echo "filter passwd (objectClass=inetOrgPerson)" >> /etc/nslcd.conf
echo "filter group (objectClass=groupofUniqueNames)" >> /etc/nslcd.conf

# -- SSH Configuration, to support storing sshPublicKey in Okta profile
cat > /opt/AuthorizedKeysCommand <<EOF
#!/bin/bash
ldapsearch -D "${bind_dn}" -w ${bind_pass}  -H ${ldap_uri}  -b "${bind_base}" "uid=\$1" sshPublicKey | sed -n '/^ /{H;d};/sshPublicKey:/x;\$g;s/\n *//g;s/sshPublicKey: //gp'
EOF
chmod 555 /opt/AuthorizedKeysCommand
echo "AuthorizedKeysCommand /opt/AuthorizedKeysCommand" >> /etc/ssh/sshd_config
echo "AuthorizedKeysCommandUser root" >> /etc/ssh/sshd_config


# Creating automatic home directory
pam-auth-update --enable mkhomedir

# Restarting services
/etc/init.d/ssh restart
/etc/init.d/nscd restart
/etc/init.d/nslcd restart
