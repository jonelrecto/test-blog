defmodule TestBlog.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "user_posts" do
    field :body, :string
    field :title, :string
    has_many :likes, TestBlog.UserLikes.UserLike
    belongs_to :user, TestBlog.Auth.User

    has_many :comments, TestBlog.Comments.Comment

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :body])
    |> validate_required([:title, :body])
    |> unique_constraint(:title)
    |> change
    |> put_assoc(:likes, [])
  end
end
