class Rental
  attr_accessor :id, :car_id, :car, :start_date, :end_date, :distance, :options

  def initialize hash
    hash.each do |key, value|
      send("#{key}=", value)
    end
    self.options=[] if self.options.nil?
  end

  def duration_days
    (end_date.mjd - start_date.mjd) + 1
  end

end