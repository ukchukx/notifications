defmodule Notifications.Web.NotificationController do
  @moduledoc false

  use Notifications.Web, :controller

  @routes [
    %{
      method: "POST",
      path: "/notify",
      description: "Send an email notification",
      arguments: %{
        type: "email",
        max_delay: "Max. delay allowed in seconds",
        params: %{
          subject: "Email subject",
          to: %{
            name: "Receiver name",
            email: "Receiver email"
          },
          from: %{
            name: "Sender name",
            email: "Sender email"
          },
          html: "HTML body",
          plain_text: "Text body"
        }
      }
    }
  ]

  def notify(conn, params = %{"type" => _, "params" => %{}}) do
    json(conn, %{result: Notifications.send_notification(params)})
  end

  def help(conn, _) do
    json(conn, %{routes: @routes})
  end
end
