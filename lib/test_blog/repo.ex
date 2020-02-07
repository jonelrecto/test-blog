defmodule TestBlog.Repo do
  use Ecto.Repo,
    otp_app: :test_blog,
    adapter: Ecto.Adapters.Postgres
end
