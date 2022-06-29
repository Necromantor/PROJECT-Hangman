# frozen_string_literal: true
class Hangman
  attr_accessor :array, :word, :display, :input, :guesses, :letters_guessed, :game_name

  def initialize
    @dictionary = []
    @word = word
    @display = display
    @input = input
    @guesses = 8
    @letters_guessed = ''
    @game_name = game_name
  end

  def start_game
    puts 'Enter new for new game OR Load to continue a previous game:'
    choice = gets.chomp
    game_new if choice == 'new'
    load_game if choice == 'load'
  end

  def game_new
    puts 'Enter a name for your game:'
    @game_name = gets.chomp
    play_game
  end

  def filter_dictionary
    File.open('google-10000-english-no-swears.txt').each do |line|
      line.chomp!
      @dictionary << line if line.length.between?(5, 12)
    end
  end

  def random_word
    filter_dictionary
    self.word = @dictionary.sample.split('')
  end

  def display_game
    random_word
    self.display = word.join.gsub(/[a-z]/, ' _ ').split
  end

  def user_input
    self.input = gets.chomp
    p word 
  end

  def correct_letter
    array = word.each_index.select { |i| word[i] == input }
    array.each { |index| @display[index] = input }
  end

  def status?
    if @guesses.zero? || word.eql?(display)
      'game over'
    else
      'nope'
    end
  end

  def check_input
    user_input

    return if input == 'save'
    return if repeated_letter? == true

    if word.include?(input)
      correct_letter
      puts "Correct guess! Guesses left #{guesses}"
    else
      @guesses -= 1
      puts "Wrong guess! Guesses left #{guesses}"
    end
  end

  def repeated_letter?
    if letters_guessed.include?(input)
      puts 'This letter was alredy guessed!!!'
      true
    else
      false
    end
  end

  def end_game
    return if input == 'save'

    if @guesses.zero?
      puts 'Out of guesses, you lost!'
      puts "The word was: #{word.join}!"
    elsif word.eql?(display)
      puts "Pog! You got it with #{guesses} guesses left"
    end
  end

  def play_game
    puts 'Enter your guess OR type save to save game:'
    display_game if display.nil?
    while status? == 'nope'
      check_input
      break if input == 'save'

      p display.join(' ')
      @letters_guessed += "#{input} " unless letters_guessed.include?(input)
      puts "Letters alredy guessed: #{letters_guessed}" unless letters_guessed.empty?
    end
    end_game
  end

  def load_game
    puts 'Enter your game name:'
    @game_name = gets.chomp
    file = File.new(game_name.to_s, 'r')
    serial = file.read
    reheated = Marshal.load(serial)
    reheated.play_game
  end
end

testing = Hangman.new
testing.start_game

if testing.input == 'save'
  serial = Marshal.dump(testing)
  file = File.new testing.game_name.to_s, 'w'
  file.write serial
end
