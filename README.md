puppet sssd module
==================

This module configures sssd according to params.

Usage
-----

```puppet
include sssd
```

```puppet
class { 'sssd':
  uri       => 'ldap[s]://ldapmaster[:port] ldap[s]://ldapslave[:port]',
  base      => 'dc=anybase',
  binddn    => 'cn=foo,ou=bar,dc=anybase',
  bindpw    => 'anypassword',
  ssl       => true,
  cacertdir => '/etc/openldap/cacerts',
}
```
