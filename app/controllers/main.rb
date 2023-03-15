RpsGame::App.controller do
  layout :game
  require 'byebug'


  get '/' do
    render 'game/index', locals: { choices: Services::GameService.choices }
  end

  get '/throw', params: [:bet] do
    result = Services::GameService.call(params[:bet])

    { result: result }.to_json
  end
end
