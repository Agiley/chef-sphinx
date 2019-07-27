default[:sphinx][:version]          =   '3.1.1-612d99f-linux-amd64'
default[:sphinx][:url]              =   "http://sphinxsearch.com/files/sphinx-#{node[:sphinx][:version]}.tar.gz"

default[:sphinx][:install_path]     =   "/usr/local/bin"

default[:sphinx][:binaries]         =   %w(
  indexer
  indextool
  searchd
  wordbreaker
)
