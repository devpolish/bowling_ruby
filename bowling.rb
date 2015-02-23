# Game class governs player turn management and scoreboard
class Game
  MAX_PLAYERS = 6

  attr_reader :players, :player_index

  def initialize(names)
    raise ArgumentError.new("Must play with 6 or less players") if names.size > MAX_PLAYERS
    @players = []
    names.each {|name| @players << Player.new(name)}
    reset_player
    announce_player
  end

  def switch_player
    if player_index < players.size - 1
      @player_index += 1
    else
      reset_player
    end
  end
  
  def announce_player
    puts "#{current_player.name} to bowl"
  end

  def nextPlayer
    switch_player if current_player.frames.last.finished?
    announce_player unless finished?
  end
  
  def reset_player
    @player_index = 0
  end

  def current_player
    players[player_index]
  end

  def play(pins)
    return "Game is finished, check the scoreboard!" if finished?
    current_player.bowl(pins)
    puts "#{current_player.name} bowled #{pins} pin(s)"
    nextPlayer
  end
  
  def print_player(player)
    board = player.scoreboard
    board_line = "-" * board.size
    puts board_line
    puts board
    puts board_line
  end

  def scoreboard
    players.each {|player| print_player(player)}
  end

  def finished?
    players.last.finished?
  end
end

# Player class governs the frames of a player and player scoring
class Player
  MAX_FRAMES = 10

  attr_reader :name, :frames

  def initialize(name)
    @name = name
    @frames = []
    new_frame
  end

  def bowl(pins)
    new_frame if current_frame.finished?
    current_frame.bowl(pins)
  end
  
  def next_two_bowls(frame_no)
    next_two_frames = frames[(frame_no + 1)..(frame_no + 2)]
    next_bowls = next_two_frames.inject([]) {|bowls, frame| bowls += frame.bowls if frame.finished?} || []
    next_bowls.take(2)
  end

  def score
    initial_frames_score + bonus_frame_score
  end
  
  def bonus_frame_score
    bonus_frame_total = 0
    last_frame = frames.last
    bonus_frame_total += last_frame.score if frames.size == MAX_FRAMES && last_frame.finished?
    bonus_frame_total
  end

  def initial_frames_score
    frame_no = 0
    total_score = 0
    while frame_no < MAX_FRAMES - 1 && frame_no < frames.size
      frame = frames[frame_no]
      break unless frame.finished?
      total_score += total_frame_score(frame, frame_no)
      frame_no += 1
    end
    total_score
  end
  
  def total_frame_score(frame, frame_no)
    total_score = frame.score
    total_score += bonus_scorekeeper(frame, frame_no) if frame.bonus?
    total_score
  end
  
  def bonus_scorekeeper(frame, frame_no)
    total = 0
    two_bowls = next_two_bowls(frame_no)
    if frame.strike? && two_bowls.size == 2
      total += two_bowls.reduce(:+)
    elsif frame.spare? && !two_bowls.first.nil?
      total += two_bowls.first
    end
    total
  end
 
  def scoreboard
    scoreboard_string = "#{name}:".ljust(15)
    frames.each do |frame|
      scoreboard_string << frame.to_s.ljust(6)
    end
    scoreboard_string << "|".ljust(6) << "#{score}"
    scoreboard_string
  end
  
  def finished?
    frames.size == MAX_FRAMES && frames.last.finished?
  end

  private

  attr_reader :current_frame
  attr_writer :frames

  def new_frame
    if frames.size == MAX_FRAMES - 1
      frames << BonusFrame.new
    else
      frames << Frame.new
    end
    @current_frame = frames.last
  end
end

# Frame class models a bowling frame, monitoring knocked down pins
class Frame
  MAX_PINS = 10
  STRIKE = 'X'
  SPARE = '/'
  GUTTER = '-'
  
  attr_accessor :bowls, :remaining_pins
  
  def initialize
    @bowls = []
    @remaining_pins = MAX_PINS        
  end

  def bowl(pins)
    remaining = remaining_pins - pins
    raise ArgumentError.new("Invalid number of pins") if remaining < 0 || pins > MAX_PINS
    @remaining_pins = remaining
    bowls << pins
  end                            

  def first_bowl
    bowls.first
  end

  def second_bowl
    bowls[1]
  end

  def score
    bowls.reduce(:+)  
  end  
  
  def bonus?
    score == MAX_PINS
  end
  
  def strike?
    first_bowl == MAX_PINS
  end

  def spare?
    bonus? && !strike?
  end

  def gutter?
    bowls.size == 2 && score == 0
  end
  
  def finished?
    bowls.size == 2 || remaining_pins == 0
  end
  
  def to_s
    if strike?
      STRIKE
    elsif spare?
      "#{bowls.first}#{SPARE}"
    else
      bowls.join("|").gsub("0", GUTTER)
    end
  end
end

# BonusFrame class models the final bonus frame
class BonusFrame < Frame
  
  def bowl(pins)
    remaining = remaining_pins - pins
    raise ArgumentError.new("Invalid number of pins") if (remaining < 0 && extra_bowls == 0) || pins > MAX_PINS
    @remaining_pins = remaining unless bonus?
    bowls << pins
  end    
  
  def bonus?
    bowls.take(2).reduce(:+) == MAX_PINS || strike?
  end
  
  def extra_bowls
    if strike?
      2
    elsif spare?
      1
    else
      0
    end
  end

  def finished?
    (bowls.size == 2 && !bonus?) || (bonus? && bowls.size == 3)
  end
  
  def to_s
    remaining_bowls = bowls.dup
    bowl_string = ""
    frame = Frame.new
    until remaining_bowls.empty?
      frame.bowl(remaining_bowls.shift)
      if frame.finished?
        bowl_string << frame.to_s
        frame = Frame.new
      end
    end
    bowl_string << frame.to_s unless frame.finished?
    bowl_string
  end
end