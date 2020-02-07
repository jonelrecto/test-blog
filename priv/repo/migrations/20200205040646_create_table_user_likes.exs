defmodule TestBlog.Repo.Migrations.CreateTableUserLikes do
  use Ecto.Migration

  def change do
    create table(:user_likes, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, references(:users, type: :binary_id)
      add :post_id, references(:user_posts, type: :binary_id)

      timestamps()
    end


    create unique_index(:user_likes, [:user_id, :post_id])
    create index(:user_likes, [:user_id])
    create index(:user_likes, [:post_id])
  end

end
