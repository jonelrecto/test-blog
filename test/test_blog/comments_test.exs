defmodule TestBlog.CommentsTest do
  use TestBlog.DataCase

  alias TestBlog.Comments
  alias TestBlog.Auth
  alias TestBlog.Posts

  describe "comments" do
    alias TestBlog.Comments.Comment
    alias TestBlog.Posts.Post
    alias TestBlog.Auth.User

    @valid_attrs %{content: "some content"}
    @update_attrs %{content: "some updated content"}
    @invalid_attrs %{content: nil}
    @current_user_attrs %{user_id: "some user id"}
    @current_post_attrs %{post_id: "some post id"}
    @valid_user_attrs %{email: "some email2", first_name: "some first_name", last_name: "some last_name", password: "some password", is_verified: true, verification_token: "some verification token"}
    @valid_post_attrs %{body: "some body2", title: "some title", likes: 42}

    def comment_fixture(attrs \\ %{}, user_id, post_id) do
      {:ok, comment} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Comments.create_comment(user_id, post_id)

      comment
    end

      # def create_post() do
      #
      # end

    def create_post() do
      user = create_user()
      case Posts.create_post(@valid_post_attrs, user.id) do
        {:ok, %Post{} = post} ->
          post

        {:error, _} ->

          "an error occur in post"
      end

    end

    def create_user() do

      case Auth.create_user(@valid_user_attrs) do
          {:ok, %User{} = user} ->
            user
          {:error, _} ->
            "an error occur in user"
      end

    end

    test "get_comment!/1 returns the comment with given id" do
      post = create_post()
      comment = comment_fixture(@current_user_attrs, post.id)
      assert Comments.get_comment!(comment.id) == comment
    end

    test "create_comment/1 with valid data creates a comment" do
      post = create_post()
      assert {:ok, %Comment{} = comment} = Comments.create_comment(@valid_attrs, @current_user_attrs, post.id)
      assert comment.content == "some content"
    end

    test "create_comment/1 with invalid data returns error changeset" do
      user = create_user()
      post = create_post()
      require IEx
      IEx.pry()
      assert {:error, %Ecto.Changeset{}} = Comments.create_comment(@invalid_attrs, user.id, post.id)
    end

    test "update_comment/2 with valid data updates the comment" do
      user = create_user()
      post = create_post()
      comment = comment_fixture(user.id, post.id)
      assert {:ok, %Comment{} = comment} = Comments.update_comment(comment, @update_attrs)
      assert comment.content == "some updated content"
    end

    test "update_comment/2 with invalid data returns error changeset" do
      post = create_post()
      comment = comment_fixture(@current_user_attrs, post.id)


      assert {:error, %Ecto.Changeset{}} = Comments.update_comment(comment, @invalid_attrs)
      assert comment == Comments.get_comment!(comment.id)
    end

    test "delete_comment/1 deletes the comment" do
      user = create_user()
      post = create_post()
      comment = comment_fixture(user.id, post.id)
      assert {:ok, %Comment{}} = Comments.delete_comment(comment)
      assert_raise Ecto.NoResultsError, fn -> Comments.get_comment!(comment.id) end
    end

    test "change_comment/1 returns a comment changeset" do
      post = create_post()
      comment = comment_fixture(@current_user_attrs, post.id)

      assert %Ecto.Changeset{} = Comments.change_comment(comment)
    end
  end
end
