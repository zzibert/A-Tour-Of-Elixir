defmodule BmwUmbrellaWeb.Router do
  use BmwUmbrellaWeb, :router

  # alias BmwUmbrellaWeb.Api.UserController

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BmwUmbrellaWeb do
    pipe_through :api

    get "/users", UserController, :index
    post "/users", UserController, :receive_vin_and_token
  end
end
