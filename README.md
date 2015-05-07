MariaDB Cookbook
=====================

The MariaDB Cookbook is a library cookbook that provides resource primitives
(LWRPs) for use in recipes and a few ready to use recipes: installation/deinstallation and start particular version of MariaDB.

Scope
-----
This cookbook is concerned with the "MariaDB Enterprise Server".

Requirements
------------
- Chef 11 or higher
- Ruby 1.9 or higher (preferably from the Chef full-stack installer)
- Network accessible package repositories

Platform Support
----------------
The following platforms have been tested with Test Kitchen:

```
|----------------+-----+------|
|                | 5.5 | 10.0 |
|----------------+-----+------|
| debian-6       |  X  | X    |
|----------------+-----+------|
| debian-7       |  X  | X    |
|----------------+-----+------|
| ubuntu-10.04   |  X  | X    |
|----------------+-----+------|
| ubuntu-12.04   |  X  | X    |
|----------------+-----+------|
| ubuntu-14.04   |  X  | X    |
|----------------+-----+------|
| ubuntu-14.10   |  X  | X    |
|----------------+-----+------|
| centos-5       |  X  | X    |
|----------------+-----+------|
| centos-6       |  X  | X    |
|----------------+-----+------|
| centos-7       |  X  | X    |
|----------------+-----+------|
| suse-13        | recipes only |
|----------------+-----+------|
| sles-11        |  X  | X    |
|----------------+-----+------|
| sles-12        |  X  | X    |
|----------------+-----+------|
| rhel-5         |  X  | X    |
|----------------+-----+------|
| rhel-6         |  X  | X    |
|----------------+-----+------|
| rhel-7         |  X  | X    |
|----------------+-----+------|
| Windows        | recipes only |
|----------------+-----+------|
```

Cookbook Dependencies
------------

Usage
-----

For MariaDB Enterprise default version installation type in command line:

`$ chef-solo -c solo.rb -o recipe[mariadb::install]`

In a vagrant file (For 10.0.17 MDBE version):

```ruby
    config.vm.provision :chef_solo do |chef|
      chef.cookbooks_path = "<bla-bla>/cookbooks"
      chef.provisioning_path = "/tmp/vagrant-chef/chef-solo"
      chef.json = {
        :maria => {
          version: 10.0.17 
        }
      }
      chef.add_recipe "mariadb::install"
    end
```

Or you can use MariaDB cookbook into your own cookbook. Place a dependency on the MariaDB cookbook in your cookbook's metadata.rb

```ruby
depends 'mariadb', '~> 0'
```

Then, in recipe:

```ruby

mysql_service 'foo' do
  port '3306'
  version '5.5'
  initial_root_password 'change me'
  action [:create, :start]
end
```

The service name on the OS is `mysql-foo`. You can manually start and
stop it with `service mysql-foo start` and `service mysql-foo stop`.

The configuration file is at `/etc/mysql-foo/my.cnf`. It contains the
minimum options to get the service running. It looks like this.

```
# Chef generated my.cnf for instance mysql-default

[client]
default-character-set          = utf8
port                           = 3306
socket                         = /var/run/mysql-foo/mysqld.sock

[mysql]
default-character-set          = utf8

[mysqld]
user                           = mysql
pid-file                       = /var/run/mysql-foo/mysqld.pid
socket                         = /var/run/mysql-foo/mysqld.sock
port                           = 3306
datadir                        = /var/lib/mysql-foo
tmpdir                         = /tmp
log-error                      = /var/log/mysql-foo/error.log
!includedir /etc/mysql-foo/conf.d

[mysqld_safe]
socket                         = /var/run/mysql-foo/mysqld.sock
```

You can put extra configuration into the conf.d directory by using the
`mysql_config` resource, like this:

```ruby
mysql_service 'foo' do
  port '3306'
  version '5.5'
  initial_root_password 'change me'
  action [:create, :start]
end

mysql_config 'foo' do
  source 'my_extra_settings.erb'
  notifies :restart, 'mysql_service[foo]'
  action :create
end
```

You are responsible for providing `my_extra_settings.erb` in your own
cookbook's templates folder.

Resources Overview
------------------
### Recipes

## install

Installs particular version (10.0 by default) MariaDB Enterprise server.

Usage:

`$ chef-solo -c solo.rb -o recipe[mariadb::install]`

## uninstall

Removes both MariaDB Enterprise server & client.

Usage:

`$ chef-solo -c solo.rb -o recipe[mariadb::uninstall]`

## purge

