defmodule ChannexcelInterfaceWeb.PageController do
  use ChannexcelInterfaceWeb, :controller

  alias Channexcel.{QuotetoolSupervisor, User}

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def test(conn, %{"name" => name}) do
    user = %User{name: name, user_type: :dev}
    {:ok, _pid} = QuotetoolSupervisor.start_tool(user)
    conn
    |> put_flash(:info, "Your entered the name: " <> name)
    |> render("index.html")
  end
end
