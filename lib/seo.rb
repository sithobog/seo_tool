require 'pathname'
require 'seo/application'
require 'seo/configuration'

module Seo
  # Load configuration
  #
  def self.config
    @config ||= Config.new(root_path.join('config', 'application.yml'))
  end
  
  # Lesson1.root_path.join('..')
  #
  def self.root_path
    @root_path ||= Pathname.new( File.dirname(File.expand_path('../', __FILE__)) )
  end
end
