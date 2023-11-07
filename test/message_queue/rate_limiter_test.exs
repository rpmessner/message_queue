defmodule MessageQueue.RateLimiterTest do
  use ExUnit.Case, async: true

  alias MessageQueue.RateLimiter

  test "prints each message " do
    RateLimiter.send_message("foo", "bar")
    RateLimiter.send_message("foo", "baz")

    RateLimiter.send_message("bar", "fizz")
    RateLimiter.send_message("bar", "foo")

    assert RateLimiter.state() == %{"foo" => ["bar", "baz"], "bar" => ["fizz", "foo"]}

    RateLimiter.handle_next("foo")

    assert RateLimiter.state() == %{"foo" => ["baz"], "bar" => ["fizz", "foo"]}

    RateLimiter.handle_next("foo")

    assert RateLimiter.state() == %{"bar" => ["fizz", "foo"], "foo" => []}

    RateLimiter.handle_next("foo")

    assert RateLimiter.state() == %{"bar" => ["fizz", "foo"]}
  end
end
