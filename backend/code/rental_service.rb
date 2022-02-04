class RentalService
  attr_accessor :rental

  def initialize(r)
    self.rental = r
  end

  def compute_price(opts = {})
    with_per_day_discount = opts.has_key?(:with_per_day_discount) ? opts[:with_per_day_discount] : true
    format = opts[:format] || :price

    car = rental.car

    if with_per_day_discount
      days_price = (1..rental.duration_days).map { |i| (1 - discount_for_nth_day(i)) * car.price_per_day }.sum
    else
      days_price = rental.duration_days * car.price_per_day
    end
    km_price = rental.distance * car.price_per_km
    price = km_price + days_price

    case format
    when :price
      {
        "id": rental.id,
        "price": price
      }
    when :price_and_commission
      commission = compute_commission_details(price)
      {
        "id": rental.id,
        "price": price,
        "commission": commission
      }
    when :actions
      {
        "id": rental.id,
        "actions": compute_actions
      }
    else
      raise "unknown format"
    end
  end

  private

  #- half goes to the insurance
  #- 1€/day goes to the roadside assistance
  #- the rest goes to us
  def compute_commission_details(price)
    commission_price = price * 0.3
    insurance_fee = commission_price * 0.5
    assistance_fee = rental.duration_days * 100
    drivy_fee = commission_price - (insurance_fee + assistance_fee)
    {
      "insurance_fee": insurance_fee,
      "assistance_fee": assistance_fee,
      "drivy_fee": drivy_fee
    }
  end

  #- price per day decreases by 10% after 1 day
  #- price per day decreases by 30% after 4 days
  #- price per day decreases by 50% after 10 days
  def discount_after_nth_day(n)
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

  def discount_for_nth_day(n)
    discount_after_nth_day(n - 1)
  end

end