defmodule TestBlog.Documents.Upload do
  use Ecto.Schema
  import Ecto.Changeset

  # @upload_directory Application.get_env(:test_blog, :uploads_directory)

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "uploads" do
    field :content_type, :string
    field :filename, :string
    field :hash, :string
    field :size, :integer

    timestamps()
  end

  @doc false
  def changeset(upload, attrs) do
    upload
    |> cast(attrs, [:filename, :size, :content_type, :hash])
    |> validate_required([:filename, :size, :content_type, :hash])
    |> validate_number(:size, greater_than: 0)
    |> validate_length(:hash, is: 64)
  end

  def sha256(chunks_enum) do
    chunks_enum
    |> Enum.reduce(
      :crypto.hash_init(:sha256),
      &(:crypto.hash_update(&2, &1))
    )
    |> :crypto.hash_final
    |> Base.encode16
    |> String.downcase
  end

  def upload_directory() do
    Application.get_env(:test_blog, :uploads_directory)
  end

  def local_path(id, filename) do
    [Application.get_env(:test_blog, :uploads_directory), "#{id}-#{filename}"]
    |> Path.join
  end
end
