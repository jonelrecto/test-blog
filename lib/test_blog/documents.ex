defmodule TestBlog.Documents do
  import Ecto.Query, warn: false

  alias TestBlog.Repo
  alias TestBlog.Documents.Upload



  def create_upload_from_plug_upload(%Plug.Upload{
    filename: filename,
    path: tmp_path,
    content_type: content_type
    }) do

    hash =
      File.stream!(tmp_path, [], 2048)
      |> Upload.sha256()


    with {:ok, %File.Stat{size: size}} <- File.stat(tmp_path),
      {:ok, upload} <-
        %Upload{}
        |> Upload.changeset(%{filename: filename, content_type: content_type, hash: hash, size: size})
        |> Repo.insert do

        case File.cp(tmp_path, Upload.local_path(upload.id, filename)) do
          :ok ->
            {:ok, upload}
          {:error, reason} ->
            {:error, reason}
        end

    end
  end

  def list_upload() do
    Repo.all(Upload)
  end

  def get_upload(id) do
    Upload
    |> Repo.get(id)
  end
end
