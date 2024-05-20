defmodule UniqueObanIssue.Worker do
  use Oban.Worker

  alias UniqueObanIssue.Repo

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"name" => name}}) do
    IO.puts("Hello #{name}")
    :ok
  end

  def insert_many_unique(name \\ "Bernardo") do
    1..5
    |> Task.async_stream(
      fn num ->
        if num == 5 do
          Process.sleep(500)
        end

        Repo.transaction(fn ->
          result = insert_unique(name)
          Process.sleep(2000)

          if num != 5 do
            Repo.rollback(result)
          else
            result
          end
        end)
      end,
      max_concurrency: 5
    )
    |> Enum.to_list()
  end

  def insert_unique(name \\ "Bernardo") do
    UniqueObanIssue.Worker.new(
      %{name: name},
      unique: [states: [:scheduled, :available]]
    )
    |> Oban.insert()
  end
end
