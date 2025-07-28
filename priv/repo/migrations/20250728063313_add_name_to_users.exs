defmodule Bb.Repo.Migrations.AddNameToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :name, :string
      add :dob, :date
    end
  end
end
