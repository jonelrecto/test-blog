defmodule TestBlogWeb.UserCommentController do
  use TestBlogWeb, :controller

  alias TestBlog.Comments
  alias TestBlog.Comments.Comment

  action_fallback TestBlogWeb.FallbackController

  def index(conn, _params) do
    comments = Comments.list_comments()
    render(conn, "index.json", comments: comments)
  end

  def create(conn, %{"post_id" => post_id} = params) do

    header = get_req_header(conn, "authorization")
    ["Bearer " <> token] = header

    %{"id" => user_id} = Comments.get_token_claim(token)

    with {:ok, %Comment{} = comment} <- Comments.create_comment(params, user_id, post_id) do
        conn
        |> put_status(:created)
        |> put_resp_header("location", Routes.user_path(conn, :show, comment))
        |> render("show.json", comment: comment)
    end

  end

  def show(conn, %{"id" => id}) do
    comment = Comments.get_comment(id)
    render(conn, "show.json", comment: comment)
  end

  def update(conn, %{"id" => id} = params) do
    comment = Comments.get_comment(id)
    with {:ok, %Comment{} = comment} <- Comments.update_comment(comment, params) do
      render(conn, "update.json", comment: comment)
    end
  end

  def delete(conn, %{"id" => id}) do
    comment = Comments.get_comment(id)
    case comment do
      nil ->
        conn
        |> put_status(:not_found)
        |> put_view(TestBlogWeb.ErrorView)
        |> render("404.json", message: "comment not found")
      %Comment{} ->
        with {:ok, %Comment{}} <- Comments.delete_comment(comment) do
          send_resp(conn, :no_content, "")
        end
    end


  end

end
