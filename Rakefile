require 'bundler/setup'
require "google/api_client"
require "google_drive"
require './json_decorator'
require 'pry'

require 'gogo_maps'

# rake dump SESSION=ya29.EQHa3JamBE9InXdykHsW1Auxkpv26y_zbuIYIN1dLQutvSbhC2dDZin618fLhgDBalVC8rZd2S_WSQ
task :dump do
  sheet_num = 2
  google_drive_session = GoogleDrive.login_with_oauth ENV['SESSION']
  venue_key = "1Guy0IPpwXOt_LzIyJS383t8cRYdQy1U26zdeMNqQYk0"
  space_key = "1JLHYqAMyXN3b8qhCsy9uBoVDYjggGw74OJE-96ZuJxs"
  worksheets = {
    venues: google_drive_session.spreadsheet_by_key(venue_key).worksheets,
    spaces: google_drive_session.spreadsheet_by_key(space_key).worksheets
  }
  venues = worksheets[:venues][sheet_num]
  spaces = worksheets[:spaces][sheet_num]

  venue_header = venues.rows[0]
  space_header = spaces.rows[0]

  venues.rows[1200..-1].each.with_index(1) do |venue, i|
    venue_id = venue[0]
    venue_spaces = spaces.rows.select { |id, *_| id == venue_id }

    latlng = latlng(
      venue[venue_header.index("Address")],
      venue[venue_header.index("City")],
      venue[venue_header.index("PostalCode")]
    )
    hash = [venue_header, venue].transpose.to_h.merge({
      latlng: latlng,
      s3_imgs: s3_imgs(venue_id),
      spaces: venue_spaces.map { |space| [space_header, space].transpose.to_h }
    })
    File.open("./jsons/#{venue_id}.string", 'w') { |d| d << hash.to_s }
  end
end
