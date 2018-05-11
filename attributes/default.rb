default[:sphinx][:install_path]     =   "/opt/sphinx"

default[:sphinx][:version]          =   '2.3.2-beta'
default[:sphinx][:url]              =   "http://sphinxsearch.com/files/sphinx-#{node[:sphinx][:version]}.tar.gz"

default[:sphinx][:stemmer_url]      =   "http://snowball.tartarus.org/dist/libstemmer_c.tgz"

# tunable options
default[:sphinx][:use_stemmer]      =   false
default[:sphinx][:use_mysql]        =   true
default[:sphinx][:use_postgres]     =   false

default[:sphinx][:configure_flags]  =   [
  "#{node[:sphinx][:use_stemmer]  ? '--with-libstemmer' : ''}",
  "#{node[:sphinx][:use_mysql]    ? '--with-mysql'      : ''}",
  "#{node[:sphinx][:use_postgres] ? '--with-pgsql'      : ''}"
].reject { |conf_flag| conf_flag.empty? }
