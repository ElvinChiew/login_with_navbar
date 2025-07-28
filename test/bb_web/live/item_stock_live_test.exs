defmodule BbWeb.ItemStockLiveTest do
  use BbWeb.ConnCase

  import Phoenix.LiveViewTest
  import Bb.InventoryFixtures

  @create_attrs %{name: "some name", location: "some location", quantity: 42}
  @update_attrs %{name: "some updated name", location: "some updated location", quantity: 43}
  @invalid_attrs %{name: nil, location: nil, quantity: nil}

  defp create_item_stock(_) do
    item_stock = item_stock_fixture()
    %{item_stock: item_stock}
  end

  describe "Index" do
    setup [:create_item_stock]

    test "lists all item_stocks", %{conn: conn, item_stock: item_stock} do
      {:ok, _index_live, html} = live(conn, ~p"/item_stocks")

      assert html =~ "Listing Item stocks"
      assert html =~ item_stock.name
    end

    test "saves new item_stock", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/item_stocks")

      assert index_live |> element("a", "New Item stock") |> render_click() =~
               "New Item stock"

      assert_patch(index_live, ~p"/item_stocks/new")

      assert index_live
             |> form("#item_stock-form", item_stock: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#item_stock-form", item_stock: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/item_stocks")

      html = render(index_live)
      assert html =~ "Item stock created successfully"
      assert html =~ "some name"
    end

    test "updates item_stock in listing", %{conn: conn, item_stock: item_stock} do
      {:ok, index_live, _html} = live(conn, ~p"/item_stocks")

      assert index_live |> element("#item_stocks-#{item_stock.id} a", "Edit") |> render_click() =~
               "Edit Item stock"

      assert_patch(index_live, ~p"/item_stocks/#{item_stock}/edit")

      assert index_live
             |> form("#item_stock-form", item_stock: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#item_stock-form", item_stock: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/item_stocks")

      html = render(index_live)
      assert html =~ "Item stock updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes item_stock in listing", %{conn: conn, item_stock: item_stock} do
      {:ok, index_live, _html} = live(conn, ~p"/item_stocks")

      assert index_live |> element("#item_stocks-#{item_stock.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#item_stocks-#{item_stock.id}")
    end
  end

  describe "Show" do
    setup [:create_item_stock]

    test "displays item_stock", %{conn: conn, item_stock: item_stock} do
      {:ok, _show_live, html} = live(conn, ~p"/item_stocks/#{item_stock}")

      assert html =~ "Show Item stock"
      assert html =~ item_stock.name
    end

    test "updates item_stock within modal", %{conn: conn, item_stock: item_stock} do
      {:ok, show_live, _html} = live(conn, ~p"/item_stocks/#{item_stock}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Item stock"

      assert_patch(show_live, ~p"/item_stocks/#{item_stock}/show/edit")

      assert show_live
             |> form("#item_stock-form", item_stock: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#item_stock-form", item_stock: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/item_stocks/#{item_stock}")

      html = render(show_live)
      assert html =~ "Item stock updated successfully"
      assert html =~ "some updated name"
    end
  end
end
