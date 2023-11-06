defmodule MessageQueueWeb.MessageController do
  use MessageQueueWeb, :controller

  def receive_message(conn, %{"queue" => ""}), do: send_resp(conn, 422, "")
  def receive_message(conn, %{"message" => ""}), do: send_resp(conn, 422, "")

  def receive_message(conn, %{"queue" => queue, "message" => message}) do
    MessageQueue.RateLimiter.send_message(queue, message)

    conn
    |> send_resp(200, "")
  end

  def receive_message(conn, %{}), do: send_resp(conn, 422, "")
end
