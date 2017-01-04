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
      puts "whoa", resp.buckets.map(&:name)
    end

    def get_file_urls
      get_buckets
    end
  end
end