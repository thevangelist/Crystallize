require "./app.rb"
run Rack::URLMap.new({
  "/" => Public,
  "/admin" => Protected
})
