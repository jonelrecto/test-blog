defmodule TestBlog.Auth do
  @moduledoc """
  The Auth context.
  """

  import Ecto.Query, warn: false

  alias TestBlog.Repo
  alias TestBlog.Auth.User
  alias TestBlog.Token

  def get_token_claim(token) do
    case Token.verify_and_validate(token) do
      {:ok, claims} ->
        claims
      {:error, message} ->
        {:error, message}
    end
  end

  def verify_email(id) do
    query = from(u in User, where: u.id == ^id and u.is_verified == true)
    case Repo.one(query) do
      nil ->
        {:ok }
      _user ->
        {:error, "email already verified"}
    end
  end

  def verify_email(id, token) do
    query = from(u in User, where: u.id == ^id and u.verification_token == ^token)
    case Repo.one(query) do
      nil ->
        {:error, "invalid verification"}
      user ->
        {:ok, user}
    end
  end

  def authenticate_user(email, password) do
    query = from(u in User, where: u.email == ^email)
    query
      |> Repo.one()
      |> verify_password(password)
      |> email_verified?
  end

  defp email_verified?(user) do
    case user do
      {:ok, user} ->
        if user.is_verified do
          {:ok, user}
        else
          {:error, "email not verified"}
        end
      {:error, message} ->
        {:error, message}
    end
  end

  defp verify_password(nil, _) do
    Bcrypt.no_user_verify()
    {:error, "wrong email or password"}
  end

  defp verify_password(user, password) do
    if Bcrypt.verify_pass(password, user.password_hash) do
      {:ok, user}
    else

      {:error, "wrong email or password"}
    end
  end

  def update_verification(%User{} = user) do
    user
    |> User.updateset(%{"is_verified" => true})
    |> Repo.update()
  end

  def update_token(token, %User{} = user) do
    user
      |> User.updateset(%{"verification_token" => token})
      |> Repo.update()
  end

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user(id), do: Repo.get(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end
end
