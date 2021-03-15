defmodule Notifications do
  @moduledoc false
  alias Notifications.Boundary.JobManager
  alias Notifications.Core.Job
  alias Notifications.Core.Job.Email

  def send_notification(data = %{"type" => "email", "params" => %{}}) do
    html_text = get_in(data, ["params", "html"])

    plain_text =
      case get_in(data, ["params", "plain_text"]) do
        nil -> html_text
        plain_text -> plain_text
      end

    email =
      Email.new(
        data["params"]["subject"],
        data["params"]["from"],
        data["params"]["to"],
        html_text,
        plain_text: plain_text
      )

    max_delay = Map.get(data, "max_delay", 0)

    email
    |> Job.new(max_delay: max_delay)
    |> JobManager.add_job()

    :ok
  end

  def send_notification(_data) do
    :unsupported_type
  end
end
