require 'sinatra/base'
require 'dotenv'

Dotenv.load
ENV['RACK_ENV'] ||= 'development'

class App < Sinatra::Base
  set :root, File.dirname(__FILE__)
  set :public_dir, Proc.new { File.join(root, "app/views") }

  configure :development do |c|
    require 'sinatra/reloader'
    register Sinatra::Reloader
    c.also_reload "./app/**/*.rb"
  end

  get "/" do
    send_file './app/views/index.html'
  end

  get "/join/:code" do
    send_file './app/views/join.html'
  end
end
