.. http://www.lassosoft.com/Lasso-9-Server-Linux-Installation
.. highlight:: none
.. _centos-installation:

***********************
CentOS 5/6 Installation
***********************

These instructions are for installing Lasso 9 Server on 32-bit/64-bit CentOS 5
or 64-bit CentOS 6.


RPM Installation
================

To install Lasso 9 Server from an RPM, download the appropriate `CentOS RPM`_
for your system and run::

   $> yum install httpd java-1.6.0-openjdk ImageMagick mysql
   $> rpm -ivh name-of-file.rpm

When done, open :ref:`!http://your-server-domain.name/lasso9/instancemanager`
to load the initialization form and complete your Lasso installation.

From here on, you can read up on using the :ref:`instance-manager` and
:ref:`instance-administration`.


CentOS 5 32-bit/64-bit Installation with yum
============================================

To install Lasso 9 Server with :command:`yum`, the LassoSoft yum repository must
be configured on the server. If the file does not exist, create
:file:`/etc/yum.repos.d/CentOS5-Lasso9.repo` and enter the following::

   [lassosoft]
   name=LassoServer
   failovermethod=priority
   baseurl=http://centosyum.lassosoft.com/
   enabled=1
   gpgcheck=1
   gpgkey=http://centosyum.lassosoft.com/RPM-GPG-KEY-lassosoft
   http_caching=packages

To install Lasso 9 on a **32-bit CentOS 5 system**, as root run::

   $> yum install Lasso-Instance-Manager

To install Lasso 9 on a **64-bit CentOS 5 system**, as root run::

   $> yum install Lasso-Instance-Manager.x86_64

When done, open :ref:`!http://your-server-domain.name/lasso9/instancemanager`
to load the initialization form and complete your Lasso installation.

From here on, you can read up on using the :ref:`instance-manager` and
:ref:`instance-administration`.


CentOS 6 64-bit Installation with yum
=====================================

To install Lasso 9 Server with :command:`yum`, the LassoSoft yum repository must
be configured on the server. If the file does not exist, create
:file:`/etc/yum.repos.d/CentOS6-Lasso9.repo` and enter the following::

   [lassosoft]
   name=LassoServer
   failovermethod=priority
   baseurl=http://centos6yum.lassosoft.com/
   enabled=1
   gpgcheck=1
   gpgkey=http://centos6yum.lassosoft.com/RPM-GPG-KEY-lassosoft
   http_caching=packages

To install Lasso 9 on a **64-bit CentOS 6 system**, as root run::

   $> yum install Lasso-Instance-Manager

When done, open :ref:`!http://your-server-domain.name/lasso9/instancemanager`
to load the initialization form and complete your Lasso installation.

From here on, you can read up on using the :ref:`instance-manager` and
:ref:`instance-administration`.

.. _CentOS RPM: http://www.lassosoft.com/Lasso-9-Server-Download#CentOS
