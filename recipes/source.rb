include_recipe "build-essential"

download_path     =     "#{Chef::Config[:file_cache_path]}/sphinx-#{node[:sphinx][:version]}" 
download_file     =     "#{download_path}.tar.gz"
 
remote_file download_file do
  source node[:sphinx][:url]
  mode      "0644"
  not_if { ::File.exists?(download_file) }
end

bash "Extract Sphinx source" do
  cwd Chef::Config[:file_cache_path]
  
  code <<-EOH
    tar -zxvf #{download_file}
    rm -rf #{download_file}
  EOH

  not_if { ::File.exists?(download_path) }
end

node[:sphinx][:binaries].each do |binary|
  bash "Copy Sphinx binary #{binary}" do

    code <<-EOH
      cp #{download_path}/bin/#{binary} #{node[:sphinx][:install_path]}
    EOH

    not_if { ::File.exists?("#{node[:sphinx][:install_path]}/#{binary}") }
  end
end

directory download_path do
  recursive true
  action    :delete
  only_if { ::File.exists?(download_path) }
end
