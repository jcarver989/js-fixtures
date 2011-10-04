module JsFixtures
  class HTMLS3 < HTML
    include S3Upload

    @type = :html_s3 
    @template = File.join File.dirname(__FILE__), "../../template/html_template.html.erb"

    class << self
      attr_reader :s3_upload_url, :s3_access_url

      def s3_path=(s3_path)
        @s3_upload_url = s3_path
        @s3_access_url = "http://#{s3_path.gsub(':', '/')}"
      end
    end


    def initialize(name, config)
      super

      # Number of seconds since 1970-01-01 00:00:00 UTC
      # to avoid test collisions from multiple machines
      suffix = Time.now.strftime("%s")
      @filename = "#{@name}-#{suffix}.html"
      @location = "#{self.class.s3_access_url}/#{@filename}"
    end

    def generate
      puts "Generating Fixture: #{@name}"
      super
      upload_html_file(@local_file, "#{self.class.s3_upload_url}/#{@filename}") 
    end
  end
end
