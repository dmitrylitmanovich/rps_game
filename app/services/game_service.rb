module Services
  class GameService
    require 'typhoeus'
    
    CHOICES = %w[
      rock
      paper
      scissors
    ]
    POWERS = {
      "rock" => {
        beat: [ "scissors" ]
      },
      "paper" => {
        beat: [ "rock" ]
      },
      "scissors" => {
        beat: [ "paper" ]
      }
    }
    STATUSES = {
      tie: "tie",
      won: "won",
      lose: "lose"
    }

    class << self
      def choices
        CHOICES
      end

      def call(u_choice=nil)
        # return false unless CHOICES.include? u_choice

        response = api_call
        c_choice = if response
                    response
                   else
                    CHOICES.sample
                   end
        p u_choice, c_choice
        decision(u_choice, c_choice)
      end

      private

      def api_call
        url = RpsGame::App.settings.game_api_url
        hydra = Typhoeus::Hydra.new   # to run requests in parallel
        requests = 5.times.map {
          request = Typhoeus::Request.new(url, followlocation: true)
          hydra.queue(request)
          request
        }
        hydra.run

        responses = requests.map do |request|
          JSON.parse(request.response.body)['body']
        end
        responses.find { |s| s && s.length > 0 }
      end

      def decision(u_choice, c_choice)
        return STATUSES[:tie] if u_choice == c_choice

        if POWERS[u_choice][:beat].include? c_choice
          return STATUSES[:won]
        else
          return STATUSES[:lose]
        end
      end
    end
  end
end
