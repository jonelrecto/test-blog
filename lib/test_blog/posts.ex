defmodule TestBlog.Posts do
  @moduledoc """
  The Posts context.
  """

  import Ecto.Query, warn: false
  alias TestBlog.Repo

  alias TestBlog.Posts.Post
  alias TestBlog.UserLikes.UserLike
  alias TestBlog.FollowedUsers.Followed

  @doc """
  Returns the list of user_posts.

  ## Examples

      iex> list_user_posts()
      [%Post{}, ...]

  """
  def list_user_posts(user_id) do
    query = from(u in Post, where: u.user_id == ^user_id)

    query
    |> Repo.all()
    |> Repo.preload(likes: :user)
  end

  def get_post_with_followed_user(user_id) do

    query_sub = from(f in Followed, where: f.user_id == ^user_id)
    query = from(p in Post, join: f in subquery(query_sub), on: p.user_id == ^user_id or p.user_id == f.followed_user)

    query
    |> Repo.all()
    |> Repo.preload(likes: :user)
  end

  @doc """
  Gets a single post.

  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> get_post!(123)
      %Post{}

      iex> get_post!(456)
      ** (Ecto.NoResultsError)

  """
  def get_post!(id), do: Repo.get!(Post, id)

  @doc """
  Creates a post.

  ## Examples

      iex> create_post(%{field: value})
      {:ok, %Post{}}

      iex> create_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post(attrs \\ %{}, id) do
    %Post{user_id: id}
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a post.

  ## Examples

      iex> update_post(post, %{field: new_valu
      {:ok, %Post{}}

      iex> update_post(post, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_post(%Post{} = post, attrs) do
    post
      |> Post.changeset(attrs)
      |> Repo.update()
  end

  @doc """
  Deletes a post.

  ## Examples

      iex> delete_post(post)
      {:ok, %Post{}}

      iex> delete_post(post)
      {:error, %Ecto.Changeset{}}

  """
  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post changes.

  ## Examples

      iex> change_post(post)
      %Ecto.Changeset{source: %Post{}}

  """
  def change_post(%Post{} = post) do
    Post.changeset(post, %{})
  end

  def like_post(%Post{} = post, user_id) do
    %UserLike{post_id: post.id, user_id: user_id}
      |> UserLike.changeset()
      |> Repo.insert
  end
end
