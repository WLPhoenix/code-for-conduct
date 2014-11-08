# CodeForConduct

To start your new Phoenix application:

1. Install dependencies with `mix deps.get`
2. Start Phoenix router with `mix phoenix.start`

Now you can visit `localhost:4000` from your browser.


## Phoenix

https://github.com/phoenixframework/phoenix



## HTTPoison

https://github.com/edgurgel/httpoison

```elixir
# In iex -S mix

import HTTPoison
HTTPoison.start

case HTTPoison.get(url) do
  {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
    IO.puts body
  {:ok, %HTTPoison.Response{status_code: 404}} ->
    IO.puts "Not found :("
  {:error, %HTTPoison.Error{reason: reason}} ->
    IO.inspect reason
end
```
