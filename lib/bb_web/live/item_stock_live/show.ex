defmodule BbWeb.ItemStockLive.Show do
  use BbWeb, :live_view

  alias Bb.Inventory

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:item_stock, Inventory.get_item_stock!(id))}
  end

  defp page_title(:show), do: "Show Item stock"
  defp page_title(:edit), do: "Edit Item stock"
end
