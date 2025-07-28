defmodule Bb.Repo.Migrations.CreateItemStocks do
  use Ecto.Migration

  def change do
    create table(:item_stocks) do
      add :name, :string
      add :quantity, :integer
      add :location, :string

      timestamps(type: :utc_datetime)
    end
  end
end
