defmodule EventBrite do
  
  defp get_emails([%{"email" => email} | tail]) do
    [email | get_emails(tail)]
  end
 
  defp get_emails([]) do
    []
  end

  def get_user_info(token) do
    case HTTPoison.get("https://www.eventbriteapi.com/v3/users/me/?token=#{token}") do
      {:ok, %HTTPoison.Response{status_code: 200, body: body, }} ->
        case Poison.decode body do
          {:ok, %{"name" => name, "emails" => emails}} ->
            simple_emails = get_emails(emails)
            IO.puts "you are #{name} with email #{simple_emails}"
            %{"name" => name, "emails" => simple_emails}
          {:error, r} ->
            raise r
        end
      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} ->
        raise "Got #{status_code} (#{body})..."
      {:error, %HTTPoison.Error{reason: reason}} ->
        raise reason
    end
  end
end
