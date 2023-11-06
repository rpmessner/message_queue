defmodule MessageQueueWeb.Router do
  use MessageQueueWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MessageQueueWeb do
    pipe_through :api

    get "/receive-message", MessageController, :receive_message
  end
end
