defmodule TestBlog.Repo.Migrations.CreateUploadsTable do
  use Ecto.Migration

  def change do
    create table(:uploads, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :filename, :string
      add :size, :bigint
      add :content_type, :string
      add :hash, :string, size: 64

      timestamps()
    end

    create index(:uploads, [:hash])
  end
end
