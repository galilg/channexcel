defmodule Channexcel.QuotetoolSupervisor do
  use Supervisor

  alias Channexcel.{Quotetool, User}

  def start_link(_options) do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok), do: Supervisor.init([Quotetool], strategy: :simple_one_for_one)

  def start_tool(%User{} = user), do: Supervisor.start_child(__MODULE__, [user])

  def stop_tool(%User{} = user) do
    :ets.delete(:tool_state, user.name)
    Supervisor.terminate_child(__MODULE__, pid_from_user(user))
  end

  defp pid_from_user(user) do
    user
    |> Quotetool.via_tuple()
    |> GenServer.whereis()
  end
end
