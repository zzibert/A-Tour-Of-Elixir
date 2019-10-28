defmodule HearthstoneLogic.Helpers.Game do
  alias Db.Library
  alias HearthstoneLogic.UserSupervisor

  def select_user(user_name) do
    UserSupervisor.start_child(user_name)
  end
end
