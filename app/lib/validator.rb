require "hash_validator"

module Validator
  def self.valid(data)
    return false if data.nil?
    valid_hash?(data)
  end

  private

  def self.valid_hash?(data)
    validator = HashValidator.validate(data, validations)
    validator.valid?
  end

  def self.validations
    {
      email: "string",
      category_cards_green: "string",
      category_cards_red: "string",
      topaasia_green: "string",
      improvement_green: "string",
      lead_green: "string",
      topaasia_red: "string",
      improvement_red: "string",
      lead_red: "string",
      last_used: "string",
      rating: "string"
    }
  end
end
