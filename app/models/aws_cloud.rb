require 'aws-sdk'

Aws.config.update({
  region: ENV['AWS_REGION'] || 'us-west-2',
  credentials: Aws::Credentials.new(
    ENV['AWS_API_KEY'],
    ENV['AWS_API_SECRET']
  )
})

class AwsCloud
  class << self
    def get_buckets
      s3 = Aws::S3::Client.new
      resp = s3.list_buckets
      resp.buckets.map(&:name)
    end

    def get_file_urls
      base_s3_url = "https://s3.amazonaws.com/"
      bucket = ENV['AWS_S3_CSV_BUCKET']
      s3 = Aws::S3::Client.new
      resp = s3.list_objects(bucket: bucket)

      csv_urls = resp.contents.map do |obj|
        base_s3_url + + "#{bucket}/" + obj.key.gsub(" ", "+")
      end
      puts 'csv_urls', csv_urls
    end
  end
end
