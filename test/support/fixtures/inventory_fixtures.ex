defmodule Bb.InventoryFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Bb.Inventory` context.
  """

  @doc """
  Generate a item_stock.
  """
  def item_stock_fixture(attrs \\ %{}) do
    {:ok, item_stock} =
      attrs
      |> Enum.into(%{
        location: "some location",
        name: "some name",
        quantity: 42
      })
      |> Bb.Inventory.create_item_stock()

    item_stock
  end
end
