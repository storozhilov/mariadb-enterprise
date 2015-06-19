include_recipe "mariadb::default"

case node[:platform_family]
when "debian"
  package "mariadb-common" do
    action :remove
  end
when "rhel", "fedora", "suse"
  package "MariaDB-common" do
    action :remove
  end
end

include_recipe "mariadb::mdberepos_off"
