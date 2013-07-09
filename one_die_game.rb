class Player
	attr_reader :name
	def initialize(name)
		@name = name
	end
end

class Die
	def roll
		rand(6) + 1
	end

	def possible_moves(current_face)
		(1..6).to_a.reject { |x| x == current_face || x == 7 - current_face } 
	end
end

class Computer
end

class Game
	def initialize
		p "Welcome, challenger. Please enter your name: "
		name = gets.chomp
		@player = Player.new(name)
		@die = Die.new
		@computer = Computer.new
		@max_score = 31
		@current_score = @current_face = @die.roll
		puts "#{@player.name} has started the game with a #{@current_score}"
		play_game
	end

	def pick_next_move
		possible_moves = @die.possible_moves(@current_face)
		puts "please pick between #{possible_moves}:"
		choice = gets.chomp.to_i
		if valid_choice(possible_moves, choice)
			@current_face = choice
			@current_score += choice
		else
			puts "Pick a valid number!"
			pick_next_move
		end
	end

	def valid_choice(possible_moves, choice)
		possible_moves.any? { |x| x == choice }
	end

	def computer_next_move
		possible_moves = @die.possible_moves(@current_face)
		computer_pick = possible_moves.sample
		@current_face = computer_pick
		@current_score += @current_face 
		puts "the computer chose #{computer_pick}"
	end

	def play_game
		until @current_score >= 31
			computer_next_move
			if @current_score > 31
				puts "#{@player.name} wins!"
			elsif @current_score == 31
				puts "computer wins!"
			else
				puts "The current score is #{@current_score}"	
				pick_next_move
				if @current_score > 31
					puts "Computer wins!"
				elsif @current_score == 31
					puts "#{@player.name} wins!"
				else
				end
			end
		end
	end

end

Game.new
