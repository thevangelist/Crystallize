require_relative "../spec_helper.rb"

describe "Validator" do
  describe "valid" do
    it "fails with empty hash" do
      Validator.valid({}).must_equal false
    end

    it "fails with nil" do
      Validator.valid(nil).must_equal false
    end

    it "passes with correct data" do
    data = TestData.valid_form[:crystal]
      Validator.valid(data).must_equal true
    end
  end
end
