include_recipe "mariadb::default"

enterprise = node['mariadb']['token'] != ""

case node[:platform_family]
when "debian"
  # Add repo key
  key = enterprise ? "0xce1a3dd5e3c94f49" : "0xcbcb082a1bb943db"
  execute "Key add" do
    command "apt-key adv --recv-keys --keyserver keyserver.ubuntu.com #{key}"
  end
  
  lsb_release = Mixlib::ShellOut.new("lsb_release -cs")
  lsb_release.run_command
  node.default['mariadb']['release_name'] = lsb_release.stdout.chop

  # Add repo
  template "/etc/apt/sources.list.d/#{node['mariadb']['name']}.list" do
    source "mariadb#{enterprise ? 'e' : ''}.deb.erb"
    action :create
  end
  execute "update" do
    command "apt-get update"
  end
when "rhel", "fedora"
  # Add the repo
  template "/etc/yum.repos.d/#{node['mariadb']['name']}.repo" do
    source "mariadb#{enterprise ? 'e' : ''}.rhel.erb"
    action :create
  end
when "suse"
  release_name_cmd = "test -f /etc/os-release && cat /etc/os-release | grep '^ID=' | sed s/'^ID='//g | sed s/'\"'//g || if cat /etc/SuSE-release | grep Enterprise &>/dev/null; then echo sles; else echo opensuse; fi"
  release = Mixlib::ShellOut.new(release_name_cmd)
  release.run_command
  node.default['mariadb']['release_name'] = release.stdout.chop
  # Add the repo
  template "/etc/zypp/repos.d/#{node['mariadb']['name']}.repo" do
    source "mariadb#{enterprise ? 'e' : ''}.suse.erb"
    action :create
  end
when "windows"
  repo = "http://code.mariadb.com/mariadb-enterprise/" + node['mariadb']['token'] + "/"
  arch = node[:kernel][:machine] == "x86_64" ? "winx64" : "win32"
  
  md5sums_file = "#{Chef::Config[:file_cache_path]}/md5sums.txt"
  remote_file "#{md5sums_file}" do
    source repo + node['mariadb']['version'] + "/" + arch + "-packages/md5sums.txt"
  end

  file_name = "mariadb-enterprise-" + node['mariadb']['version'] + "-" + arch + ".msi"

  if File.exists?("#{md5sums_file}")
    f = File.open("#{md5sums_file}")
    f.each {|line|
      match = line.split(" ")
      if match[1].end_with?("msi")
        file_name = match[1]
        break
      end
    }
    f.close
  end

  remote_file "#{Chef::Config[:file_cache_path]}/mariadb.msi" do
    source repo + node['mariadb']['version'] + "/" + arch + "-packages/" + file_name
  end
end
