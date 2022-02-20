require 'sinatra/base'

class App < Sinatra::Base
  get "/" do
    send_file './app/views/index.html'
  end
end
