class Car
  attr_accessor :id, :price_per_day, :price_per_km

  def initialize hash
    hash.each do |key, value|
      send("#{key}=", value)
    end
  end
end