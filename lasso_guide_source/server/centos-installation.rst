.. _centos-installation:

***********************
CentOS 5/6 Installation
***********************

RPM Installation
================

To install Lasso 9 Server from an rpm, ensure ImageMagick is installed, then
`download the appropriate file from LassoSoft
<http://www.lassosoft.com/Lasso-9-Server-Download>`_ and run::

   yum install java-1.6.0-openjdk mysql
   rpm -ivh name-of-file.rpm

When done, open http://server-domain.name/lasso9/instancemanager to complete the
installation.

From here, you can read up on :ref:`using the Instance Manager
<instance-manager>` and :ref:`Instance Administration<instance-administration>`.


CentOS 5 32-bit/64-bit Installation with Yum
============================================

To install Lasso 9 Server via yum, the LassoSoft yum repository must be
configured on the server. If the file does not exist, create
"/etc/yum.repos.d/CentOS5-Lasso9.repo" and enter the following::

   [lassosoft]
   name=LassoServer
   failovermethod=priority
   baseurl=http://centosyum.lassosoft.com/
   enabled=1
   gpgcheck=1
   gpgkey=http://centosyum.lassosoft.com/RPM-GPG-KEY-lassosoft
   http_caching=packages

To install Lasso 9 on a **64-bit CentOS 5 system**, as root run::

   yum install Lasso-Instance-Manager.x86_64

To install Lasso 9 on a **32-bit CentOS 5 system**, as root run::

   yum install Lasso-Instance-Manager

When done, open http://server-domain.name/lasso9/instancemanager to complete the
installation.

From here, you can read up on :ref:`using the Instance Manager
<instance-manager>` and :ref:`Instance Administration<instance-administration>`.


CentOS 6 Installation with Yum
==============================

To install Lasso 9 Server via yum, the LassoSoft yum repository must be
configured on the server. If the file does not exist, create
"/etc/yum.repos.d/CentOS6-Lasso9.repo" and enter the following::

   [lassosoft]
   name=LassoServer
   failovermethod=priority
   baseurl=http://centos6yum.lassosoft.com/
   enabled=1
   gpgcheck=1
   gpgkey=http://centos6yum.lassosoft.com/RPM-GPG-KEY-lassosoft
   http_caching=packages

To install Lasso 9 on a **64-bit CentOS 6 system**, as root run::

   yum install Lasso-Instance-Manager

When done, open http://server-domain.name/lasso9/instancemanager to complete the
installation.

From here, you can read up on :ref:`using the Instance Manager
<instance-manager>` and :ref:`Instance Administration<instance-administration>`.