defmodule BbWeb.ItemStockLive.Index do
  use BbWeb, :live_view

  alias Bb.Inventory
  alias Bb.Inventory.ItemStock

  @impl true

  def mount(_params, %{"user_token" => token}, socket) do

    #IO.inspect(token, label: "this is a message")
    user = Bb.Accounts.get_user_by_session_token(token)
    IO.inspect(user)
    if user.role == "admin" do
      {:ok, stream(socket, :item_stocks, Inventory.list_item_stocks())}
    else
      {:ok,
        socket
        |> put_flash(:error, "Access denied.")
        |> push_navigate(to: "/")}
    end

    #{:ok, stream(socket, :item_stocks, Inventory.list_item_stocks())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Item stock")
    |> assign(:item_stock, Inventory.get_item_stock!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Item stock")
    |> assign(:item_stock, %ItemStock{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Item stocks")
    |> assign(:item_stock, nil)
  end

  @impl true
  def handle_info({BbWeb.ItemStockLive.FormComponent, {:saved, item_stock}}, socket) do
    {:noreply, stream_insert(socket, :item_stocks, item_stock)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    item_stock = Inventory.get_item_stock!(id)
    {:ok, _} = Inventory.delete_item_stock(item_stock)

    {:noreply, stream_delete(socket, :item_stocks, item_stock)}
  end
end
