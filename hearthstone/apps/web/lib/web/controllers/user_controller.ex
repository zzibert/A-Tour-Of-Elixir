defmodule Web.UserController do
  use Web, :controller

  alias HearthstoneLogic.Helpers
  alias HearthstoneLogic.UserSupervisor
  alias Db.Library.User

  def index(conn, _params) do
    render(conn, "user.html", users: Helpers.User.get_all_users!(), chosen_users: Helpers.User.get_all_users!())
  end

  def start_child(conn, %{"user_name" => user_name}) do
    UserSupervisor.start_child(user_name)
    render(conn, "user.html", users: Helpers.User.get_all_users!())
  end

  def login(conn, _params) do
      render(conn, "login.html")
  end
end
