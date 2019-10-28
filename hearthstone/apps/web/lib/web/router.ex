defmodule Web.Router do
  use Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Web do
    pipe_through :browser

    get "/", GameController, :index
    get "/user", UserController, :index
    get "/user/start/:user_name", UserController, :start_child
    get "/start_game/:game_name", GameController, :start_game
    get "/generic", GameController, :generic_function
    get "/card", CardController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", Web do
  #   pipe_through :api
  # end
end
