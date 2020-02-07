defmodule TestBlog.PostsTest do
  use TestBlog.DataCase

  alias TestBlog.Posts
  alias TestBlog.Auth

  describe "user_posts" do
    alias TestBlog.Posts.Post
    alias TestBlog.Auth.User

    @valid_attrs %{body: "some body", title: "some title", likes: 42}
    @update_attrs %{body: "some updated body", title: "some updated title", likes: 42, user_id: "some user id"}
    @invalid_attrs %{body: nil, title: nil}
    @current_user_attrs %{user_id: "some user id"}
    @valid_user_attrs %{email: "some email", first_name: "some first_name", last_name: "some last_name", password: "some password", is_verified: true, verification_token: "some verification token"}

    def post_fixture(attrs \\ %{}, user_id) do
      {:ok, post} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Posts.create_post(user_id)
      post
    end

    def create_user() do
        {:ok, %User{} = user} =
          Auth.create_user(@valid_user_attrs)
        user
    end

    test "list_user_posts/0 returns all user_posts" do
      user = create_user()
      post = post_fixture(@valid_attrs, user.id)

      assert Posts.list_user_posts(user.id) == [post]
    end

    test "get_post!/1 returns the post with given id" do
      user = create_user()
      post = post_fixture(@valid_attrs, user.id)
      assert Posts.list_user_posts(user.id) == [post]
    end

    test "create_post/1 with valid data creates a post" do
      user = create_user()
      assert {:ok, %Post{} = post} = Posts.create_post(@valid_attrs, user.id)
      assert post.body == "some body"
      assert post.title == "some title"
    end

    test "create_post/1 with invalid data returns error changeset" do
      user = create_user()
      assert {:error, %Ecto.Changeset{}} = Posts.create_post(@invalid_attrs, user.id)
    end

    test "update_post/2 with valid data updates the post" do
      user = create_user()
      post = post_fixture(@valid_attrs, user.id)
      assert {:ok, %Post{} = post} = Posts.update_post(post, @update_attrs)
      assert post.body == "some updated body"
      assert post.title == "some updated title"
    end

    test "update_post/2 with invalid data returns error changeset" do
      user = create_user()
      post = post_fixture(@valid_attrs, user.id)
      assert {:error, %Ecto.Changeset{}} = Posts.update_post(post, @invalid_attrs)
    end

    test "delete_post/1 deletes the post" do
      user = create_user()
      post = post_fixture(@valid_attrs, user.id)
      assert {:ok, %Post{}} = Posts.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Posts.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      user = create_user()
      post = post_fixture(@valid_attrs, user.id)
      assert %Ecto.Changeset{} = Posts.change_post(post)
    end
  end
end
