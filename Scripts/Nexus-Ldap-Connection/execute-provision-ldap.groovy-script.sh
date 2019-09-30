!/bin/bash
set -eux
## Insertt the nexus domain name here (on which you need to configure LDAP)
nexus_domain= ## registry-dr.guidespark.net  

source nexus-groovy.sh

# run the provision script.
response=$(nexus-groovy provision-ldap)
echo "$response" | jq '.result | fromjson'
