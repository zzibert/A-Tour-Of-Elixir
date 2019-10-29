defmodule BmwUmbrellaWeb.UserView do

  def render("user.json", %{user: user}) do
    %{id: user.id, email: user.email, is_active: user.is_active}
  end
  
end