defmodule Notifications.Core.Utils do
  @moduledoc false

  def new_id, do: UUID.uuid4()
end
