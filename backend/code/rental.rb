class Rental
  attr_accessor :id, :car_id, :start_date, :end_date, :distance

  def initialize hash
    hash.each do |key, value|
      send("#{key}=", value)
    end
  end

  def compute_price(car)
    ndays = (end_date.mjd - start_date.mjd) + 1
    days_price = ndays * car.price_per_day
    km_price = distance * car.price_per_km
    {
      "id": id,
      "price": km_price + days_price
    }
  end
end