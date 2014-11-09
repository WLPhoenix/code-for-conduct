defmodule Twilio do

	defp build_url() do
		account_sid = System.get_env("TWILIO_SID")
		auth_token = System.get_env("TWILIO_TOKEN")

		url = ["https://#{account_sid}:#{auth_token}@api.twilio.com",
					 "/2010-04-01/Accounts/#{account_sid}/Messages"] |> Enum.join ""
	end

  def send_sms(to, from, body) do
    content = "To=#{to}&From=#{from}&Body=#{body}"
		url = build_url()

		IO.puts url
		IO.puts content

    case HTTPoison.post(url, content, [{<<"Content-Type">>, <<"application/x-www-form-urlencoded">>}]) do
      {:ok, %HTTPoison.Response{status_code: code, body: body}} when code >= 200 and code < 300 ->
        IO.puts Poison.decode body
      {:ok, %HTTPoison.Response{status_code: 404, body: body}} ->
        IO.puts "Not found :-( #{body}"
      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} ->
        IO.puts "I got a different code #{status_code} -- what the hell? #{body}"
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end
  end


  def send_report_sms(reporter, event_title, to_list) do

		from_number = System.get_env("TWILIO_FROM_NUMBER")
		message = ["The following concern has been submitted by",
							 "#{reporter} regarding the",
							 "#{event_title} event for your review."] |> Enum.join " "

		for to_number <- to_list do
			send_sms(to_number, from_number, message)
		end
	end
end
