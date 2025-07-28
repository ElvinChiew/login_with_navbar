defmodule BbWeb.ItemStockLive.FormComponent do
  use BbWeb, :live_component

  alias Bb.Inventory

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage item_stock records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="item_stock-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:quantity]} type="number" label="Quantity" />
        <.input field={@form[:location]} type="text" label="Location" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Item stock</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{item_stock: item_stock} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Inventory.change_item_stock(item_stock))
     end)}
  end

  @impl true
  def handle_event("validate", %{"item_stock" => item_stock_params}, socket) do
    changeset = Inventory.change_item_stock(socket.assigns.item_stock, item_stock_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"item_stock" => item_stock_params}, socket) do
    save_item_stock(socket, socket.assigns.action, item_stock_params)
  end

  defp save_item_stock(socket, :edit, item_stock_params) do
    case Inventory.update_item_stock(socket.assigns.item_stock, item_stock_params) do
      {:ok, item_stock} ->
        notify_parent({:saved, item_stock})

        {:noreply,
         socket
         |> put_flash(:info, "Item stock updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_item_stock(socket, :new, item_stock_params) do
    case Inventory.create_item_stock(item_stock_params) do
      {:ok, item_stock} ->
        notify_parent({:saved, item_stock})

        {:noreply,
         socket
         |> put_flash(:info, "Item stock created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
