#
# Cookbook Name:: sphinx
# Recipe:: source
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

download_path     =   "#{Chef::Config[:file_cache_path]}/sphinx-#{node[:sphinx][:version]}"
download_file     =   "#{download_path}.tar.gz"

remote_file download_file do
  source node[:sphinx][:url]
  mode      "0644"
  not_if { ::File.exists?(download_file) }
end

bash "Extract Sphinx source" do
  cwd Chef::Config[:file_cache_path]
  
  code <<-EOH
    tar -zxvf #{download_path}.tar.gz
  EOH

  not_if { ::File.exists?(download_path) }
end

if node[:sphinx][:use_stemmer]
  stemmer_file = "#{Chef::Config[:file_cache_path]}/libstemmer_c.tgz"
  
  remote_file stemmer_file do
    source node[:sphinx][:stemmer_url]
    mode      "0644"
    not_if { ::File.exists?(stemmer_file) }
  end
 
  execute "Extract libstemmer source" do
    cwd Chef::Config[:file_cache_path]
    command "tar -C #{download_path} -zxf libstemmer_c.tgz"
    not_if { ::File.exists?("#{download_path}/libstemmer_c/src_c") }
  end
end

bash "Build and Install Sphinx Search" do
  cwd download_path
  
  code <<-EOH
    ./configure #{node[:sphinx][:configure_flags].join(" ")}
    make
    make install
  EOH
  
  not_if { ::File.exists?("/usr/local/bin/searchd") }
end

directory download_path do
  recursive true
  action    :delete
  only_if { ::File.exists?(download_path) }
end