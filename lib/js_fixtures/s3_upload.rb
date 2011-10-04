
require 'right_aws'
module S3Upload
  AWS_KEY        = ENV['AWS_ACCESS_KEY_ID'] || raise("Need to have AWS_ACCESS_KEY set in your env")
  AWS_SECRET_KEY = ENV['AWS_SECRET_ACCESS_KEY'] || raise("Need to have AWS_SECRET_ACCESS_KEY set in your env")

  HTML_HEADERS = {"Content-Type" => "text/html" }

  def upload_html_file(file_path, s3_path)
    puts "Uploading from #{file_path} to #{s3_path}"
    uploader = RightAws::S3.new(AWS_KEY, AWS_SECRET_KEY)
    bucket, key = s3_path.split(":")
    bucket = uploader.bucket(bucket)
    bucket.put(key, File.read(file_path), {}, "public-read", HTML_HEADERS)
  end
end
