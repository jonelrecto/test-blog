defmodule TestBlogWeb.UploadView do
  use TestBlogWeb, :view

  alias TestBlogWeb.UploadView

  def render("new.json", assigns) do
    require IEx
    IEx.pry()
  end

  def render("info.json", assigns) do
    %{
      message: assigns.message
    }
  end

  def render("index.json", %{uploads: uploads}) do
    require IEx
    IEx.pry()
    %{
      data: render_many(uploads, UploadView, "upload.json")
    }
  end

  def render("upload.json", %{upload: upload}) do

    %{
      id: upload.id,
      filename: upload.filename,
      size: upload.size,
      content_type: upload.content_type
    }
  end
end
