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


  defp via("tool:" <> subtopic, name, user_type), do: Quotetool.via_tuple(%User{name: name, user_type: user_type})
  #---- Handle In -------------------------------------------------------------

  def handle_in("new_tool", payload, socket) do
    "tool:" <> subtopic = socket.topic
    case QuotetoolSupervisor.start_tool(%User{name: payload["name"], user_type: payload["user_type"]}) do
      {:ok, _pid} ->
        {:reply, :ok, socket}
      {:error, reason} ->
        {:reply, {:error, %{reason: inspect(reason)}}, socket}
    end
  end

  # def handle_in("add_user", name, user_type, socket) do
  #   case Quotetool.add_user(via(socket.topic, name, user_type), %)
  # end


end
