class Player
	attr_reader :name

	def initialize(name)
		@name = name
	end

	def pick_next_move(die, current_score)
		puts "please pick between #{die.possible_moves}:"
		choice = gets.chomp.to_i
		if die.valid_choice(choice)
			die.current_face = choice
		else
			puts "Pick a valid number!"
			pick_next_move(die, current_score)
		end
		choice
	end

end

class Die

	attr_accessor :current_face

	def initialize
		@current_face = roll
	end

	def roll
		rand(6) + 1
	end

	def possible_moves
		(1..6).to_a.reject { |x| x == current_face || x == 7 - current_face } 
	end

	def valid_choice(choice)
		possible_moves.any? { |x| x == choice }
	end

end

class Computer

	def next_move(die, current_score)
		points_left = 31 - current_score
		puts "computer must pick between #{die.possible_moves}:"
		sleep(0.5)
		if can_win?(die, points_left)
			computer_pick = pick_winning_number(die, points_left)
		else
			computer_pick = die.possible_moves.sample
			die.current_face = computer_pick 
		end
			puts "the computer chose #{computer_pick}"
			computer_pick
	end

	def can_win?(die, points_left)
		die.possible_moves.any? { |x| x == points_left }
	end

	def pick_winning_number(die, points_left)
		die.possible_moves.select { |x| x == points_left }.first
	end

end

class Game
	attr_accessor :current_score

	def initialize
		p "Welcome, challenger. Please enter your name:"
		name = gets.chomp
		@player = Player.new(name)
		@die = Die.new
		@computer = Computer.new
		@max_score = 31
		@current_score = @die.current_face
		puts "#{@player.name} has started the game with a #{@current_score}"
	end

	def computer_play
		@current_score += @computer.next_move(@die, @current_score)
	end

	def player_play
		@current_score += @player.pick_next_move(@die, @current_score)
	end

	def play_game
		until @current_score >= 31
			computer_play
			if computer_game_over?
				break
			end
			puts "The current score is #{@current_score}"	
			player_play
			if player_game_over?
				break
			end
		end
	end

	def computer_game_over?
		if @current_score > 31
			puts "#{@player.name} wins!"
		elsif @current_score == 31
			puts "Computer wins!"
		end
	end

	def player_game_over?
		if @current_score > 31
			puts "Computer wins!"
		elsif @current_score == 31
			puts "#{@player.name} wins!"
		end
	end

end

if $PROGRAM_NAME == __FILE__
	game = Game.new
	game.play_game
end

