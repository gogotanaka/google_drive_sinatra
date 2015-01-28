require "aws-sdk"
s3 = AWS::S3.new(
  access_key_id:     ENV['AWS_ACC_ID'],
  secret_access_key: ENV['AWS_ACC_KEY']
)

$bucket = s3.buckets['venuedb']


module HashDecorator
  def venue_types
    @venue["VenueType"].split(", ").map { |e| @tbl[e]  }.uniq
  end

  def latlng
    GogoMaps.get_latlng %|#{@venue["Address"]} #{@venue["City"]} #{@venue["PostalCode"]} canada|
  rescue
    begin
      GogoMaps.get_latlng %|#{@venue["Address"]} #{@venue["PostalCode"]} canada|
    rescue
      false
    end
  end

  def s3_imgs
    id = @venue["VenueId"]
    urls = $bucket.objects.with_prefix("assets/#{id}/").map{|e|e.public_url.to_s}
    urls.select { |url| url.downcase =~ /jpg|jpeg|png/   }
  end
end

include HashDecorator
