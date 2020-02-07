defmodule TestBlog.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :last_name, :string
      add :first_name, :string
      add :email, :string, null: false
      add :is_verified, :boolean, default: false
      add :verification_token, :string
      add :password_hash, :string

      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
