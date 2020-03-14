defmodule Channexcel.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Starts a worker by calling: Channexcel.Worker.start_link(arg)
      # {Channexcel.Worker, arg}
      {Registry, keys: :unique, name: Registry.Quotetool},
      Channexcel.QuotetoolSupervisor
    ]

    :ets.new(:tool_state, [:public, :named_table])
    opts = [strategy: :one_for_one, name: Channexcel.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
