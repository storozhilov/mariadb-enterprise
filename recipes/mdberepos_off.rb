include_recipe "mariadb::default"


case node[:platform_family]
when "debian"
  execute "Remove #{node['mariadb']['name']} repository" do
    command "rm -fr /etc/apt/sources.list.d/" + node['mariadb']['name'] + ".list"
  end
  execute "update" do
    command "apt-get update"
  end
when "rhel", "fedora", "suse"
  execute "Remove repo" do
    command "rm -fr /etc/yum.repos.d/" + node['mariadb']['name'] + ".repo /etc/zypp/repos.d/" + node['mariadb']['name'] + ".repo*"
  end
end
