node.set_unless['mariadb']['version'] = "10.0"
node.set_unless['mariadb']['token'] = ""
node.set_unless['mariadb']['name'] = "mariadb"

node.set_unless['mariadb']['instance'] = 'default'

if (node['mariadb']['token'] == "")
  msg = "Enterprise token isn't specified!"
  print msg
  raise msg
end
