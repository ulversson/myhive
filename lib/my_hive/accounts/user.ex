defmodule MyHive.Accounts.User do
  use GuardianTrackable.Schema
  use Ecto.Schema

  import Ecto.Changeset

  alias MyHive.{
    Saas,
    Repo,
    Accounts,
    CVFields,
    Chat,
    Organizer
  }
  alias MyHive.Regex.RegularExpressions
  alias MyHive.Accounts.{
    Encryption,
    Settings,
    QuickLink,
    UsernameSlug
  }
  alias MyHive.Avatarly.UserAvatars
  alias MyHive.Saas
  alias MyHive.FileManager.{
    SharedFolder,
    Folder
  }
  alias MyHive.Notifications.Notification
  alias MyHive.Chat.ConversationMember
  alias MyHive.CaseManagement.{
    MedicoLegalCase,
    UserMedicoLegalCase
  }
  alias MyHive.Encryption.EncryptedField
  alias MyHive.TimeSheet.TimeEntry
  @valid_roles ["Admin": "admin", "Super admin": "super_admin", "Expert": "expert", "Archiver": "archiver"]
  @derive {
    Jason.Encoder,
    only: [:first_name, :last_name, :unread,
      :email, :avatar_32]
  }
  schema "users" do
    field :email, :string
    field :encrypted_password, :string
    field :first_name, :string
    field :is_active, :boolean, default: false
    field :last_name, :string
    field :has_2fa, :boolean, default: true
    field :verified, :boolean, default: false
    field :force_sign_out, :boolean, default: false
    field :phone_number, EncryptedField
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :avatar_32, :string
    field :avatar_128, :string
    field :avatar_256, :string
    field :slug, UsernameSlug.Type
    field :roles, {:array, :string}, default: ["expert"]
    field :last_message, :any, virtual: true
    many_to_many :saas_accounts, Saas.Account, join_through: Saas.AccountUser
    many_to_many :medico_legal_cases, MedicoLegalCase, join_through: UserMedicoLegalCase
    has_many :user_medico_legal_cases, UserMedicoLegalCase
    has_many :conversation_members, ConversationMember
    has_many :conversations, through: [:conversation_members, :conversation]
    has_many :received_notifications, Notification, foreign_key: :recipient_id
    has_many :folders, Folder
    has_many :send_notifications, Notification, foreign_key: :sender_id
    has_many :shared_folders, SharedFolder
    has_many :being_shared_folders, SharedFolder, foreign_key: :shared_user_id
    has_many :shared_folders_by_others, through: [:being_shared_folders, :folder]
    has_many :quick_links, QuickLink
    has_many :time_entries, TimeEntry, foreign_key: :owner_id
    embeds_one :settings, Settings, on_replace: :delete
    guardian_trackable()
    timestamps()
  end

  def valid_roles do
    @valid_roles
  end

  def name_for(user) do
    "#{user.first_name} #{user.last_name}"
  end

  @doc false
  def initial_changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :first_name, :last_message, :last_name, :phone_number, :password, :verified, :roles, :force_sign_out, :is_active])
    |> cast_embed(:settings)
    |> validate_required([:email, :first_name, :last_name, :phone_number, :is_active], message: "cannot be blank")
    |> validate_length(:first_name, min: 3)
    |> validate_format(:email, RegularExpressions.email_regex, message: "must be a valid email address")
    |> validate_length(:last_name, min: 3)
    |> unique_constraint(:email)
    |> downcase_email
    |> generate_avatar(32)
    |> generate_avatar(128)
    |> generate_avatar(256)
    |> UsernameSlug.maybe_generate_slug
    |> UsernameSlug.unique_constraint
  end

  def chat_avatar(user) do
    if user.avatar_32 == nil do
      ""
    else
      user.avatar_32
      |> String.replace(~r/32/,"50")
      |> String.replace("r=\"16.0\"", "r=\"26.0\"")
      |> String.replace(~r/16\.0/, "24.0")
      |> String.replace(~r/13.333333333333334px/,"19px")
      |> String.replace(~r/67%/, "62%")
    end
  end

  def is_archiver?(user) do
    Enum.member?(user.roles, "archiver")
  end

  def cleanup(user) do
    Repo.transaction fn ->
      ids = Accounts.get_accounts_ids(user)
      Chat.delete_conversation_members_for(user.id)
      Saas.delete_user_from_account(user.id, ids)
      Organizer.remove_calendar_for(user)
      CVFields.remove_fields_for_user(user)
      Accounts.delete_user(user)
    end
  end

  def changeset(user, attrs) do
    user
    |> initial_changeset(attrs)
    |> validate_required([:password])
    |> validate_length(:password, min: 6)
    |> validate_confirmation(:password)
    |> encrypt_password
  end

  defp encrypt_password(changeset) do
    password = get_change(changeset, :password)
    if password do
      encrypted_password = Encryption.hash_password(password)
      put_change(changeset, :encrypted_password, encrypted_password)
    else
      changeset
    end
  end

  defp downcase_email(changeset) do
    update_change(changeset, :email, &String.downcase/1)
  end

  defp generate_avatar(changeset, size) do
    UserAvatars.call(size, changeset)
  end

end
