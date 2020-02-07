defmodule TestBlog.FollowedUsers.Followed do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "followed_users" do
    belongs_to :user, TestBlog.Auth.User, foreign_key: :user_id
    belongs_to :followed, TestBlog.Auth.User, foreign_key: :followed_user

    timestamps()
  end

  @doc false
  def changeset(followed) do
    followed
    |> change(%{})
    |> unique_constraint(:user_id, name: :followed_users_user_id_followed_index)
    |> unique_constraint(:followed, name: :followed_users_user_id_followed_index)
  end
end
