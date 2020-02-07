defmodule TestBlog.Repo.Migrations.CreateTableFollowedUsers do
  use Ecto.Migration

  def change do
    create table(:followed_users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, references(:users, type: :binary_id)
      add :followed, references(:users, type: :binary_id)

      timestamps()
    end


    create unique_index(:followed_users, [:user_id, :followed])
    create index(:followed_users, [:user_id])
    create index(:followed_users, [:followed])
  end
end
