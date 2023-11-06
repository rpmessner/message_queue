# MessageQueue

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000/receive-message) from your browser or curl.

Required arguments for the endpoint are `queue` and `message`.  One messsage per each queue will be printed per second.

The `test.sh` file will send multiple requests.
