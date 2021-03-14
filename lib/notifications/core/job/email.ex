defmodule Notifications.Core.Job.Email do
  @moduledoc false
  alias Notifications.Core.Utils

  defstruct [:id, :subject, :from, :to, :plain_text, :html]

  def new(
        subject,
        from = %{"email" => _, "name" => _},
        to = %{"email" => _, "name" => _},
        html,
        opts \\ []
      ) do
    attrs = %{
      subject: subject,
      from: from,
      to: to,
      html: html,
      plain_text: Keyword.get(opts, :plain_text, ""),
      id: Keyword.get(opts, :id, Utils.new_id())
    }

    struct!(__MODULE__, attrs)
  end
end
