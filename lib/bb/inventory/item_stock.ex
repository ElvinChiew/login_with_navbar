defmodule Bb.Inventory.ItemStock do
  use Ecto.Schema
  import Ecto.Changeset

  schema "item_stocks" do
    field :name, :string
    field :location, :string
    field :quantity, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(item_stock, attrs) do
    item_stock
    |> cast(attrs, [:name, :quantity, :location])
    |> validate_required([:name, :quantity, :location])
  end
end
