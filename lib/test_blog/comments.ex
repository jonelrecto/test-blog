defmodule TestBlog.Comments do
  @moduledoc """
  The Comments context.
  """

  import Ecto.Query, warn: false
  alias TestBlog.Repo

  alias TestBlog.Comments.Comment
  alias TestBlog.Posts.Post
  alias TestBlog.Token

  @doc """
  Returns the list of comments.

  ## Examples

      iex> list_comments()
      [%Comment{}, ...]

  """

  def get_token_claim(token) do
    case Token.verify_and_validate(token) do
      {:ok, claims} ->
        claims
      {:error, message} ->
        {:error, message}
    end
  end

  def count_comments do
    query = from(p in Post, group_by: p.id, left_join: c in assoc(p, :comments), select: {p, count(c.id)})
    {%Post{}, length} = Repo.one(query)
    length
  end

  def list_comments do
    Repo.all(Comment)
  end

  @doc """
  Gets a single comment.

  Raises `Ecto.NoResultsError` if the Comment does not exist.

  ## Examples

      iex> get_comment!(123)
      %Comment{}

      iex> get_comment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_comment(id), do: Repo.get(Comment, id)

  @doc """
  Creates a comment.

  ## Examples

      iex> create_comment(%{field: value})
      {:ok, %Comment{}}

      iex> create_comment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_comment(attrs \\ %{}, user_id, post_id) do
    %Comment{user_id: user_id, post_id: post_id}
      |> Comment.changeset(attrs)
      |> Repo.insert()
  end

  @doc """
  Updates a comment.

  ## Examples

      iex> update_comment(comment, %{field: new_value})
      {:ok, %Comment{}}

      iex> update_comment(comment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_comment(%Comment{} = comment, attrs) do
    require IEx
    IEx.pry()
    comment
    |> Comment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a comment.

  ## Examples

      iex> delete_comment(comment)
      {:ok, %Comment{}}

      iex> delete_comment(comment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_comment(%Comment{} = comment) do
    Repo.delete(comment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking comment changes.

  ## Examples

      iex> change_comment(comment)
      %Ecto.Changeset{source: %Comment{}}

  """
  def change_comment(%Comment{} = comment) do
    Comment.changeset(comment, %{})
  end
end
