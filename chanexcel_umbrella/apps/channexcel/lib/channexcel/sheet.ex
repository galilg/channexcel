defmodule Channexcel.Sheet do
  alias __MODULE__
  alias Elixlsx.Sheet, as: ESheet

  def new(name) do
    ESheet.with_name(name)
  end

  def insert_at(sheet, contents) do #when is_list(contents) do
    case contents do
      [] ->
        sheet
      [{index, content, opts} | tail] ->
        sheet = ESheet.set_cell(sheet, index, content, opts)
        insert_at(sheet, tail)
      [{index, content} | tail] ->
        sheet = ESheet.set_cell(sheet, index, content)
        insert_at(sheet, tail)
    end
  end
end
