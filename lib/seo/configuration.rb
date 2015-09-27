module Seo
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    attr_reader :database

    # Db configuration
    attr_accessor :db_url
    attr_accessor :db_host
    attr_accessor :db_port
    attr_accessor :db_name
    attr_accessor :db_user
    attr_accessor :db_password

    def database_type=(_type)
      case _type
      when 'postgres'
        Seo::Storage.storage_type = Seo::PostgresStorage.new
        @database_type = 'postgres'
      when 'sequel'
        Seo::Storage.storage_type = Seo::SequelStorage.new
        @database_type = "sequel"
      else
        Seo::Storage.storage_type = Seo::FileStorage.new
        @database_type = 'files'
      end

    end
  end
end
