defmodule HearthstoneLogic.UserSupervisor do
  use Supervisor

  alias HearthstoneLogic.User

  # API #

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def start_child(user_name) do
    Supervisor.start_child(__MODULE__, [user_name])
  end

  # Callbacks #

  def init([]) do
    children = [
      worker(User, [], restart: :transient)
    ]

    opts = [strategy: :simple_one_for_one]

    supervise(children, opts)
  end

  # Helper Functions #
end
