Seo.configure do |config|
  # Postgres config
  config.db_host = 'localhost'
  config.db_port = '5432'
  config.db_name = 'seo_test'
  #config.db_user = 'tester'
  #config.db_password = 'test_password'

  config.database_type = 'postgres'
end
