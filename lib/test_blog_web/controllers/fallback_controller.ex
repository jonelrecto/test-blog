defmodule TestBlogWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use TestBlogWeb, :controller

  def call(conn, {:error, [message, claim, claim_val]}) do
    require IEx
    IEx.pry()
    conn
    |> put_status(:not_found)
    |> put_view(TestBlogWeb.ErrorView)
    |> render(:"404")
  end

  def call(conn, {:error, %Ecto.Changeset{errors: [errors]}}) do
    require IEx
    IEx.pry()
    {key, {message, _options}} =  errors

    message = %{"field" => Atom.to_string(key), "message" => message}

    conn
      |> put_status(:unprocessable_entity)
      |> put_view(TestBlogWeb.ErrorView)
      |> render("error.json", error: message)
    # |> render(:"422")
  end
end
