defmodule BmwUmbrellaWeb.Router do
  use BmwUmbrellaWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BmwUmbrellaWeb do
    pipe_through :api

    resources "/users", UserController,  only: [:show, :index]
  end
end
