defmodule BbWeb.BookLive.Index do
  use BbWeb, :live_view

  alias Bb.Library
  alias Bb.Library.Book

  @impl true
def mount(_params, _session, socket) do
  years = Library.list_years()
  {:ok, assign(socket, page: 1, years: years, selected_year: nil, search_query: "")}
end


  @impl true
def handle_params(params, _url, socket) do
  page = Map.get(params, "page", "1") |> String.to_integer()
  selected_year = Map.get(params, "year")
  search_query = Map.get(params, "search", "")

  list_opts = %{
    "page" => Integer.to_string(page),
    "year" => selected_year,
    "search" => search_query
  }

  {books, metadata} = Library.list_books(list_opts)

  socket =
    socket
    |> assign(:page, metadata.page)
    |> assign(:total_pages, metadata.total_pages)
    |> assign(:has_prev, metadata.page > 1)
    |> assign(:has_next, metadata.page < metadata.total_pages)
    |> assign(:selected_year, selected_year)
    |> assign(:search_query, search_query)
    |> stream(:books, books, reset: true)
    |> apply_action(socket.assigns.live_action, params)

  {:noreply, socket}
end


  @impl true
def handle_event("filter", %{"filter" => %{"year" => year, "search" => search}}, socket) do
  {:noreply, push_patch(socket, to: ~p"/books?page=1&year=#{year}&search=#{search}")}
end


  @impl true
  def handle_info({BbWeb.BookLive.FormComponent, {:saved, book}}, socket) do
    years = Library.list_years()
    {:noreply,
     socket
     |> assign(:years, years)
     |> stream_insert(:books, book)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    book = Library.get_book!(id)
    {:ok, _} = Library.delete_book(book)

    years = Library.list_years()

    {:noreply,
     socket
     |> assign(:years, years)
     |> stream_delete(:books, book)}
  end
  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Book")
    |> assign(:book, Library.get_book!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Book")
    |> assign(:book, %Book{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Books")
    |> assign(:book, nil)
  end
end
