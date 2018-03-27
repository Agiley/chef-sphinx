#
# Cookbook Name:: sphinx
# Recipe:: default
#
# Copyright 2010, Alex Soto <apsoto@gmail.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
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
