defmodule ChannexcelInterfaceWeb.QuotetoolChannel do
  use ChannexcelInterfaceWeb, :channel

  alias Channexcel.{Quotetool, QuotetoolSupervisor, User}

  def channel do
    quote do
      use Phoenix.Channel
      import ChannexcelInterfaceWeb.Gettext
    end
  end


  def join("tool:" <> _user, _payload, socket) do
    {:ok, socket}
  end

  # SAMPLE HANDLE_IN
  # def handle_in("hello", payload, socket) do
  #   broadcast! socket, "said_hello", payload
  #   {:noreply, socket}
  # end

  # def handle_in("bye", payload, socket) do
  #   push socket, "said_hello", payload
  #   {:noreply, socket}
  # end

  # def handle_in("ok", payload, socket) do
  #   {:reply, {:ok, payload}, socket}
  # end


  defp via("tool:" <> owner_name), do: Quotetool.via_tuple(owner_name)
  #---- Handle In -------------------------------------------------------------

  def handle_in("new_tool", payload, socket) do
    "tool:" <> owner_name = socket.topic
    case QuotetoolSupervisor.start_tool(
      %User{name: payload["name"], user_type: payload["user_type"]}) do
      {:ok, _pid} ->
        {:reply, :ok, socket}
      {:error, reason} ->
        {:reply, {:error, %{reason: inspect(reason)}}, socket}
    end
  end

  def handle_in("add_user", payload, socket) do
    case Quotetool.add_user(via(socket.topic), %User{name: payload["name"], user_type: payload["user_type"]}) do
      :ok ->
        broadcast! socket, "user_added", %{message: "New user just joined: " <> payload["name"]}
        {:noreply, socket}
      {:error, reason} ->
        {:reply, {:error, %{reason: inspect(reason)}}, socket}
      :error -> {:reply, :error, socket}
    end
  end

  def handle_in("room_message", payload, socket) do
    broadcast! socket, "generic_message", %{message: payload}
    {:noreply, socket}
  end

  def handle_in("direct_message", payload, socket) do
    broadcast! socket, "direct_message:" <> payload["receiver"],  %{message: payload["message"]}
    {:noreply, socket}
  end

  def handle_in("insert_data", payload, socket) do
    case Quotetool.insert_data(via(socket.topic), payload["sheet_name"], payload["data"]) do
      :ok ->
        {:reply, :ok, socket}
      {:error, reason} ->
        {:reply, {:error, %{reason: inspect(reason)}}, socket}
      :error ->
        {:reply, :error, socket}
    end
  end
end
