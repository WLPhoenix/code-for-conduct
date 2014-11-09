defmodule Twilio do

	defp build_url() do
		account_sid = System.get_env("TWILIO_SID") # || raise "Twilio SID missing."]
		auth_token = System.get_env("TWILIO_TOKEN") # || raise "Twilio AuthToken missing."]

		url = ["https://#{account_sid}:#{auth_token}@api.twilio.com",
					 "/2010-04-01/Accounts/#{account_sid}/Messages"] |> Enum.join ""
	end

  def send_sms(to, from, body) do
    content = "To=#{to}&From=#{from}&Body=#{body}"
		url = build_url()

		IO.puts url
		IO.puts content

    case HTTPoison.post(url, content, [{<<"Content-Type">>, <<"application/x-www-form-urlencoded">>}]) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        IO.puts Poison.decode body
      {:ok, %HTTPoison.Response{status_code: 404, body: body}} ->
        IO.puts "Not found :-( #{body}"
      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} ->
        IO.puts "I got a different code #{status_code} -- what the hell? #{body}"
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end
  end


  def send_report_sms()
end
