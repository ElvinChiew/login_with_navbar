defmodule Bb.Library do
  @moduledoc """
  The Library context.
  """

  import Ecto.Query, warn: false
  alias Bb.Repo

  alias Bb.Library.Book

  @doc """
  Returns the list of books.

  ## Examples

      iex> list_books()
      [%Book{}, ...]

  """
  def list_books do
    Repo.all(Book)
  end

  @doc """
  Gets a single book.

  Raises `Ecto.NoResultsError` if the Book does not exist.

  ## Examples

      iex> get_book!(123)
      %Book{}

      iex> get_book!(456)
      ** (Ecto.NoResultsError)

  """
  def get_book!(id), do: Repo.get!(Book, id)

  @doc """
  Creates a book.

  ## Examples

      iex> create_book(%{field: value})
      {:ok, %Book{}}

      iex> create_book(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_book(attrs \\ %{}) do
    %Book{}
    |> Book.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a book.

  ## Examples

      iex> update_book(book, %{field: new_value})
      {:ok, %Book{}}

      iex> update_book(book, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_book(%Book{} = book, attrs) do
    book
    |> Book.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a book.

  ## Examples

      iex> delete_book(book)
      {:ok, %Book{}}

      iex> delete_book(book)
      {:error, %Ecto.Changeset{}}

  """
  def delete_book(%Book{} = book) do
    Repo.delete(book)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking book changes.

  ## Examples

      iex> change_book(book)
      %Ecto.Changeset{data: %Book{}}

  """
  def change_book(%Book{} = book, attrs \\ %{}) do
    Book.changeset(book, attrs)
  end

  def list_books(params) when is_map(params) do
    page = Map.get(params, "page", "1") |> String.to_integer()
    per_page = 10
    offset = (page - 1) * per_page
    year = Map.get(params, "year")

    query =
      Book
      |> maybe_filter_year(year)

    total_count = Repo.aggregate(query, :count, :id)

    books =
      query
      |> limit(^per_page)
      |> offset(^offset)
      |> Repo.all()

    total_pages = div(total_count + per_page - 1, per_page)

    metadata = %{
      page: page,
      total_pages: total_pages,
      total_count: total_count
    }

    {books, metadata}
  end

  defp maybe_filter_year(query, nil), do: query
  defp maybe_filter_year(query, ""), do: query
  defp maybe_filter_year(query, year), do: where(query, [b], b.published_year == ^year)

  # Fallback
  def list_books(), do: list_books(%{})
  # Backward-compatible clause
  def list_books(), do: list_books(%{})

  def list_years do
    Book
    |> select([b], b.published_year)
    |> distinct(true)
    |> order_by(:published_year)
    |> Repo.all()
  end

end
