defmodule Twilio do

  account_sid = [System.get_env("TWILIO_SID") || raise "Twilio SID missing."]
  auth_token = [System.get_env("TWILIO_TOKEN") || raise "Twilio AuthToken missing."]

	url = ["https://#{account_sid}:#{auth_token}@api.twilio.com",
				 "/2010-04-01/Accounts/#{account_sid}/Messages"] |> Enum.join ""
	@url url

  def send_sms(to, from, body) do
    content = %{
                "To": to,
                "From": from,
                "Body": body
            }

    case Poison.encode content do
      {:ok, json} -> enc_content = json
      {:error, r} -> raise r
    end

    case HTTPoison.post(@url, enc_content, [{<<"Content-Type">>, <<"application/json">>}]) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        IO.puts "BODY :: [[#{content}]]"
      {:ok, %HTTPoison.Response{status_code: 404, body: body}} ->
        IO.puts "Not found :-( #{content}"
      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} ->
        IO.puts "I got a different code #{status_code} -- what the hell? #{body}"
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end
  end


  def send_report_sms()
end
