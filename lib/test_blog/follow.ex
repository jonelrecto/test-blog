defmodule TestBlog.Follow do
  @moduledoc """
  The Posts context.
  """

  import Ecto.Query, warn: false
  alias TestBlog.Repo

  alias TestBlog.FollowedUsers.Followed

  def follow_user(user_id, followed_user_id) do
    %Followed{user_id: user_id, followed_user: followed_user_id}
    |>Followed.changeset
    |> Repo.insert
  end


end
