defmodule Notifications.Boundary.SendNotification do
  @moduledoc false

  alias Notifications.Core.Job
  alias Notifications.Core.Job.Email
  import Swoosh.Email

  def run(%Job{notification: %Email{} = email} = _job) do
    email
    |> to_swoosh_mail()
    |> Notifications.Mailer.deliver()
  end

  defp to_swoosh_mail(%Email{} = email) do
    new()
    |> to({email.to["name"], email.to["email"]})
    |> from({email.from["name"], email.from["email"]})
    |> subject(email.subject)
    |> html_body(email.html)
    |> text_body(email.plain_text)
  end
end
