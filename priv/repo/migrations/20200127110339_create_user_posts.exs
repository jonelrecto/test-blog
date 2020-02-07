defmodule TestBlog.Repo.Migrations.CreateUserPosts do
  use Ecto.Migration

  def change do
    create table(:user_posts, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :body, :string
      add :likes, :integer
      add :user_id, references(:users, type: :binary_id)

      timestamps()
    end

    create unique_index(:user_posts, [:title])
    create index(:user_posts, [:user_id])
  end

end
