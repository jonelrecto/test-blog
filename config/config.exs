# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :test_blog,
  ecto_repos: [TestBlog.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :test_blog, TestBlogWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "+IQ9sNyG36YgTwPyEZ1opnqIeQHZJZtZYAvVsr9UWUf5sJt9DvPxLtJIlBqb6Q1S",
  render_errors: [view: TestBlogWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: TestBlog.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

config :bcrypt_elixir, :log_rounds, 4

config :test_blog, TestBlog.Mailer,
  adapter: Bamboo.MailjetAdapter,
  api_key: "74abd8db9762d4e7c73dafbdb14afaaa",
  api_private_key: "f11a5fa39736ef478bd7e6005f8c246d"
