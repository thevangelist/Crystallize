require_relative "bundle/bundler/setup"
require "sinatra"
require "sinatra/config_file"
require "pdfkit"

config_file "config.yml"
set :port, 8080
set :bind, "0.0.0.0" # required to bind to all interfaces

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
  send_file "static/form.html"
end

# Create and send PDF from form data.
post "/crystallize" do
  html = "content"
  kit = PDFKit.new(html, :page_size => "A4")
  timestamp = Time.now.strftime('%Y%m%d-%H%M%S')
  file = kit.to_file("files/submission-#{timestamp}.pdf")
  send_file file
end

# Admin page for listing admin stuff.
get "/admin" do
  authenticate!
  "Admin page"
end
