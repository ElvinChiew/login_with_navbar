defmodule Bb.Repo do
  use Ecto.Repo,
    otp_app: :bb,
    adapter: Ecto.Adapters.Postgres
end
