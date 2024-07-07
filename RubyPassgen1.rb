require 'securerandom'
require 'optparse'

# Method to generate a random password
def generate_password(length, options)
  # Define the character sets based on user options
  uppercase_letters = options[:uppercase] ? ('A'..'Z').to_a : []
  lowercase_letters = options[:lowercase] ? ('a'..'z').to_a : []
  numbers = options[:numbers] ? ('0'..'9').to_a : []
  special_characters = options[:special] ? ['!', '@', '#', '$', '%', '^', '&', '*', '(', ')', '-', '_', '=', '+'] : []

  # Combine all character sets into one array
  all_characters = uppercase_letters + lowercase_letters + numbers + special_characters

  # Ensure there is at least one character set selected
  raise ArgumentError, "At least one character set must be selected" if all_characters.empty?

  # Shuffle the characters and select random characters based on the desired length
  password = []
  length.times do
    password << all_characters[SecureRandom.random_number(all_characters.length)]
  end

  # Join the array of characters into a single string and return the password
  password.join
end

# Function to prompt the user for input and validate it
def prompt_for_input(prompt, regex)
  loop do
    puts prompt
    input = gets.chomp
    return input if input.match?(regex)

    puts "Invalid input. Please try again."
  end
end

# Function to write passwords to a file
def write_passwords_to_file(passwords, file_name)
  File.open(file_name, 'w') do |file|
    passwords.each do |password|
      file.puts(password)
    end
  end
end

# Parse command-line options
options = {
  length: 12,
  number: 1,
  file: 'passwords.txt',
  uppercase: true,
  lowercase: true,
  numbers: true,
  special: true
}

OptionParser.new do |opts|
  opts.banner = "Usage: password_generator.rb [options]"

  opts.on("-l", "--length LENGTH", Integer, "Password length (default: 12)") do |l|
    options[:length] = l
  end

  opts.on("-n", "--number NUMBER", Integer, "Number of passwords (default: 1)") do |n|
    options[:number] = n
  end

  opts.on("-f", "--file FILE", String, "Output file (default: passwords.txt)") do |f|
    options[:file] = f
  end

  opts.on("--[no-]uppercase", "Include uppercase letters (default: true)") do |u|
    options[:uppercase] = u
  end

  opts.on("--[no-]lowercase", "Include lowercase letters (default: true)") do |l|
    options[:lowercase] = l
  end

  opts.on("--[no-]numbers", "Include numbers (default: true)") do |n|
    options[:numbers] = n
  end

  opts.on("--[no-]special", "Include special characters (default: true)") do |s|
    options[:special] = s
  end
end.parse!

# Main logic to determine password length, generate passwords, and store them
password_length = options[:length]
number_of_passwords = options[:number]

passwords = []
number_of_passwords.times do
  passwords << generate_password(password_length, options)
end

write_passwords_to_file(passwords, options[:file])

puts "Generated passwords have been saved to #{options[:file]}"
