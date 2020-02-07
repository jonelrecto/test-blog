defmodule TestBlogWeb.UploadController do
  use TestBlogWeb, :controller

  alias TestBlog.Documents
  alias TestBlog.Documents.Upload

  action_fallback TestBlogWeb.FallbackController


  def new(conn, _params) do
    render(conn, "new.json")
  end

  def create(conn, %{"upload" => %Plug.Upload{}} = upload) do
    require IEx
    IEx.pry()
    %{"upload" => file_upload} = upload
    # require IEx
    # IEx.pry()

    case Documents.create_upload_from_plug_upload(file_upload) do
        {:ok, _upload} ->
          require IEx
          IEx.pry()
          conn
          |> put_status(:created)
          |> render(:info, message: "file uploaded succesfully")
        {:error, reason} ->
          require IEx
          IEx.pry()
          conn
          |> delete_session(:current_user_id)
          |> put_status(:bad_request)
          |> put_view(TestBlogWeb.ErrorView)
          |> render("401.json", message: reason)
    end
  end

  def index(conn, _params) do
    require IEx
    IEx.pry()
    uploads = Documents.list_upload()
    render(conn, "index.json", uploads: uploads)
  end

  def show(conn, %{"id" => id}) do
    upload = Documents.get_upload(id)
    local_path = Upload.local_path(upload.id, upload.filename)
    send_download(conn, {:file, local_path}, filename: upload.filename)
  end
end
