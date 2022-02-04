class Option
  attr_accessor :id, :type, :rental_id, :price_per_day, :beneficiary

  DETAILS = {
    "gps" => { 'price_per_day' => 500, 'beneficiary' => 'owner' },
    "baby_seat" => { 'price_per_day' => 200, 'beneficiary' => 'owner' },
    "additional_insurance" => { 'price_per_day' => 1000, 'beneficiary' => 'drivy' }
  }.freeze

  BENEFICIARIES = DETAILS.values.map { |v| v['beneficiary'] }.uniq.freeze

  def initialize hash
    hash.each do |key, value|
      send("#{key}=", value)
    end
    self.price_per_day = DETAILS[type]['price_per_day']
    self.beneficiary = DETAILS[type]['beneficiary']
    validate_type
    validate_price
  end

  private

  def validate_type
    raise "Invalid type" unless types.include? type
  end

  def validate_price
    raise "Invalid price" unless price_per_day > 0
  end

  def types
    DETAILS.keys
  end

end