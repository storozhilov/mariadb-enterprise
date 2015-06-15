node.set_unless['maria']['name'] = "mariadb"

case node[:platform_family]
when "debian"
  execute "Remove #{node['maria']['name']} repository" do
    command "rm -fr /etc/apt/sources.list.d/" + node['maria']['name'] + ".list"
  end
  execute "update" do
    command "apt-get update"
  end
when "rhel", "fedora", "suse"
  execute "Remove repo" do
    command "rm -fr /etc/yum.repos.d/" + node['maria']['name'] + ".repo /etc/zypp/repos.d/" + node['maria']['name'] + ".repo*"
  end
end
