defmodule TestBlogWeb.Router do
  use TestBlogWeb, :router

  # alias TestBlog.Token

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
  end

  pipeline :api_auth do
    plug :ensure_authenticated
  end

  scope "/api", TestBlogWeb do
    pipe_through :api

    post "/users/sign_in", UserController, :sign_in
    post "/users/sign_up", UserController, :create
    # patch "/users/:id", UserController, :update
    get "/users/sign_out", UserController, :sign_out

    get "/verify/:id/:token", UserController, :verify_email?

    # get "/posts", UserPostController, :index

  end


  scope "/api", TestBlogWeb do
    pipe_through [:api, :api_auth]
    resources "/users", UserController, excepts: [:sign_in, :create]
    post "/users/follow_user/:user_id", UserController, :follow_user

    resources "/posts", UserPostController, excepts: :index
    post "/posts/like_post/:post_id", UserPostController, :like_post


    resources "/post/:post_id/comments", UserCommentController, excepts: [:index, :create]
    # post "/post/:post_id/comments", UserCommentController, :create

    resources "/upload", UploadController, only: [:index, :new, :create, :show]

    # post "/posts", UserPostController, :create
  end


  # plug function
  defp ensure_authenticated(conn, _opts) do

    # DateTime.from_unix(1580718695) convert numeric time to date

    header = get_req_header(conn, "authorization")

    if length(header) > 0 do
      ["Bearer " <> token] = header
      case TestBlog.Token.verify_and_validate(token) do
        {:ok, claims} ->
          %{"exp" => exp} = claims
          if DateTime.from_unix(exp) < DateTime.utc_now do
            conn
          else
            conn
            |> put_status(:unauthorized)
            |> put_view(TestBlogWeb.ErrorView)
            |> render("401.json", message: "Token Expired")
            |> halt()
          end
        {:error, _message} ->
          conn
          |> put_status(:unauthorized)
          |> put_view(TestBlogWeb.ErrorView)
          |> render("401.json", message: "Unauthorized user")
          |> halt()
      end
    else
      conn
      |> put_status(:unauthorized)
      |> put_view(TestBlogWeb.ErrorView)
      |> render("401.json", message: "Invalid Token")
      |> halt()
    end

  end

end
