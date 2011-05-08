MockCA
======

This is a simple web application to help you manage X509 certificates for your tests.

Warning: MockCA was not designed with security in mind. DO NOT USE IT TO RUN A REAL CERTIFICATE AUTHORITY. You have been warned.

Features
--------

* Creating a root certificate authority
* Creating a certificate signed by a root

TODO
----

* Creating a sub certificate authority
* Revoking a certificate and publishing a certificate revocation list
* Converting key and certificate to multiple formats, like java keystore
* Creating code signing certificates
