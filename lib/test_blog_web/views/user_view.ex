defmodule TestBlogWeb.UserView do
  use TestBlogWeb, :view
  alias TestBlogWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{
      data: render_one(user, UserView, "user.json")
      }
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      last_name: user.last_name,
      first_name: user.first_name,
      email: user.email}
  end

  def render("sign_in.json", %{user: user}) do
    %{
      data: %{
        user: %{
          id: user.id,
          last_name: user.last_name,
          first_name: user.first_name,
          email: user.email
        }
      },
      message: "Sign in successful"
    }
  end

  def render("401.json", %{error_message: error_message}) do
    %{
      error: %{
        error_message: error_message
      }
    }
  end

  def render("email_verified.json", _params) do
    %{
      message: %{
        message: "Email Verified"
        }
    }
  end

  def render("sign_out.json", _params) do
    %{
      message: "Signed out"
    }
  end

  def render("user_follow.json", assigns) do
    %{
      message: assigns.message
    }
  end
end
