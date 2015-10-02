require_relative "bundle/bundler/setup"
require "sinatra"
require "sinatra/config_file"

config_file "config.yml"
set :port, 8080
set :bind, "0.0.0.0" # required to bind to all interfaces
set :root, File.dirname(__FILE__) + "/app"

helpers do
  def authenticate!
    return if authorized?
    headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
    halt 401, "Not authorized\n"
  end

  def authorized?
    @auth ||=  Rack::Auth::Basic::Request.new(request.env)
    @auth.provided? and
      @auth.basic? and
      @auth.credentials and
      @auth.credentials == [settings.user, settings.password]
  end
end

# Render static HTML form.
get "/" do
  erb :form
end

# Create and send PDF from form data.
post "/crystallize" do
  file = Printer.create_pdf(erb :pdf)
  send_file file
end

# Admin page for listing admin stuff.
get "/admin" do
  authenticate!
  "Admin page"
end
