defmodule TestBlogWeb.UserCommentView do
  use TestBlogWeb, :view
  alias TestBlogWeb.UserCommentView

  def render("index.json", %{comments: comments}) do
    %{data: render_many(comments, UserCommentView, "comments.json")}
  end

  def render("show.json", %{comment: comment}) do
    %{
      data: render_one(comment, UserCommentView, "user_comment.json")
    }
  end

  def render("user_comment.json", %{user_comment: user_comment}) do
    %{
      id: user_comment.id,
      content: user_comment.content,
      post_id: user_comment.post_id,
      user_id: user_comment.user_id
    }
  end

  def render("update.json", %{comment: user_comment}) do
    require IEx
    IEx.pry()
    %{
      data: %{
        id: user_comment.id,
        content: user_comment.content,
        post_id: user_comment.post_id,
        user_id: user_comment.user_id
      },
      message: "Comment updated"
    }
  end

end
