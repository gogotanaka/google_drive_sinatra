require 'bundler/setup'

require 'sinatra/base'
require 'haml'

require './json_decorator'

Bundler.require(:default, :development)

class App < Sinatra::Base
  enable :sessions

  get '/' do
    @session = session[:oauth_token]
    haml :index
  end

  get '/json/:id' do
    content_type :json
    ::JSON.pretty_generate(
      eval File.read("./jsons/#{params[:id]}.string")
    )
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
