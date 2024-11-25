require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def new
    @letters = 10.times.map { ('A'..'Z').to_a.sample }
  end

  def score
    @word = params[:word]
    @letters = params[:letters].split

    if !check_word_is_valid?(@word)
      @result = "Sorry but '#{@word}' is not a valid English word."
    elsif !check_word_can_be_formed_from_grid(@word, @letters)
      @result = "Sorry but '#{@word}' can't be built out of #{@letters.join(', ')}."
    else
      @result = "Congratulations! '#{@word}' is a valid word!"
    end
  end

  def check_word_is_valid?(word)
    url = "https://dictionary.lewagon.com/#{word}"
    response = URI.parse(url).read
    j_response = JSON.parse(response)
    j_response['found']
  end

  def check_word_can_be_formed_from_grid(word, grid)
    letter_count = Hash.new(0)
    grid.each { |letter| letter_count[letter] += 1 }
    word.chars.each do |letter|
      return false if letter_count[letter.upcase].zero?

      letter_count[letter.upcase] -= 1
    end
    true
  end
end
