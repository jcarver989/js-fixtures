
module JsFixtures
  PATH = File.join(File.dirname(__FILE__), "fixtures")
  require "#{PATH}/s3_upload.rb"
  require "#{PATH}/base.rb"
  require "#{PATH}/html.rb"
  require "#{PATH}/html_s3.rb"

  class << self 
    def create(name, config, &block)
      Base.create(name, config, &block)
    end

    def get_location(name)
      Base.get(name)
    end

    def generate_all
      Base.generate_all
    end

    def config(type, &block)
      Base.config(type, &block)
    end
  end
end
