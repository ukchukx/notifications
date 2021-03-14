defmodule Notifications.Core.Job do
  @moduledoc false
  alias Notifications.Core.Job.Email

  defstruct [:id, :notification, :max_delay, :metadata]

  def new(notification = %Email{id: id}, opts \\ []) do
    attrs = %{
      id: id,
      notification: notification,
      max_delay: Keyword.get(opts, :max_delay, 0),
      metadata: Keyword.get(opts, :metadata, %{})
    }

    struct!(__MODULE__, attrs)
  end
end
