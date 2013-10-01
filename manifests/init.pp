# == Class: sssd
#
# Puppet module to configure sssd as ldap client for an server using
# **OpenLdap**. (Based on Torians ldap module)
#
# === Parameters
#
# [*uri*]
#
#   Ldap URI as a string. Multiple values can be set separated by spaces
#   ('ldap://ldapmaster ldap://ldapslave')
#   **Required**
#
# [*base*]
#
#   Ldap base dn.
#   **Required**
#
# [*domain*]
#
#   The domain to use in the sssd config file.
#   *Optional* (defaults to 'default')
#
# [*binddn*]
#
#   Default bind dn to use when performing ldap operations.
#   *Optional* (defaults to false)
#
# [*bindpw*]
#
#   Password for default bind dn
#   *Optional* (defaults to false)
#
# [*ssl*]
#
#   Enable TLS/SSL negotiation with the server
#   *Requires*: ssl_cert parameter
#   *Optional* (defaults to false)
#
# [*tls_ciphers*]
#
#   SSL cipher suite.
#   *Optional* (defaults to 'TLSv1')
#
# [*cacertdir*]
#
#   The directory where all the certificates are.
#   *Optional* (defaults to '/etc/openldap/cacerts')
#
# [*schema*]
#
#   The ldap schema that should be used.
#   *Optional* (defaults to 'rfc2307bis')
#
# [*nsswitch*]
#
#   If enabled (nsswitch => true) enables nsswitch to use ldap as a backend for
#   password, group and shadow databases.
#   *Requires*: nsswitch module
#   *Optional* (defaults to false)
#
# [*nss_passwd*]
#
#   Search base for the passwd database. *base* will be appended.
#   *Optional* (defaults to 'ou=Users')
#
# [*nss_group*]
#
#   Search base for the group database. *base* will be appended.
#   *Optional* (defaults to 'ou=Groups')
#
# [*nss_shadow*]
#
#   Search base for the shadow database. *base* will be appended.
#   *Optional* (defaults to 'ou=Users')
#
# [*nss_reconnect_tries*]
#
#   Number of times to douple the sleep time.
#   *Optional* (defaults to 5)
#
# [*pam*]
#
#   If enabled (pam => true) enables pam module, which will be setup to use
#   pam_ldap, to enable authentication.
#   *Requires*: pam module
#   *Optional* (defaults to false)
#
# [*pam_att_login*]
#
#   User's login attribute.
#   *Requires*: 'uid'
#   *Optional* (defaults to 'uid')
#
# [*pam_filter*]
#
#   Filter to use when retrieving user information.
#   *Optional* (defaults to 'objectClass=posixAccount')
#
# [*enable_motd*]
#
#   Use motd to report the usage of this module.
#   *Requires*: motd module
#   *Optional* (defaults to false)
#
# [*ensure*]
#
#   Enable the sssd module.
#   *Optional* (defaults to present)
#
# === Variables
#
# === Examples
#
# include sssd
#
# === Authors
#
# Marcellus Siegburg <msiegbur@imn.htwk-leipzig.de>
#
# === Copyright
#
# MIT License
#
class sssd (
  $uri,
  $base,
  $domain      = 'default',
  $binddn      = false,
  $bindpw      = false,
  $ssl         = false,
  $tls_ciphers = 'TLSv1',
  $cacertdir   = '/etc/openldap/cacerts',
  $schema      = 'rfc2307bis',
  $nsswitch    = false,
  $nss_passwd  = 'ou=Users',
  $nss_group   = 'ou=Groups',
  $nss_shadow  = 'ou=Users',

  $nss_reconnect_tries = 5,

  $pam           = false,
  $pam_att_login = 'uid',
  $pam_filter    = 'objectClass=posixAccount',
  $ensure        = latest
  ) {
    case $ensure {
      present, latest: {
        $ensure_file = file
        $ensure_service = running
        $enable_service = true
      }
      default: {
        $ensure_file = absent
        $ensure_service = stopped
        $enable_service = false
      }
    }
    
    package { 'sssd':
      ensure => $ensure,
    }

    file { '/etc/sssd/sssd.conf':
      ensure  => $ensure_file,
      mode    => '0600',
      owner   => root,
      group   => root,
      content => template('sssd/sssd.conf.erb'),
      require => Package['sssd'],
      notify  => Service['sssd'],
    }

    service { 'sssd':
      ensure => $ensure_service,
      enable => $enable_service,
    }
}
