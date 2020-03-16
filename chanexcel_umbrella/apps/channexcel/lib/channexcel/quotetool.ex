defmodule Channexcel.Quotetool do
  use GenServer, start: {__MODULE__, :start_link, []}, restart: :transient

  alias Channexcel.{Page, User}
  alias Channexcel.Sheet, as: ChanSheet
  @permitted_roles [:dev, :trader, :marketer, "dev"]
  @timeout 1000 * 60 * 60 * 24 #24 hours in milliseconds
  #---- Init ------------------------------------------------------------------
  def init(%User{} = owner) do
    send(self(), {:set_state, owner})
    {:ok, fresh_state(owner.name, owner)}
  end


  def fresh_state(book_name, %User{} = owner) do
    users = MapSet.new([owner])
    case Page.new(book_name, owner.name) do
      {:ok, page} -> %{users: users, page: page}
      {:error, reason} -> {:error, reason}
    end
  end

  def start_link(%User{} = owner)  do
    GenServer.start_link(__MODULE__, owner, name: via_tuple(owner.name))
  end

  #---- Handle Info -----------------------------------------------------------
  def handle_info({:set_state, owner}, _state_data) do
    state_data =
      case :ets.lookup(:tool_state, owner.name) do
        [] -> fresh_state(owner.name, owner)
        [{_key, state}] -> state
      end
      :ets.insert(:tool_state, {owner.name, state_data})
      {:noreply, state_data, @timeout}
  end

  def handle_info(:timeout, state_data) do
    {:stop, {:shutdown, :timeout}, state_data}
  end

  # def add_user_to_list(state_data, %User{} = user) do
  #   %{state_data | users: MapSet.put(state_data.users, user)}
  # end
  #---- Handle Calls ----------------------------------------------------------
  def handle_call({:add_user, user}, _from, state_data) do
    state_data
    |> add_user_to_list(user)
    |> reply_success(:ok)
  end

  def handle_call({:delete_user, user}, _from, state_data) do
    state_data
    |> remove_user_from_list(user)
    |> reply_success(:ok)
  end

  def handle_call({:insert_data, sheet_name, contents}, _from, state_data) do
    state_data.page.workbook.sheets
    |> find_sheet(sheet_name)
    |> ChanSheet.insert_at(contents)
    |> update_workbook_sheet(state_data)
    |> reply_success(:ok)
  end

  def handle_call({:new_sheet, sheet_name}, _from, state_data) do
    put_in(state_data.page.workbook.sheets, [ChanSheet.new(sheet_name) | state_data.page.workbook.sheets])
    |> reply_success(:ok)
  end

  #---- Calls -----------------------------------------------------------------
  def add_user(quotetool, %User{} = user) do
    GenServer.call(quotetool, {:add_user, user})
  end

  def delete_user(quotetool, %User{} = user) do
    GenServer.call(quotetool, {:delete_user, user})
  end

  def insert_data(quotetool, sheet_name, contents) do
    GenServer.call(quotetool, {:insert_data, sheet_name, contents})
  end

  def delete_data(quotetool, sheet_name, index) do
    GenServer.call(quotetool, {:insert_data, sheet_name, [{index, nil}]})
  end

  def new_sheet(quotetool, sheet_name) do
    GenServer.call(quotetool, {:new_sheet, sheet_name})
  end

  #---- Helpers --------------------------------------------------------------
  def update_workbook_sheet(sheet, state_data) do
    i = Enum.find_index(state_data.page.workbook.sheets, fn x -> x.name == sheet.name end)
    l = List.replace_at(state_data.page.workbook.sheets, i, sheet)
    new_state_data = put_in(state_data.page.workbook.sheets, l)
    state_data = new_state_data
    |> IO.inspect()
  end

  def add_user_to_list(state_data, %User{} = user) do
    case user.user_type in (@permitted_roles) do
      true -> %{state_data | users: MapSet.put(state_data.users, user)}
      false -> {:reply, :error, state_data}
    end
  end

  def remove_user_from_list(state_data, user) do
    case user.user_type in (@permitted_roles) do
      true -> %{state_data | users: MapSet.delete(state_data.users, user)}
      false -> {:reply, :error, state_data}
    end
  end

  def reply_success(state_data, reply) do
    :ets.insert(:tool_state, {state_data.page.owner, state_data})
    {:reply, reply, state_data, @timeout}
  end

  def via_tuple(owner_name), do: {:via, Registry, {Registry.Quotetool, owner_name}}

  def terminate({:shutdown, :timeout}, state_data) do
    :ets.delete(:tool_state, state_data.page.owner.name)
    :ok
  end

  def terminate(_reason, _state), do: :ok

  def find_sheet(sheets, name) do
    Enum.filter(sheets, fn(x) -> x.name == name end)
    |> List.first()
  end

end



