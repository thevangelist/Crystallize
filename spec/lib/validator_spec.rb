require_relative "../spec_helper.rb"

describe "Validator" do
  describe "valid" do
    it "It should return allways true" do
      Validator.valid({}).must_equal true
    end
  end
end
