defmodule TestBlog.Auth.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :email, :string, null: false
    field :first_name, :string
    field :last_name, :string
    field :is_verified, :boolean, default: false
    field :verification_token, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    has_many :posts, TestBlog.Posts.Post
    has_many :comments, TestBlog.Comments.Comment
    has_many :followed, TestBlog.FollowedUsers.Followed

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:last_name, :first_name, :email, :password, :is_verified, :verification_token])
    |> validate_required([:last_name, :first_name, :email, :password])
    |> unique_constraint(:email)
    |> put_password_hash
  end

  def updateset(user, attrs) do
    user
    |> cast(attrs, [:last_name, :first_name, :email, :password, :is_verified, :verification_token])
  end

  defp put_password_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Bcrypt.add_hash(password))
  end

  defp put_password_hash(changeset) do
    changeset
  end
end
