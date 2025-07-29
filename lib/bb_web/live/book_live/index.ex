defmodule BbWeb.BookLive.Index do
  use BbWeb, :live_view

  alias Bb.Library
  alias Bb.Library.Book

  @impl true
  def mount(_params, _session, socket) do
    # {:ok, stream(socket, :books, Library.list_books())}
    {:ok, assign(socket, page: 1)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    page = Map.get(params, "page", "1") |> String.to_integer()

    {books, metadata} = Library.list_books(%{"page" => Integer.to_string(page)})

    socket =
      socket
      |> assign(:page, metadata.page)
      |> assign(:total_pages, metadata.total_pages)
      |> assign(:has_prev, metadata.page > 1)
      |> assign(:has_next, metadata.page < metadata.total_pages)
      |> stream(:books, books, reset: true)
      |> apply_action(socket.assigns.live_action, params)

    {:noreply, socket}
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

  @impl true
  def handle_info({BbWeb.BookLive.FormComponent, {:saved, book}}, socket) do
    {:noreply, stream_insert(socket, :books, book)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    book = Library.get_book!(id)
    {:ok, _} = Library.delete_book(book)

    {:noreply, stream_delete(socket, :books, book)}
  end
end
