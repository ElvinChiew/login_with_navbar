defmodule Bb.Repo.Migrations.CreateBooks do
  use Ecto.Migration

  def change do
    create table(:books) do
      add :title, :string
      add :author, :string
      add :published_year, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
