require 'codebreaker/user.rb'
require 'codebreaker/version.rb'
require 'yaml'

class String
  def is_i?
    !!(self =~ /\A[-+]?[0-9]+\z/)
  end
end

module Codebreaker
  class Game
  	def initialize
  	  @secret_code = ""
  	end

  	def start
  	  @current_user = User.new	
  	  @hint_count = 0 
  	  gen_secrete_code
  	end

  	def hint
  	  result_string = "****"
  	  @hint_count = @hint_count + 1 if @hint_count < 4
  	  
  	  @hint_count.times do |i|
   	    result_string[i] = @secret_code[i]
  	  end
  	  result_string
  	end

  	def try_number(users_number)
  	  raise ArgumentError.new unless users_number.instance_of?(String) 
  	  raise ArgumentError.new unless users_number.size == 4
  	  raise ArgumentError.new unless users_number.is_i?
  	  
  	  result_string = ""
  	  users_number.chars.each_with_index do |ch, index|
  	    if ch == @secret_code[index]
  	  	  result_string += '+' 
  	  	  users_number = users_number.chars.delete_if {|i| i == ch}.to_s
  	  	end
  	  end

  	  result_arr = @secret_code.chars & users_number.chars
  	  result_arr.size.times { result_string += '-' }
  	
  	  @current_user.turns += 1
  	  return result_string.empty? ? "Wrong answer. Try again" : result_string
  	end

  	def save_user_data_to(file)
  	  File.open(file, "a") {|file| file.puts(@current_user.to_yaml) }
  	end

	def set_current_user_name(name)
	  @current_user.name = name
	end

	def get_current_user_name
	  @current_user.name
	end

	private
  	
  	def gen_secrete_code
  	  4.times do
  	    @secret_code += rand(7).to_s
  	  end
  	end

  end
 end
	
