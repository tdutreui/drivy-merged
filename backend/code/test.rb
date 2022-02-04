require 'json'

output_filepath = '../level1/data/output.json'
expected_output_filepath = '../level1/data/expected_output.json'

Dir.chdir('../level1'){
  system("ruby", "main.rb")
}

output=JSON.parse(File.read(output_filepath))
expected_output=JSON.parse(File.read(expected_output_filepath))

if output == expected_output
  puts "OK"
else
  puts "Error"
  puts "output:"
  puts output
  puts "expected:"
  puts expected_output
end