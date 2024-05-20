defmodule UniqueObanIssue.Repo do
  use Ecto.Repo,
    otp_app: :unique_oban_issue,
    adapter: Ecto.Adapters.Postgres
end
