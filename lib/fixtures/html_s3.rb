module JsFixtures
  class HTMLS3 < HTML
    include S3Upload

    @type = :html_s3 

    class << self
      attr_reader :s3_upload_url, :s3_access_url

      def s3_path=(s3_path)
        @s3_upload_url = s3_path
        @s3_access_url = "http://#{s3_path.gsub(':', '/')}"
      end
    end

    def initialize(name, config)
      super
      set_location
    end

    def generate
      puts "Generating Test Fixture: #{@name}"
      super
      puts "Uploading Fixture: #{@path} to S3"
      upload_html_file(@path, "#{self.class.s3_upload_url}/#{@name}.html") 
    end

    def set_location
      set_fixture_path
      @location = "#{self.class.s3_access_url}/#{@name}.html"
    end

  end
end