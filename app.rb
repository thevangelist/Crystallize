require_relative "bundle/bundler/setup"
require_relative "app/lib/printer.rb"
require_relative "app/lib/validator.rb"
require 'bundler'
Bundler.require :default

require_relative "spec/test_data.rb"

class App < Sinatra::Base
  set :root, File.dirname(__FILE__) + "/app"
end

# Public routes.
class Public < App
  register Sinatra::ConfigFile
  config_file "config.yml"

  # Render static HTML form.
  get "/" do
    erb :form
  end

  # Create and send PDF from form data.
  post "/crystallize" do
    data = params[:crystal]
    return redirect "/" unless Validator.valid(data)
    html = erb(:pdf, locals: {crystal: data})
    file = Printer.create_pdf(html, "files", data[:company])
    send_file(file)
  end

  # FIXME: This is for development purposes only.
  #        Must be removed when going to production.
  get "/test" do
    data = TestData.valid_form[:crystal]
    html = erb(:pdf, locals: {crystal: data})
    file = Printer.create_pdf(html, "files", data[:company])
    send_file(file)
  end
end


# Admin routes protected with HTTP basic auth.
class Protected < App
  register Sinatra::ConfigFile
  config_file "config.yml"

  use Rack::Auth::Basic, "Not Authorized" do |user, password|
    user == settings.user && password == settings.password
  end

  # Admin page for listing admin stuff.
  get "/" do
    "Admin page"
  end
end
