RpsGame::App.controller do
  layout :game

  get '/' do
    render 'game/index', locals: { choices: Services::GameService.choices }
  end

  get '/throw', params: [:bet] do
    result = Services::GameService.call(params[:bet])

    result.to_json
  end
end
