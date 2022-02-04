require 'json'
require 'date'
require '../code/car'
require '../code/rental'
require '../code/rental_service'
require '../code/option'

input = JSON.parse(File.read('data/input.json'))
output_filepath = 'data/output.json'

@cars = input['cars'].map { |c| Car.new(c) }
@rentals = input['rentals'].map do |r|
  r['start_date'] = Date.parse(r['start_date'])
  r['end_date'] = Date.parse(r['end_date'])
  Rental.new(r)
end

def find_car(car_id)
  @cars.find { |c| c.id == car_id }
end

output = { rentals: @rentals.map { |r| r.car = find_car(r.car_id); RentalService.new(r).compute_output(format: :actions) } }
File.write(output_filepath, output.to_json)

