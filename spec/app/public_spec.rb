require_relative "../app_spec_helper.rb"
require_relative "../test_data.rb"

def app
  Public
end

describe "Public" do
  describe "GET /" do
    it "responds OK" do
      get "/"
      last_response.status.must_equal 200
    end
  end

  describe "POST /crystallize" do
    it "responds OK" do
      post "/crystallize", TestData.valid_form
      last_response.status.must_equal 200
    end
  end
end
