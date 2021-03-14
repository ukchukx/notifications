defmodule Notifications.Web.Plug.Auth do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _default) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         true <- ok?(token) do
      conn
    else
      _ -> unauthorized(conn)
    end
  end

  defp unauthorized(conn) do
    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(401, Jason.encode!(%{error: "Unauthorized"}))
    |> halt
  end

  defp ok?(token), do: Application.get_env(:notifications, :access_token) == token
end
