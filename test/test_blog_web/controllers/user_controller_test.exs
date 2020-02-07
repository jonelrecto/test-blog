defmodule TestBlogWeb.UserControllerTest do
  use TestBlogWeb.ConnCase

  alias TestBlog.Auth
  alias TestBlog.Auth.User
  alias Plug.Test

  @create_attrs %{
    email: "some email",
    first_name: "some first_name",
    last_name: "some last_name",
    password: "some password",
    is_verified: true,
    verification_token: "some verification token"
  }
  @update_attrs %{
    email: "some updated email",
    first_name: "some updated first_name",
    last_name: "some updated last_name",
    password: "some updated password",
    is_verified: true,
    verification_token: "some verification token"
  }
  @current_user_attrs %{
    email: "some current email",
    first_name: "some current first name",
    last_name: "some current last name",
    password: "some current password",
    is_verified: true,
    verification_token: "some verification token"
  }
  @invalid_attrs %{email: nil, first_name: nil, last_name: nil, password: nil}

  def fixture(:current_user) do
    {:ok, current_user} = Auth.create_user(@current_user_attrs)
    current_user
  end

  setup %{conn: conn} do
    # {:ok, conn: put_req_header(conn, "accept", "application/json")}
    # {:ok, conn: conn, current_user: current_user} = setup_current_user(conn)
    # {:ok, conn: put_req_header(conn, "accept", "application/json"), current_user: current_user}
    # {:ok, conn: put_req_header(conn, "Authorization", "Bearer" <> ), current_user: current_user}

    conn = conn
      |> put_req_header("accept", "applicaton/json")
      |> put_req_header("Bearer ", Phoenix.Token.sign("/posts", "user", 1))
    {:ok, conn: conn}
  end

  # describe "index" do
  #   test "lists all users", %{conn: conn, current_user: current_user} do
  #     conn = get(conn, Routes.user_path(conn, :index))
  #     # assert json_response(conn, 200)["data"] == []
  #
  #     assert json_response(conn, 200)["data"] == [
  #       %{
  #         "id" => current_user.id,
  #         "email" => current_user.email,
  #         "last_name" => current_user.last_name,
  #         "first_name" => current_user.first_name
  #       }
  #     ]
  #   end
  # end
  #
  # describe "create user" do
  #   test "renders user when data is valid", %{conn: conn} do
  #     conn = post(conn, Routes.user_path(conn, :create), user: @create_attrs)
  #     assert %{"id" => id} = json_response(conn, 201)["data"]
  #
  #     conn = get(conn, Routes.user_path(conn, :show, id))
  #
  #     assert %{
  #              "id" => id,
  #              "email" => "some email",
  #              "first_name" => "some first_name",
  #              "last_name" => "some last_name",
  #              # "password" => "some password"
  #            } = json_response(conn, 200)["data"]
  #   end
  #
  #   test "renders errors when data is invalid", %{conn: conn} do
  #     conn = post(conn, Routes.user_path(conn, :create), user: @invalid_attrs)
  #     assert json_response(conn, 422)["errors"] != %{}
  #   end
  # end
  #
  # describe "update user" do
  #   # setup [:create_user]
  #
  #   test "renders user when data is valid", %{conn: conn, current_user: %User{id: id} = current_user} do
  #     conn = put(conn, Routes.user_path(conn, :update, id), user: @update_attrs)
  #
  #     assert %{"id" => ^id} = json_response(conn, 200)["data"]
  #     conn = get(conn, Routes.user_path(conn, :show, id))
  #     assert %{
  #              "id" => id,
  #              "email" => "some updated email",
  #              "first_name" => "some updated first_name",
  #              "last_name" => "some updated last_name",
  #              # "password" => "some updated password"
  #            } = json_response(conn, 200)["data"]
  #   end
  #
  #   test "renders errors when data is invalid", %{conn: conn, current_user: current_user} do
  #     conn = put(conn, Routes.user_path(conn, :update, current_user), user: @invalid_attrs)
  #     assert json_response(conn, 422)["errors"] != %{}
  #   end
  # end
  #
  # describe "delete user" do
  #   # setup [:create_user]
  #
  #   test "deletes chosen user", %{conn: conn, current_user: current_user} do
  #     conn = delete(conn, Routes.user_path(conn, :delete, current_user))
  #     assert response(conn, 204)
  #
  #     assert_error_sent 404, fn ->
  #       get(conn, Routes.user_path(conn, :show, current_user))
  #     end
  #   end
  # end
  #
  # # defp create_user(_) do
  # #   user = fixture(:user)
  # #   {:ok, user: user}
  # # end
  #
  # defp setup_current_user(conn) do
  #   current_user = fixture(:current_user)
  #
  #   {:ok,
  #     conn: Test.init_test_session(conn, current_user_id: current_user.id),
  #     current_user: current_user
  #   }
  # end
  #
  # describe "sign_in user" do
  #   test "render user when user credentials are good", %{conn: conn, current_user: current_user} do
  #     conn = post(conn, Routes.user_path(conn, :sign_in, %{email: current_user.email, password: @current_user_attrs.password}))
  #
  #     assert json_response(conn, 200)["data"] == %{
  #       "user" => %{
  #         "id" => current_user.id,
  #         "email" => current_user.email,
  #         "first_name" => current_user.first_name,
  #         "last_name" => current_user.last_name
  #       }
  #     }
  #   end
  #
  #   test "render errors when user credentials are bad", %{conn: conn} do
  #     conn = post(conn, Routes.user_path(conn, :sign_in, %{email: "invalid email", password: ""}))
  #     assert json_response(conn, 401)["errors"] == %{"detail" => "Please fill up required fields"}
  #   end
  #
  # end
end
