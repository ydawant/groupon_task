require_relative '../one_die_game.rb'
require 'rspec'

describe 'Player' do

  before do
    @player = Player.new("Yannick") 
    @die = Die.new
    @die.current_face = 6
  end

  it "should require a name as input" do
    expect {Player.new}.to raise_exception
  end

  it "should not allow for a wrong number to be chosen" do
    @player.stub!(:gets).and_return('7', '5')
    printed = capture_out do
      @player.pick_next_move(@die, 5)
    end
    expect(printed.chomp).to eq("please pick between [2, 3, 4, 5]:\nPick a valid number!\nplease pick between [2, 3, 4, 5]:")
  end

  it "should return the chosen number if valid" do
    @player.stub!(:gets).and_return('5')
    @player.pick_next_move(@die, 5).should eq 5
  end

end

describe 'Die' do

  before do
    @die = Die.new
    @die.current_face = 6
  end

  it "should roll a number between 1-6" do
    @die.roll.should be_between(1, 6)
  end

  it "should be able to tell what the possible choices are" do
    @die.possible_moves.should eq [2,3,4,5]
  end

  it "should be able to determine if the choice by the user is valid" do
    @die.valid_choice(5).should eq true
  end

  it "should be able to determine if the choice by the user is invalid" do
    @die.valid_choice(6).should eq false
    @die.valid_choice(1).should eq false
  end

  it "should be able to determine if a number is outside the scope" do
    @die.valid_choice(10).should eq false
  end

end


describe 'Computer' do

  before do
    @computer = Computer.new
    @die = Die.new
    @die.current_face = 6
  end

  it "should be able to determine it can not win on the next turn if too many points left" do
    @computer.can_win?(@die, 12).should eq false
  end

  it "should be able to determine it can not win on the next turn if the necessary number isn't available" do
    @computer.can_win?(@die, 6).should eq false
  end

  it "should be able to determine it can win on the next turn" do
    @computer.can_win?(@die, 5).should eq true
  end

  it "should be able to pick the winning number" do
    @computer.pick_winning_number(@die, 5).should eq 5
  end

  it "should return a viable number if the winning number is not available" do
    @computer.next_move(@die, 20).should be_between(2,5)
  end

  it "should return the winning number if the winning number is not available" do
    @computer.next_move(@die, 26).should eq 5
  end
  
end

describe 'Game' do

  before do
    @game = Game.new
  end

  it "should be able to determine if the computer DID NOT ended the game" do
    @game.computer_game_over?.should eq nil
  end

  it "should be able to determine if the computer ended and WON the game" do
    @game.current_score = 31
    printed = capture_out do
      @game.computer_game_over?
    end
    expect(printed.chomp).to eq("Computer wins!")
  end

  it "should be able to determine if the computer ended and LOST the game" do
    @game.current_score = 32
    printed = capture_out do
      @game.computer_game_over?
    end
    expect(printed.chomp).to eq(" wins!")
  end

  it "should be able to determine if the player DID NOT end the game" do
    @game.player_game_over?.should eq nil
  end

  it "should be able to determine if the player ended and WON the game" do
    @game.current_score = 31
    printed = capture_out do
      @game.player_game_over?
    end
    expect(printed.chomp).to eq(" wins!")
  end

  it "should be able to determine if the player ended and LOST the game" do
    @game.current_score = 32
    printed = capture_out do
      @game.player_game_over?
    end
    expect(printed.chomp).to eq("Computer wins!")
  end

end

def capture_out(&block)
  old_stdout = $stdout
  fake_stdout = StringIO.new
  $stdout = fake_stdout
  block.call
  fake_stdout.string
ensure
  $stdout = old_stdout
end



