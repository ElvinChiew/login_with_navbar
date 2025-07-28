defmodule Bb.InventoryTest do
  use Bb.DataCase

  alias Bb.Inventory

  describe "item_stocks" do
    alias Bb.Inventory.ItemStock

    import Bb.InventoryFixtures

    @invalid_attrs %{name: nil, location: nil, quantity: nil}

    test "list_item_stocks/0 returns all item_stocks" do
      item_stock = item_stock_fixture()
      assert Inventory.list_item_stocks() == [item_stock]
    end

    test "get_item_stock!/1 returns the item_stock with given id" do
      item_stock = item_stock_fixture()
      assert Inventory.get_item_stock!(item_stock.id) == item_stock
    end

    test "create_item_stock/1 with valid data creates a item_stock" do
      valid_attrs = %{name: "some name", location: "some location", quantity: 42}

      assert {:ok, %ItemStock{} = item_stock} = Inventory.create_item_stock(valid_attrs)
      assert item_stock.name == "some name"
      assert item_stock.location == "some location"
      assert item_stock.quantity == 42
    end

    test "create_item_stock/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Inventory.create_item_stock(@invalid_attrs)
    end

    test "update_item_stock/2 with valid data updates the item_stock" do
      item_stock = item_stock_fixture()
      update_attrs = %{name: "some updated name", location: "some updated location", quantity: 43}

      assert {:ok, %ItemStock{} = item_stock} =
               Inventory.update_item_stock(item_stock, update_attrs)

      assert item_stock.name == "some updated name"
      assert item_stock.location == "some updated location"
      assert item_stock.quantity == 43
    end

    test "update_item_stock/2 with invalid data returns error changeset" do
      item_stock = item_stock_fixture()
      assert {:error, %Ecto.Changeset{}} = Inventory.update_item_stock(item_stock, @invalid_attrs)
      assert item_stock == Inventory.get_item_stock!(item_stock.id)
    end

    test "delete_item_stock/1 deletes the item_stock" do
      item_stock = item_stock_fixture()
      assert {:ok, %ItemStock{}} = Inventory.delete_item_stock(item_stock)
      assert_raise Ecto.NoResultsError, fn -> Inventory.get_item_stock!(item_stock.id) end
    end

    test "change_item_stock/1 returns a item_stock changeset" do
      item_stock = item_stock_fixture()
      assert %Ecto.Changeset{} = Inventory.change_item_stock(item_stock)
    end
  end
end
