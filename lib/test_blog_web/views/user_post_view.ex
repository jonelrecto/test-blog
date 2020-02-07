defmodule TestBlogWeb.UserPostView do
  use TestBlogWeb, :view
  alias TestBlogWeb.UserPostView

  def render("index.json", %{user_posts: user_posts}) do
    require IEx
    IEx.pry()
    %{data: render_many(user_posts, UserPostView, "user_post.json")}
  end

  def render("show.json", %{user_post: user_post}) do
    %{data: render_one(user_post, UserPostView, "user_post.json")}
  end

  def render("user_post.json", %{user_post: user_post}) do
    %{id: user_post.id,
      title: user_post.title,
      body: user_post.body,
      likes: length(user_post.likes)}
  end

  def render("user_like.json", assigns) do
    %{
      message: assigns.message
    }
  end
end
