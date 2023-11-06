Build an application that accepts messages via an HTTP endpoint and processes the messages in the order that they are received. The application should be able to handle multiple queues based on a parameter passed into the HTTP endpoint. Each queue should be rate limited to process no more than one message per second.

1. We use Phoenix and Elixir for this type of task, but your solution can be based on any
   language/framework that you are comfortable with.
2. You should have an HTTP endpoint at the path /receive-message which accepts a GET request with the
   query string parameters queue (string) and message (string).
3. Your application should accept messages as quickly as they come in and return a 200 status code.
4. Your application should “process” the messages by printing the message text to the terminal,
   however for each queue, your application should only “process” one message a second,
   no matter how quickly the messages are submitted to the HTTP endpoint.
5. Bonus points for writing some kind of test that verifies messages are only processed one
   per second.
6. Good luck!
