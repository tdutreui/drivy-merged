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
@options = input['options'].map { |o| Option.new(o) }

def find_car(rental)
  @cars.find { |c| c.id == rental.car_id }
end

def find_options(rental)
  @options.select { |o| o.rental_id == rental.id }
end

output = {}
output[:rentals] = @rentals.map do |r|
  r.car = find_car(r)
  r.options = find_options(r)
  RentalService.new(r).compute_output(format: :actions_with_options)
end

File.write(output_filepath, output.to_json)

