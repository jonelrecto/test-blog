defmodule TestBlog.UserLikes.UserLike do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "user_likes" do
    belongs_to :user,  TestBlog.Auth.User
    belongs_to :post,  TestBlog.Posts.Post

    timestamps()
  end

  @doc false
  def changeset(user_like) do

    user_like
    |> change(%{})
    |> unique_constraint(:user_id, name: :user_likes_user_id_post_id_index)
    |> unique_constraint(:post_id, name: :user_likes_user_id_post_id_index)
  end
end
