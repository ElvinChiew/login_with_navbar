defmodule BbWeb.BookLive.Bookpage do
alias Bb.Library
  use BbWeb, :live_view

  alias Bb.Repo
  alias Bb.Library.Book

  import Ecto.Query

  @page_size 10

  def mount(_params, _session, socket) do
    #{:ok, assign_defaults(socket)}
    years = Library.list_years()
    {:ok, assign(socket, page: 1, years: years, selected_year: nil)}
  end

  def handle_params(%{"page" => page_param}, _uri, socket) do
    page = max(String.to_integer(page_param), 1)
    load_page(socket, page)
  end

  def handle_params(_params, _uri, socket) do
    load_page(socket, 1)
  end

  defp load_page(socket, page) do
    {books, total_count} = load_books(page: page)

    {:noreply,
     socket
     |> assign(:books, books)
     |> assign(:page, page)
     |> assign(:total_count, total_count)
     |> assign(:total_pages, total_pages(total_count))}
  end

  defp assign_defaults(socket) do
    socket
    |> assign(:books, [])
    |> assign(:page, 1)
    |> assign(:total_count, 0)
    |> assign(:total_pages, 1)
  end

  defp query(opts) do
    preload_opt = Keyword.get(opts, :preload, [])
    from(b in Book, preload: ^preload_opt)
  end

  def load_books(opts \\ []) do
    page = Keyword.get(opts, :page, 1)
    q = query(opts)

    total_count = Repo.aggregate(q, :count, :id)
    offset_value = (page - 1) * @page_size

    books =
      q
      |> limit(^@page_size)
      |> offset(^offset_value)
      |> Repo.all()

    {books, total_count}
  end

  defp total_pages(total_count) do
    total_count
    |> Kernel./(@page_size)
    |> Float.ceil()
    |> trunc()
  end
end
