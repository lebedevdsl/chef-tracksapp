postgresql 'main' do
  cluster_version node['tracksapp']['dbversion']
  cluster_create_options( locale: 'ru_RU.UTF-8' )
  configuration(
      listen_addresses: 'localhost'
  )
  hba_configuration(
    [
      { type: 'host', database: node['tracksapp']['dbname'], user: node['tracksapp']['dbuser'], address: 'localhost', method: 'md5' },
    ]
  )
end

postgresql_user node['tracksapp']['dbuser'] do
  in_version node['tracksapp']['dbversion']
  in_cluster 'main'
  unencrypted_password node['tracksapp']['dbpass']
end

postgresql_database node['tracksapp']['dbname'] do
  in_version node['tracksapp']['dbversion']
  in_cluster 'main'
  owner node['tracksapp']['dbuser']
end
