.. http://www.lassosoft.com/Lasso-9-Server-Linux-Installation
.. highlight:: none
.. _centos-installation:

***********************
CentOS 5/6 Installation
***********************

These instructions are for installing Lasso Server on 32-bit/64-bit CentOS 5 or
64-bit CentOS 6.

.. note::
   This version of Lasso requires that SELinux be disabled or set to permissive
   mode.

Installation with yum
=====================

To install Lasso Server via :command:`yum`, the LassoSoft yum repository must
be configured on the server.

:CentOS 5 32-bit/64-bit:
   Import the LassoSoft public key::

      $> rpm --import http://centosyum.lassosoft.com/RPM-GPG-KEY-lassosoft

   Add the LassoSoft repository to :file:`/etc/yum.repos.d`::

      $> rpm -ivh http://centosyum.lassosoft.com/Lasso-CentOS-repo-1.0-1.el5.noarch.rpm

   To install Lasso Server on a **32-bit CentOS 5 system**, as root run::

      $> yum install Lasso-Instance-Manager-9.2.7-7.el5

   To install Lasso Server on a **64-bit CentOS 5 system**, as root run::

      $> yum install Lasso-Instance-Manager-9.2.7-7.el5.x86_64

:CentOS 6 64-bit:
   Import the LassoSoft public key::

      $> rpm --import http://centos6yum.lassosoft.com/RPM-GPG-KEY-lassosoft

   Add the LassoSoft repository to :file:`/etc/yum.repos.d`::

      $> rpm -ivh http://centos6yum.lassosoft.com/Lasso-CentOS-repo-1.0-1.el6.noarch.rpm

   To install Lasso Server on a **64-bit CentOS 6 system**, as root run::

      $> yum install Lasso-Instance-Manager-9.2.7-7.el6

When done, open :ref:`!http://your-server-domain.name/lasso9/instancemanager` to
load the initialization form and complete your Lasso installation. From here on,
you can read up on using the :ref:`instance-manager` and
:ref:`instance-administration` interfaces.


RPM Installation
================

To install Lasso Server directly from an RPM, download the latest release for
`CentOS 5`_ or `CentOS 6`_, then as root run::

   $> yum --nogpgcheck localinstall Lasso-Instance-Manager-9.2*.rpm

.. _CentOS 5: http://centosyum.lassosoft.com/Lasso_Server_9.2/
.. _CentOS 6: http://centos6yum.lassosoft.com/Lasso_Server_9.2/
