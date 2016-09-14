.. http://www.lassosoft.com/Lasso-9-Server-Linux-Installation
.. highlight:: none
.. _centos-installation:

*************************
CentOS 5/6/7 Installation
*************************

These instructions are for installing Lasso Server on 64-bit CentOS 5, 6, or 7.

.. note::
   Installing Lasso on CentOS 5 requires that SELinux be disabled or set to
   permissive mode.

Installation with yum
=====================

To install Lasso Server via :command:`yum`, the LassoSoft yum repository must
be configured on the server.

:CentOS 5 64-bit:
   Import the LassoSoft public key::

      $> rpm --import http://centosyum.lassosoft.com/RPM-GPG-KEY-lassosoft

   Add the LassoSoft repository to :file:`/etc/yum.repos.d`::

      $> rpm -ivh http://centosyum.lassosoft.com/Lasso-CentOS-repo-1.0-1.el5.noarch.rpm

:CentOS 6 64-bit:
   Import the LassoSoft public key::

      $> rpm --import http://centos6yum.lassosoft.com/RPM-GPG-KEY-lassosoft

   Add the LassoSoft repository to :file:`/etc/yum.repos.d`::

      $> rpm -ivh http://centos6yum.lassosoft.com/Lasso-CentOS-repo-1.0-1.el6.noarch.rpm

:CentOS 7 64-bit:
   Import the LassoSoft public key::

      $> rpm --import http://centos7yum.lassosoft.com/RPM-GPG-KEY-lassosoft

   Add the LassoSoft repository to :file:`/etc/yum.repos.d`::

      $> rpm -ivh http://centos7yum.lassosoft.com/Lasso-CentOS-repo-1.0-1.el7.noarch.rpm

Then run the following as root to install Lasso Server::

   $> yum install Lasso-Instance-Manager

When done, open :ref:`!http://your-server-domain.name:8090/lasso9/lux` to load
the initialization form and complete your Lasso installation. From here on, you
can read up on using the :ref:`instance-manager` and
:ref:`instance-administration` interfaces.


RPM Installation
================

To install Lasso Server directly from an RPM, download the latest release for
`CentOS 5`_, `CentOS 6`_, or `CentOS 7`_, then as root run::

   $> yum --nogpgcheck localinstall Lasso-Instance-Manager-9.3*.rpm

.. _CentOS 5: http://centosyum.lassosoft.com/Lasso_Server_9.3/
.. _CentOS 6: http://centos6yum.lassosoft.com/Lasso_Server_9.3/
.. _CentOS 7: http://centos7yum.lassosoft.com/Lasso_Server_9.3/
