defmodule Bb.Inventory do
  @moduledoc """
  The Inventory context.
  """

  import Ecto.Query, warn: false
  alias Bb.Repo

  alias Bb.Inventory.ItemStock

  @doc """
  Returns the list of item_stocks.

  ## Examples

      iex> list_item_stocks()
      [%ItemStock{}, ...]

  """
  def list_item_stocks do
    Repo.all(ItemStock)
  end

  @doc """
  Gets a single item_stock.

  Raises `Ecto.NoResultsError` if the Item stock does not exist.

  ## Examples

      iex> get_item_stock!(123)
      %ItemStock{}

      iex> get_item_stock!(456)
      ** (Ecto.NoResultsError)

  """
  def get_item_stock!(id), do: Repo.get!(ItemStock, id)

  @doc """
  Creates a item_stock.

  ## Examples

      iex> create_item_stock(%{field: value})
      {:ok, %ItemStock{}}

      iex> create_item_stock(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_item_stock(attrs \\ %{}) do
    %ItemStock{}
    |> ItemStock.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a item_stock.

  ## Examples

      iex> update_item_stock(item_stock, %{field: new_value})
      {:ok, %ItemStock{}}

      iex> update_item_stock(item_stock, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_item_stock(%ItemStock{} = item_stock, attrs) do
    item_stock
    |> ItemStock.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a item_stock.

  ## Examples

      iex> delete_item_stock(item_stock)
      {:ok, %ItemStock{}}

      iex> delete_item_stock(item_stock)
      {:error, %Ecto.Changeset{}}

  """
  def delete_item_stock(%ItemStock{} = item_stock) do
    Repo.delete(item_stock)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking item_stock changes.

  ## Examples

      iex> change_item_stock(item_stock)
      %Ecto.Changeset{data: %ItemStock{}}

  """
  def change_item_stock(%ItemStock{} = item_stock, attrs \\ %{}) do
    ItemStock.changeset(item_stock, attrs)
  end
end
