name              'mariadb-enterprise'
maintainer        'MariaDB, Inc.'
maintainer_email  'Andrey.Kuznetsov@mariadb.com'
license           'Apache 2.0'
description       'MariaDB coockbook'
version           '0.0.5'
recipe            'install', 'Installs Enterprise edition'
recipe            'uninstall', 'Uninstalls any edition'
recipe            'purge', 'Uninstalls any edition and remove all data'
recipe            'start', 'Creates new instance of service and starts it'
recipe            'stop', 'Creates new instance of service and starts it'
recipe            'install_backuper', 'Installs backuper package'
recipe            'uninstall_backuper', 'Uninstalls backuper package'
recipe            'backup', 'Creates backup'
recipe            'restore', 'Restore backup'

supports          'redhat'
supports          'centos'
supports          'fedora'
supports          'debian'
supports          'ubuntu'
supports          'suse'

