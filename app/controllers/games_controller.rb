require 'net/http'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @letters = params[:letters]
    @word = params[:word]

    @message = if !can_form_word?(@word, @letters)
                 "Sorry but, \"#{@word}\" can't be built off the letters."
               elsif !valid_english_word?(@word)
                 "Sorry but, \"#{@word}\" is not a valid English word."
               else
                 "Congratulations! \"#{@word}\" is a valid English word!"
               end
  end

  private

  def can_form_word?(word, letters)
    word.upcase.chars.all? { |char| word.upcase.count(char) <= letters.count(char) }
  end

  def valid_english_word?(word)
    url = "https://dictionary.lewagon.com/#{word}"
    response = Net::HTTP.get(URI(url))
    JSON.parse(response)['found']
  rescue StandardError => e
    Rails.logger.error "Error while checking word: #{e.message}"
    false
  end
end
