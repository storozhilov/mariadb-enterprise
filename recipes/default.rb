node.set_unless['mariadb']['version'] = "10.0"
node.set_unless['mariadb']['token'] = ""
node.set_unless['mariadb']['repo'] = "http://code.mariadb.com/mariadb-enterprise/" + node['mariadb']['token'] + "/"
node.set_unless['mariadb']['name'] = "mariadb"

node.set_unless['mariadb']['base_dir'] = "/usr"
node.set_unless['mariadb']['data_dir'] = "/var/lib/mysql"
#node.set_unless['mariadb']['socket_file'] = ""
