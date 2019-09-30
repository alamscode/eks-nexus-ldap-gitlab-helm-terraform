// run this file inside the Vagrant environment with bash /vagrant/provision/execute-provision-ldap.groovy-script.sh
// see https://help.sonatype.com/display/NXRM3/REST+and+Integration+API
// see https://github.com/sonatype/nexus-book-examples/tree/nexus-3.x/scripting/nexus-script-example

import groovy.json.JsonOutput
import org.sonatype.nexus.ldap.persist.LdapConfigurationManager
import org.sonatype.nexus.ldap.persist.entity.Connection
import org.sonatype.nexus.ldap.persist.entity.LdapConfiguration
import org.sonatype.nexus.ldap.persist.entity.Mapping
import org.sonatype.nexus.security.user.UserSearchCriteria

ldapManager = container.lookup(LdapConfigurationManager.class.name)

// you'll have to change the following values with your own login credentials where mentioned

if (!ldapManager.listLdapServerConfigurations().any { it.name == "dc.example.com" }) {
    ldapManager.addLdapServerConfiguration(
        new LdapConfiguration(
            name: 'Test Connection',
            connection: new Connection(
                host: new Connection.Host(Connection.Protocol.ldaps, 'trambo.ldap.okta.com', 636), // here
                connectionTimeout: 30,
                connectionRetryDelay: 300,
                maxIncidentsCount: 3,
                searchBase: 'ou=users,dc=trambo,dc=okta,dc=com',
                authScheme: 'simple',
                systemUsername: 'uid=ldap@yopmail.com, dc=trambo, dc=okta, dc=com', //here
                systemPassword: 'WhiteGate22', // and here
            ),
            mapping: new Mapping(
                userBaseDn: '',
                userObjectClass: 'inetOrgPerson',
                ldapFilter: '',
                userIdAttribute: 'uid',
                userRealNameAttribute: 'cn',
                emailAddressAttribute: 'mail',
                userPasswordAttribute: '',
                ldapGroupsAsRoles: true,
                userMemberOfAttribute: 'memberOf',
            )
        )
    )
}
