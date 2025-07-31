defmodule BbWeb.BookLive.Bookdboard do
  use BbWeb, :live_view
  alias LiveCharts.Chart

  def mount(_params, _session, socket) do
    # Dummy stats and book data
    stats = %{total_books: 120, total_authors: 35, books_today: 8}
    featured_book = %{title: "The Elixir Way", author: "Jane Beam", summary: "In-depth journey into functional programming with Elixir.", cover_url: "https://via.placeholder.com/150"}

    books = [
      %{title: "Learn Phoenix", author: "Max Dev", pages: 320, published: "2023‑09‑12"},
      %{title: "LiveView in Action", author: "Sally Code", pages: 280, published: "2024‑01‑15"},
      %{title: "Functional Elixir", author: "Tom Lambda", pages: 400, published: "2022‑06‑08"}
    ]


    {:ok,
     socket
     |> assign(:stats, stats)
     |> assign(:featured_book, featured_book)
     |> assign(:books, books)}
  end

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-7xl px-6 py-8 space-y-12">
      <h1 class="text-5xl font-extrabold text-center text-indigo-600">Books Dashboard</h1>

      <!-- Negative space and icon row -->
      <div class="flex justify-center space-x-6 text-gray-700">
        <div class="text-6xl">📊</div>
        <div class="text-6xl">📚</div>
        <div class="text-6xl">📈</div>
      </div>

      <!-- Statistics Cards -->
      <div class="grid grid-cols-1 sm:grid-cols-3 gap-8 text-white">
        <div class="bg-indigo-700 p-8 rounded-lg shadow-lg hover:shadow-xl transition">
          <p class="text-sm uppercase tracking-wider">Total Books</p>
          <p class="text-4xl font-bold mt-3"><%= @stats.total_books %></p>
        </div>
        <div class="bg-blue-600 p-8 rounded-lg shadow-lg hover:shadow-xl transition">
          <p class="text-sm uppercase tracking-wider">Authors</p>
          <p class="text-4xl font-bold mt-3"><%= @stats.total_authors %></p>
        </div>
        <div class="bg-green-600 p-8 rounded-lg shadow-lg hover:shadow-xl transition">
          <p class="text-sm uppercase tracking-wider">Added Today</p>
          <p class="text-4xl font-bold mt-3"><%= @stats.books_today %></p>
        </div>
      </div>

      <!-- Books Published Over Time Chart -->
      <div class="bg-white rounded-lg shadow-lg p-6">
        <h2 class="text-2xl mb-4 font-semibold text-gray-800">Books Published by Year</h2>
      </div>

      <!-- Featured Book -->
      <div class="flex flex-col md:flex-row bg-white rounded-lg shadow-2xl overflow-hidden">
        <img src={@featured_book.cover_url} alt="Featured Book" class="w-full md:w-48 object-cover"/>
        <div class="p-6 space-y-4">
          <h3 class="text-2xl font-semibold text-indigo-700"><%= @featured_book.title %></h3>
          <p class="italic text-gray-600">by <%= @featured_book.author %></p>
          <p class="text-gray-800"><%= @featured_book.summary %></p>
        </div>
      </div>

      <!-- Recent Books Table -->
      <div class="bg-white rounded-lg shadow-lg overflow-x-auto">
        <table class="min-w-full text-sm text-left text-gray-600">
          <thead class="bg-gray-100 uppercase text-xs text-gray-700">
            <tr>
              <th class="px-6 py-3">Title</th>
              <th class="px-6 py-3">Author</th>
              <th class="px-6 py-3">Pages</th>
              <th class="px-6 py-3">Published</th>
            </tr>
          </thead>
          <tbody>
            <%= for book <- @books do %>
              <tr class="hover:bg-gray-50 border-b">
                <td class="px-6 py-4 font-medium text-gray-900"><%= book.title %></td>
                <td class="px-6 py-4"><%= book.author %></td>
                <td class="px-6 py-4"><%= book.pages %></td>
                <td class="px-6 py-4"><%= book.published %></td>
              </tr>
            <% end %>
          </tbody>
        </table>
      </div>
    </div>
    """
  end
end
