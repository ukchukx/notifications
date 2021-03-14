defmodule Notifications.Boundary.SendNotification do
  @moduledoc false

  alias Notifications.Core.Job
  alias Notifications.Core.Job.Email
  import Swoosh.Email

  def run(_job = %Job{notification: email = %Email{}}) do
    email
    |> to_swoosh_mail()
    |> Notifications.Mailer.deliver()
  end

  defp to_swoosh_mail(email = %Email{}) do
    new()
    |> to({email.to["name"], email.to["email"]})
    |> from({email.from["name"], email.from["email"]})
    |> subject(email.subject)
    |> html_body(email.html)
    |> text_body(email.plain_text)
  end
end
