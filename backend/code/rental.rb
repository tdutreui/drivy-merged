class Rental
  attr_accessor :id, :car_id, :start_date, :end_date, :distance

  def initialize hash
    hash.each do |key, value|
      send("#{key}=", value)
    end
  end

  def compute_price(car,opts={})
    with_per_day_discount=opts[:with_per_day_discount]||false

    ndays = (end_date.mjd - start_date.mjd) + 1

    if with_per_day_discount
      days_price = (1..ndays).map { |i| (1 - Rental.discount_for_nth_day(i)) * car.price_per_day }.sum
    else
      days_price = ndays * car.price_per_day
    end

    km_price = distance * car.price_per_km
    {
      "id": id,
      "price": km_price + days_price
    }
  end

=begin
  - price per day decreases by 10% after 1 day
  - price per day decreases by 30% after 4 days
  - price per day decreases by 50% after 10 days
=end
  def self.discount_after_nth_day(n)
    case n
    when (10..)
      0.5
    when (4..)
      0.3
    when (1..)
      0.1
    else
      0
    end
  end

  def self.discount_for_nth_day(n)
    discount_after_nth_day(n - 1)
  end
end