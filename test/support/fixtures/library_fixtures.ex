defmodule Bb.LibraryFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Bb.Library` context.
  """

  @doc """
  Generate a book.
  """
  def book_fixture(attrs \\ %{}) do
    {:ok, book} =
      attrs
      |> Enum.into(%{
        author: "some author",
        published_year: 42,
        title: "some title"
      })
      |> Bb.Library.create_book()

    book
  end
end
