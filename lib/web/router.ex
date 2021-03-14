defmodule Notifications.Web.Router do
  alias Notifications.Web
  use Web, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug Plug.Telemetry, event_prefix: [:notifications, :plug]
    plug Web.Plug.Auth
    plug Web.MetricsExporter
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: Notifications.Web.Telemetry
    end
  end

  scope "/", Web do
    pipe_through :api

    post "/notify", NotificationController, :notify
    post "/*path", NotificationController, :help
    get "/*path", NotificationController, :help
  end
end
