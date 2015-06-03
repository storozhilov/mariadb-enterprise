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
  execute "Repository add" do
    command 'yum -y install http://prdownloads.sourceforge.net/scons/scons-2.3.3-1.noarch.rpm'
  end
end

