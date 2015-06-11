include_recipe "mariadb::develop"

case node[:platform_family]
when "suse"
when "debian"
when "windows"
else
package 'xulrunner-devel'
package 'varnish'
package 'policycoreutils-python'
package 'selinux-policy-devel'
end
