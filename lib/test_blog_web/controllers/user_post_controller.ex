defmodule TestBlogWeb.UserPostController do
  use TestBlogWeb, :controller

  alias TestBlog.Posts
  alias TestBlog.Posts.Post
  alias TestBlog.Auth
  # alias TestBlog.Repo

  action_fallback TestBlogWeb.FallbackController

  def index(conn, _params) do
    header = get_req_header(conn, "authorization")
    ["Bearer " <> token] = header
    case Auth.get_token_claim(token) do
     %{"id" => id} ->
         user_posts = Posts.get_post_with_followed_user(id)
         render(conn, "index.json", user_posts: user_posts)
     {:error, [{:message, details}, _claim, _claim_val]} ->

       conn
       |> put_status(:unauthorized)
       |> put_view(TestBlogWeb.ErrorView)
       |> render("401.json", message: details)
       |> halt()
    end

  end
# %{"params" => user_post_params}
  def create(conn, params) do
    header = get_req_header(conn, "authorization")
    ["Bearer " <> token] = header

    case Auth.get_token_claim(token) do
      %{"id" => id} ->
        with {:ok, %Post{} = user_post} <- Posts.create_post(params, id) do
          conn
          |> put_status(:created)
          |> put_resp_header("location", Routes.user_post_path(conn, :show, user_post))
          |> render("show.json", user_post: user_post)
        end
      {:error, [{:message, details}, _claim, _claim_val]} ->
        conn
        |> put_status(:unauthorized)
        |> put_view(TestBlogWeb.ErrorView)
        |> render("401.json", message: details)
        |> halt()
    end


  end

  def show(conn, %{"id" => id}) do
    user_post = Posts.get_post!(id)
    render(conn, "show.json", user_post: user_post)
  end

  def update(conn, %{"id" => id} = params) do

    user_post = Posts.get_post!(id)
    # Posts.update_post(user_post, params)

    with {:ok, %Post{} = user_post} <- Posts.update_post(user_post, params) do
      render(conn, "show.json", user_post: user_post)
    end
  end

  def delete(conn, %{"id" => id}) do

    user_post = Posts.get_post!(id)
    with {:ok, %Post{}} <- Posts.delete_post(user_post) do
      send_resp(conn, :no_content, "")
    end
  end

  def like_post(conn, %{"post_id" => id}) do
    header = get_req_header(conn, "authorization")
    ["Bearer " <> token] = header

    %{"id" => user_id} = Auth.get_token_claim(token)

    user_post = Posts.get_post!(id)
    with {:ok, %Post{}} <- Posts.like_post(user_post, user_id) do
      conn
      |> put_status(:created)
      |> render(conn, "user_like.json", message: "post liked")
    end
  end

  def upload_file(conn, %{"name" => name}= params) do


    if %{"photo" => upload} = params do
      extension = Path.extname(upload.filename)
      File.cp(upload.path, "/media/#{name}-profile#{extension}")
      require IEx
      IEx.pry()
    end
    require IEx
    IEx.pry()
  end


end
