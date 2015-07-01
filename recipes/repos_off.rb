include_recipe "mariadb::default"
package 'mariadb-enterprise-repository' do
  action :remove
end
case node[:platform_family]
when "debian"
  execute "update" do
    command "apt-get update"
  end
end