Removes both MariaDB Enterprise server & client and REMOVE ALL DATA and configurations, turns off repositories.

## start

Creates (doesn't install MariaDB!) and starts MariaDB Enterprise server daemon with particular params. For example:

```ruby
    config.vm.provision :chef_solo do |chef|
      chef.cookbooks_path = "<bla-bla>/cookbooks"
      chef.provisioning_path = "/tmp/vagrant-chef/chef-solo"
      chef.json = {
        :maria => {
          bind_address: 127.0.0.1
        }
      }
      chef.add_recipe "mariadb::start"
    end
```

### mysql_service

The `mysql_service` resource manages the basic plumbing needed to get a
MySQL server instance running with minimal configuration.

The `:create` action handles package installation, support
directories, socket files, and other operating system level concerns.
The internal configuration file contains just enough to get the
service up and running, then loads extra configuration from a conf.d
directory. Further configurations are managed with the `mysql_config` resource.

- If the `data_dir` is empty, a database will be initialized, and a
root user will be set up with `initial_root_password`. If this
directory already contains database files, no action will be taken.

The `:start` action starts the service on the machine using the
appropriate provider for the platform. The `:start` action should be
omitted when used in recipes designed to build containers.

#### Example
```ruby
mysql_service 'default' do
  version '5.7'
  bind_address '0.0.0.0'
  port '3306'  
  data_dir '/data'
  initial_root_password 'Ch4ng3me'
  action [:create, :start]
end
```

Please note that when using `notifies` or `subscribes`, the resource
to reference is `mysql_service[name]`, not `service[mysql]`.

#### Parameters

- `charset` - specifies the default character set. Defaults to `utf8`.

- `data_dir` - determines where the actual data files are kept
on the machine. This is useful when mounting external storage. When
omitted, it will default to the platform's native location.

- `initial_root_password` - allows the user to specify the initial
  root password for mysql when initializing new databases.
  This can be set explicitly in a recipe, driven from a node
  attribute, or from data_bags. When omitted, it defaults to
  `ilikerandompasswords`. Please be sure to change it.

- `instance` - A string to identify the MySQL service. By convention,
  to allow for multiple instances of the `mysql_service`, directories
  and files on disk are named `mysql-<instance_name>`. Defaults to the
  resource name.

- `bind_address` - determines the listen IP address for the mysqld service. When
  omitted, it will be determined by MySQL. If the address is "regular" IPv4/IPv6
  address (e.g 127.0.0.1 or ::1), the server accepts TCP/IP connections only for
  that particular address. If the address is "0.0.0.0" (IPv4) or "::" (IPv6), the
  server accepts TCP/IP connections on all IPv4 or IPv6 interfaces.

- `port` - determines the listen port for the mysqld service. When
  omitted, it will default to '3306'.

- `run_group` - The name of the system group the `mysql_service`
  should run as. Defaults to 'mysql'.

- `run_user` - The name of the system user the `mysql_service` should
  run as. Defaults to 'mysql'.

- `socket` - determines where to write the socket file for the
  `mysql_service` instance. Useful when configuring clients on the
  same machine to talk over socket and skip the networking stack.
  Defaults to a calculated value based on platform and instance name.

#### Actions

- `:create` - Configures everything but the underlying operating system service.
- `:delete` - Removes everything but the package and data_dir.
- `:start` - Starts the underlying operating system service
- `:stop`-  Stops the underlying operating system service
- `:restart` - Restarts the underlying operating system service
- `:reload` - Reloads the underlying operating system service

#### Providers
Chef selects the appropriate provider based on platform and version,
but you can specify one if your platform support it.

```ruby
mysql_service[instance-1] do
  port '1234'
  data_dir '/mnt/lottadisk'
  provider Chef::Provider::MysqlService::Sysvinit
  action [:create, :start]
end
```

- `Chef::Provider::MysqlService` - Configures everything needed t run
a MySQL service except the platform service facility. This provider
should never be used directly. The `:start`, `:stop`, `:restart`, and
`:reload` actions are stubs meant to be overridden by the providers
below.

- `Chef::Provider::MysqlService::Systemd` - Starts a `mysql_service`
using SystemD. Manages the unit file and activation state

- `Chef::Provider::MysqlService::Sysvinit` - Starts a `mysql_service`
using SysVinit. Manages the init script and status.

- `Chef::Provider::MysqlService::Upstart` - Starts a `mysql_service`
using Upstart. Manages job definitions and status.

License
-----------------
Forked from https://github.com/chef-cookbooks/mysql

```text
Copyright:: 2009-2014 Chef Software, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
