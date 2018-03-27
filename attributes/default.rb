default[:sphinx][:version]          =   '3.0.2-2592786-linux-amd64'
default[:sphinx][:url]              =   "http://sphinxsearch.com/files/sphinx-#{node[:sphinx][:version]}.tar.gz"

default[:sphinx][:install_path]     =   "/usr/local/bin"

default[:sphinx][:binaries]         =   %w(
  indexer
  indextool
  searchd
  wordbreaker
)
