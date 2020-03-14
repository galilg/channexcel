defmodule Channexcel.Page do
  alias __MODULE__
  alias Elixlsx.Sheet, as: ESheet
  alias Elixlsx.Workbook
  alias Channexcel.User


  @enforce_keys [:page_name, :owner, :workbook]
  defstruct [:page_name, :owner, :workbook]

  def new(name, %User{} = owner) do
    {:ok, %Page{page_name: name, owner: owner, workbook: %Workbook{}}}
  end
  def new(_, _) do
    {:error, :not_user_type}
  end

  def append_sheet(%Page{} = page, %ESheet{} = sheet) do
    Workbook.append_sheet(page.workbook, sheet)
  end

  def save_workbook(%Workbook{} = workbook, name) when is_binary(name) do
    workbook |> Elixlsx.write_to(name <> ".xlsx")
  end
end
