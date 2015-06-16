include_recipe "mariadb::default"

mysql_service node['mariadb']['instance'] do
  action [:stop, :delete]
end
