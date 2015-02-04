require 'bundler/setup'

require 'sinatra/base'
require 'haml'

require "google/api_client"
require "google_drive"

require './google_docer'
require './json_decorator'

Bundler.require(:default, :development)

class App < Sinatra::Base
  enable :sessions

  get '/' do
    haml :index
  end

  get '/show/*/:column' do
    return redirect '/' unless session[:oauth_token] && $worksheets

    sheet_num = case params[:splat].first
    when 'van' then 1
    when 'sf' then 2
    end

    google_drive_session = GoogleDrive.login_with_oauth(session[:oauth_token])
    $debug = google_drive_session
    @venue, @spaces = get_sheet(sheet_num, params[:column].to_i)
    haml :show
  end

  get '/json/:sheet/:column' do

    if $worksheets.nil?
      google_drive_session = GoogleDrive.login_with_oauth(session[:oauth_token])
      venue_key = "1Guy0IPpwXOt_LzIyJS383t8cRYdQy1U26zdeMNqQYk0"
      space_key = "1JLHYqAMyXN3b8qhCsy9uBoVDYjggGw74OJE-96ZuJxs"

      $worksheets = {
        venues: google_drive_session.spreadsheet_by_key(venue_key).worksheets[0..0].map { |e| VenueSheet.new(e) } ,
        spaces: google_drive_session.spreadsheet_by_key(space_key).worksheets[0..0].map { |e| VenueSpaceSheet.new(e) }
      }
    end

    content_type :json
    @venue, @spaces = get_sheet(params[:sheet].to_i, params[:column].to_i)
    ::JSON.pretty_generate(
      [$venue_table.keys, @venue.ary[0..47]].transpose.to_h.merge({
        latlng: latlng,
        spaces: @spaces.map {|e| e[0..11] }.map { |e| [$space_table.keys, e].transpose.to_h }
      })
    )
  end

  get '/json_tmp/:sheet/:column' do
    content_type :json
    ::JSON.pretty_generate(
      eval File.read("./jsons/#{params[:column]}.string")
    )
  end


  def get_sheet(sheet_num, col_num)
    venues = $worksheets[:venues][sheet_num]
    spaces = $worksheets[:spaces][sheet_num]

    [
      Venue.new(venues.find("VenueId", col_num)),
      spaces.select(1, col_num)
    ]
  end

  post '/login/' do
    client = settings.google_client
    redirect client.authorization.authorization_uri
  end

  get '/oauth2callback' do
    client = settings.google_client.tap do |obj|
      obj.authorization.code = params['code']
      obj.authorization.fetch_access_token!
    end

    session[:oauth_token] = client.authorization.access_token


    redirect '/'
  end

  configure do
    google_client = Google::APIClient.new.tap do |obj|
      obj.authorization.client_id     = ENV['CLIENT_ID']
      obj.authorization.client_secret = ENV['CLIENT_SECRET']
      obj.authorization.scope         = 'https://www.googleapis.com/auth/drive https://docs.google.com/feeds/ https://docs.googleusercontent.com/ https://spreadsheets.google.com/feeds/'
      obj.authorization.redirect_uri  = ENV['GOOGLE_DRIVE_REDIRECT_URI']
    end

    set :google_client, google_client
  end
end
