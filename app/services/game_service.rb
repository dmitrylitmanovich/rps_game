class GameService
  require 'typhoeus'
  
  CHOICES = %w[
    rock
    paper
    scissors
  ]

  class << self
    def call
      c_choice = ''
      response = api_call
      unless response
        c_choice = CHOICES.sample
      end
      p c_choice
    end

    private

    def api_call
      url = ENV['GAME_API_URL']
      hydra = Typhoeus::Hydra.new   # to run requests in parallel
      requests = 5.times.map {
        request = Typhoeus::Request.new(url, followlocation: true)
        hydra.queue(request)
        request
      }
      hydra.run

      responses = requests.map { |request|
        request.response.body
      }
      responses.find { |s| s.length > 0 }
    end
  end
end

GameService.call
