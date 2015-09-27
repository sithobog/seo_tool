require_relative 'file_storage'
require_relative 'postgres_storage'
require_relative 'sequel_storage'

module Seo
	class Storage
	
		class << self
	    attr_accessor :storage_type
	  end

    def self.all_reports
      storage_type.all_reports
    end

    def self.add_report(report)
      storage_type.add_report(report)
    end

    def self.find_report(guid)
      storage_type.find_report(guid)
    end

    def self.drop_tables
      storage_type.drop_tables
    end

	end
end
