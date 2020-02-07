defmodule TestBlogWeb.UserPostControllerTest do
  use TestBlogWeb.ConnCase

  alias TestBlog.Posts
  alias TestBlog.Posts.UserPost
  alias TestBlog.Auth
  alias TestBlog.Auth.User
  alias Plug.Test

  @create_attrs %{
    body: "some body",
    # likes: 42,
    title: "some title"
  }
  @update_attrs %{
    body: "some updated body",
    likes: 43,
    title: "some updated title"
  }
  @current_user_attrs %{
    email: "some current email",
    first_name: "some current first name",
    last_name: "some current last name",
    password: "some current password"
  }
  @invalid_attrs %{body: nil, likes: nil, title: nil, user_id: nil}

  def fixture(:user_post) do
    {:ok, user_post} = Posts.create_user_post(@create_attrs)
    user_post
  end

  def user_fixture(:current_user) do
    {:ok, current_user} = Auth.create_user(@current_user_attrs)
    current_user
  end

  # setup %{conn: conn} do
  #   # {:ok, conn: put_req_header(conn, "accept", "application/json")}
  #
  #   {:ok, conn: conn, current_user: current_user} = setup_current_user(conn)
  #   {:ok, conn: put_req_header(conn, "accept", "application/json"), current_user: current_user}
  # end

  # describe "index" do
  #   test "lists all user_posts", %{conn: conn} do
  #     conn = get(conn, Routes.user_post_path(conn, :index))
  #     assert json_response(conn, 200)["data"] == []
  #   end
  # end
  #
  # describe "create user_post" do
  #   test "renders user_post when data is valid", %{conn: conn} do
  #     conn = post(conn, Routes.user_post_path(conn, :create), user_post: @create_attrs)
  #     assert %{"id" => id} = json_response(conn, 201)["data"]
  #
  #     conn = get(conn, Routes.user_post_path(conn, :show, id))
  #
  #     assert %{
  #              "id" => id,
  #              "body" => "some body",
  #              "likes" => nil,
  #              "title" => "some title"
  #            } = json_response(conn, 200)["data"]
  #   end
  #
  #   test "renders errors when data is invalid", %{conn: conn} do
  #     conn = post(conn, Routes.user_post_path(conn, :create), user_post: @invalid_attrs)
  #     assert json_response(conn, 422)["errors"] != %{}
  #   end
  # end

  # describe "update user_post" do
  #   setup [:create_user_post]
  #
  #   test "renders user_post when data is valid", %{conn: conn, user_post: %UserPost{id: id} = user_post} do
  #     conn = put(conn, Routes.user_post_path(conn, :update, user_post), user_post: @update_attrs)
  #     assert %{"id" => ^id} = json_response(conn, 200)["data"]
  #
  #     conn = get(conn, Routes.user_post_path(conn, :show, id))
  #
  #     assert %{
  #              "id" => id,
  #              "body" => "some updated body",
  #              "likes" => 43,
  #              "title" => "some updated title"
  #            } = json_response(conn, 200)["data"]
  #   end
  #
  #   test "renders errors when data is invalid", %{conn: conn, user_post: user_post} do
  #     conn = put(conn, Routes.user_post_path(conn, :update, user_post), user_post: @invalid_attrs)
  #     assert json_response(conn, 422)["errors"] != %{}
  #   end
  # end

  # describe "delete user_post" do
  #   setup [:create_user_post]
  #
  #   test "deletes chosen user_post", %{conn: conn, user_post: user_post} do
  #     conn = delete(conn, Routes.user_post_path(conn, :delete, user_post))
  #     assert response(conn, 204)
  #
  #     assert_error_sent 404, fn ->
  #       get(conn, Routes.user_post_path(conn, :show, user_post))
  #     end
  #   end
  # end

  # defp create_user_post(_) do
  #   user_post = fixture(:user_post)
  #   {:ok, user_post: user_post}
  # end
  #
  # defp setup_current_user(conn) do
  #   current_user = user_fixture(:current_user)
  #   require IEx
  #   IEx.pry()
  #   {:ok,
  #     conn: Test.init_test_session(conn, current_user_id: current_user.id),
  #     current_user: current_user
  #   }
  # end
end
