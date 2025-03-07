# libapache2-mod-authnz-external
## External Authentication Module for Apache HTTP Server - [Apache License 1.0](https://www.apache.org/licenses/LICENSE-1.0)
Upstream: https://github.com/phokz/mod-auth-external

**Mod_authnz_external is a flexible tool for building custom basic authentication systems for the [Apache HTTP Server](http://httpd.apache.org)**. "Basic Authentication" is a type of authentication built into the HTTP protocol, in which the browser automatically pops up a login box when the user requests a protected resource, and the login ids and passwords entered are checked by Apache. Mod_auth*_external allows the password checking normally done inside Apache to be done by an separate external program running outside of Apache.

## Versions

This module was developed from "mod_auth_external".  It has been restructured
to fit into the authn/authz structure introduce in Apache 2.1.  It can be used
in any application where mod_auth_external was previously used.  No changes
will be needed to the external authentication programs, but the exact Apache
configuration commands needed will be different.  It is possible to use the
old "mod_auth_external-2.2" with Apache-2.2, but mod_authnz_external is
preferable.  If you are upgrading from "mod_auth_external" to
"mod_authnz_external" then read the file "UPGRADE" for advice.

Mod_authnz_external has been tested on a wide variety of Unix platforms.  In
theory versions after 3.2.0 should work on any non-Unix platforms supported
by Apache, but it has been tested only under Unix.

Mod_authnz_external is also compatible with authenticators using the
checkpassword interface.  See http://cr.yp.to/checkpwd.html for more
information.

### Support Matrix

Mod_authnz_external version 3.3.x is designed for use with Apache version
2.4.x.  It will not work with Apache 2.2 or 2.0.  For older versions of
Apache you will need older branches of mod_authnz_external:

<table><thead><th>Apache Version</th><th>mod_authnz_external Version</th><th>Supported?</th></thead><tbody>
<tr><td rowspan='2'> Apache 2.4 </td><td> <b>mod_authnz_external 3.3.x</b> </td><td> Yes </td></tr>
<tr><td></td><td> - </td></tr>
<tr><td> Apache 2.2 </td><td> mod_authnz_external 3.1.x or 3.2.x </td><td> - </td></tr>
<tr><td> Apache 2.0 </td><td> mod_auth_external 2.2.x </td><td> - </td></tr>
<tr><td> Apache 1.3 </td><td> mod_auth_external 2.1.x </td><td> - </td></tr>
</tbody></table>

Older versions are provided on an as-is basis in this repo's [branch list](https://github.com/phokz/mod-auth-external/branches/all).

## Security Considerations

Mod_Auth_External can be used to quickly construct secure, reliable
authentication systems.  It can also be mis-used to quickly open gaping
holes in your security.  Read the documentation, and use with extreme
caution.

Older versions of mod_auth_external would by default pass logins and passwords into the authentication module using environment variables. This is insecure on some versions of Unix where the contents of environment variables are visible on a 'ps -e' command. In more recent versions, the default is to use a pipe to pass sensitive data. This is secure on all versions of Unix, and is recommended in all installations.

People using mod_auth*_external with pwauth to authenticate from system password databases should be aware of the [innate security risks](http://code.google.com/p/pwauth/wiki/Risks) involved in doing this.

## Introduction

Mod_Authnz_External is an Apache module used for authentication.  The Apache
HTTP Daemon can be configured to require users to supply logins and passwords
before accessing pages in some directories.  Authentication is the process
of checking if the password given is correct for a user.  Apache has
standard modules for authenticating out of several different kinds of
databases.  Mod_Authnz_External is a flexible tool for creating authentication
systems based on other databases.

Mod_Authnz_External can be used in either of two somewhat divergent ways:

 External Authentication:

    When a user supplies a login and password, mod_authnz_external runs a
    program you write, passing it the login and password.  Your program
    does whatever checking and logging it needs to, and then returns a
    Accept/Reject flag to Apache.

    This is slower than doing the authentication internally because it
    has the overhead of launching an external program for each authentication.
    However, there are at least two situations where it is very useful:

      - Rapid prototyping.  The external authentication program can be
        a shell script or perl program.  It can be written without knowing
        much about building Apache modules.  Bugs in it will not endanger
        the overall integrity of the Apache server.  Later, as performance
	becomes more of an issue, you can write a custom Apache module to
	do the job more efficiently (perhaps using the HARDCODE option below).

      - Access restrictions.  There are situations where you do not want to
        make your user database readable to the user-id that Apache runs
        under.  In these cases the external authentication program can be
        an suid program that has access to databases Apache cannot access.
        For example, if you want to authentication out of a Unix shadow
        password database, and you aren't foolish enough to run Apache
        as root, a carefully written suid-root external authentication
        program can do the job for you.

    Pwauth, an external authentication program for securely authenticating
    out of a Unix shadow password database available from
    http://www.unixpapa.com/pwauth/ .

 Hardcoded Authentication:

    Some hooks have been inserted into mod_authnz_external to make it easy
    to replace the call to the external authentication program with a
    call to a hardcoded internal authentication routine that you write.

    This is sort of a half-way measure to just writing your own Apache
    module from scratch, allowing you to use some of the logic from
    mod_authnz_external.

    Example functions for authenticating out of a RADIUS server or Sybase
    database are included in this distribution.

