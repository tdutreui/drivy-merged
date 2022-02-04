require 'json'


levels=[1,2,3,4,5]
levels.each do |id|
  output_filepath = "../level#{id}/data/output.json"
  expected_output_filepath = "../level#{id}/data/expected_output.json"
  File.delete(output_filepath) if File.exist?(output_filepath)

  Dir.chdir("../level#{id}"){
    system("ruby", "main.rb")
  }

  output=JSON.parse(File.read(output_filepath))
  expected_output=JSON.parse(File.read(expected_output_filepath))

  if output == expected_output
    puts "level#{id} - OK"
  else
    puts "level#{id} - Error"
    puts "output:"
    puts output
    puts "expected:"
    puts expected_output
  end
end
