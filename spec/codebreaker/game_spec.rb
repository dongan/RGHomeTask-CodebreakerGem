require 'spec_helper'

module Codebreaker
  describe Game do
  	let(:game) { Game.new }

  	before do
      game.start
    end

  	context "#start" do
	  it "generates secret code" do
	  	expect(game.instance_variable_get(:@secret_code)).not_to be_empty
	  end
	  
	  it "saves 4 numbers secret code" do
	  	expect(game.instance_variable_get(:@secret_code)).to have(4).items
	  end
      
      it "saves secret code with 1-6 numbers" do
      	game = Game.new
      	
      	100.times do
	      game.start
          expect(game.instance_variable_get(:@secret_code)).to match(/[1-6]/)
        end
      end
      
    end
  
  	context "#hint" do
  	  it "shows 1 more number in the code" do
  		game.instance_variable_set(:@secret_code,"1234")
  		result_string1 = game.hint
  		result_string2 = game.hint
  		result_string3 = game.hint
  		result_string4 = game.hint
  		result_string5 = game.hint

  		expect(result_string1).to eql("1***")
  		expect(result_string2).to eql("12**")
  		expect(result_string3).to eql("123*")
  		expect(result_string4).to eql("1234")
  		expect(result_string5).to eql("1234")
  		end
  	end

  	context "#try_number" do
  	  it "returns some string" do
    	result_string = game.try_number("1234")
  	    expect(result_string).not_to be_empty 	
  	  end

  	  it "raises ArgumentError in case of wrong input " do
        ['Hello', '12,34', '1a34', 'abcD', '12345', '12', '',
        123, 12.2, nil, ["Hello",20], {n1:2, n2:"sss"}].each do |input_str|
          begin
            expect(game.try_number(input_str)).to raise_error(ArgumentError)
          rescue ArgumentError
          end
        end
      end

  	  it "returns four pluses in case of the correct number" do
  	  	game.instance_variable_set(:@secret_code,"1234")
  	    result_string = game.try_number("1234")

  	    expect(result_string).to eql("++++")
  	  end
  	  
  	  it "returns 'try_again' if user doesn't guess " do
  	  	game.instance_variable_set(:@secret_code,"1234")
  	  	result_string = game.try_number("5678")

  	  	expect(result_string).to eql("Wrong answer. Try again")
  	  end
  	  
  	  it "returns correct output string if user guessed" do
		    game.instance_variable_set(:@secret_code,"1234")
  	  	result_string1 = game.try_number("5278")
  	  	result_string2 = game.try_number("5618")
  	  	result_string3 = game.try_number("4638")

  	  	game.instance_variable_set(:@secret_code,"1214")
  	  	result_string4 = game.try_number("7133")
  	  	result_string5 = game.try_number("1833")
  	  	

  	  	expect(result_string1).to eql("+")
  	  	expect(result_string2).to eql("-")
  	  	expect(result_string3).to eql("+-")
  	  	expect(result_string4).to eql("-")
  	    expect(result_string5).to eql("+")
  	  end
  	   
    end

  	context "#save_user_data_to" do
  	  it "saves user results to file" do	
  	  game.try_number("2222")
  		game.try_number("2223")

  		OldFile = File 
  		File = double 
  		file = double
  		
  		expect(file).to receive(:puts).with("--- !ruby/object:User\nturns: 2\nname: noname\n")
  		expect(File).to receive(:open).with("test.yaml","a").and_yield(file)
  		
  		game.save_user_data_to("test.yaml")
  		File = OldFile
  	  end
  	end

  	context "#set_current_user_name" do
      it "saves user name" do
        game.set_current_user_name("Denis")
        user = game.instance_variable_get(:@current_user)
        expect(user.name).to eql("Denis") 
      end
  	end


  end
end