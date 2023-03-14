RpsGame::App.controller do
  layout :game

  get "/" do
    render "game/index"
  end
end
