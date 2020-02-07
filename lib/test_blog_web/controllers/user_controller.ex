defmodule TestBlogWeb.UserController do
  use TestBlogWeb, :controller

  alias TestBlog.Auth
  alias TestBlog.Follow
  alias TestBlog.Auth.User
  alias TestBlog.{EmailSender, Mailer}
  alias TestBlog.Token

  action_fallback TestBlogWeb.FallbackController

  def index(conn, _params) do
    users = Auth.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, user_params) do
    token = generate_token(user_params)
    user_params = Map.put_new(user_params, "verification_token", token)

    with {:ok, %User{} = user} <- Auth.create_user(user_params) do
      send_verification_email(user)
        conn
        |> put_status(:created)
        |> put_resp_header("location", Routes.user_path(conn, :show, user))
        |> render("show.json", user: user)
    end

  end

  def sign_in(conn, %{"email" => email, "password" => password}) do
    case Auth.authenticate_user(email, password) do
      {:ok, user} ->
        token = user
          |> Map.take([:id, :first_name, :last_name, :email, :is_verified])
          |> Token.generate_and_sign!()

        Auth.update_token(token, user)

        conn
          |> put_req_header("authorization", "bearer: " <> token)
          |> put_status(:ok)
          |> put_view(TestBlogWeb.UserView)
          |> render("sign_in.json", user: user)
      {:error, message} ->
        conn
        |> delete_session(:current_user_id)
        |> put_status(:unauthorized)
        |> put_view(TestBlogWeb.ErrorView)
        |> render("401.json", message: message)
    end
  end

  def sign_out(conn, _params) do
    header = get_req_header(conn, "authorization")
    ["Bearer " <> token] = header
    case Token.verify_and_validate(token) do
        {:ok, %{"id" => id}} ->
          user = Auth.get_user(id)
          with {:ok, _user} <- Auth.update_token(nil, user) do
            conn
              |> put_status(:ok)
              |> put_view(TestBlogWeb.UserView)
              |> render("sign_out.json")
          end
        {:error, [{:message, details}, _claim, _claim_val]} ->
          conn
          |> put_status(:reset_content)
          |> put_view(TestBlogWeb.ErrorView)
          |> render("401.json", message: details)
    end
  end

  defp send_verification_email(user) do
    EmailSender.verification_email(user)
      |> Mailer.deliver_later()
  end

  defp generate_token(user) do
    user
      |> Map.delete("password")
      |> Token.generate_and_sign!
  end

  def show(conn, %{"id" => id}) do
    user = Auth.get_user(id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Auth.get_user(id)
    with {:ok, %User{} = user} <- Auth.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Auth.get_user(id)

    with {:ok, %User{}} <- Auth.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end

  def verify_email?(conn, %{"id" => id, "token" => token}) do
    case Auth.verify_email(id) do
      {:error, message} ->
        conn
        |> put_view(TestBlogWeb.ErrorView)
        |> render("401.json", message: message)
      {:ok } ->
        conn
          |> verify_email(id, token)
    end
  end

  def verify_email(conn, id, token) do
    # user = Auth.verify_email(id, token)
    case Auth.verify_email(id, token) do
      nil ->
        conn
          |> put_view(TestBlogWeb.ErrorView)
          |> render("401.json", message: "invalid verification")
      {:error, message} ->
        conn
          |> put_view(TestBlogWeb.ErrorView)
          |> render("401.json", message: message)
      {:ok, user} ->
        Auth.update_verification(user)

        conn
          |> put_status(:ok)
          |> put_view(TestBlogWeb.UserView)
          |> render("email_verified.json")
    end


  end

  def follow_user(conn, %{"user_id" => followed_user_id}) do
    header = get_req_header(conn, "authorization")
    ["Bearer " <> token] = header
    %{"id" => user_id} = Auth.get_token_claim(token)

    with {:ok, user} <- Follow.follow_user(user_id, followed_user_id) do
      require IEx
      IEx.pry()
      conn
      |> put_status(:created)
      |> render("user_follow.json", message: "user followed")
    end

  end
end
