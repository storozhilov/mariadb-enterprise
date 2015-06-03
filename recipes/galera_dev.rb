package 'cmake' 
package 'make' 
package 'gcc'
package 'git'
package 'vim'
package 'wget'
package 'boost'
case node[:platform_family]
when "debian"
when "fedora", "rhel", "suse"
  package 'epel-release'
  package 'openssl-devel'
  package 'check-devel'
  package 'boost-devel'
  package 'gcc-c++'
  package 'ncurses-devel'
  package 'libaio-devel'
  package 'rpm-build'
  package 'jemalloc-devel'
  package 'http://prdownloads.sourceforge.net/scons/scons-2.3.3-1.noarch.rpm'
end

execute "checkout" do
  command "cd && git clone https://github.com/nirbhayc/galera.git && cd galera && git checkout mariadb-25.3.9 && ./scripts/build.sh -r 25.3.9 -p"
end

case node[:platform_family]
when "debian"
when "rhel"
  execute "share" do
    command "cp ~/galera/*.rpm /vagrant"
  end
end