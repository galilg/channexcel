defmodule Channexcel.User do
  @enforce_keys [:name, :user_type]
  defstruct [:name, :user_type]
end
