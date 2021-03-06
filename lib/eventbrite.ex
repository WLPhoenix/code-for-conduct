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

  defp parse_single_event(%{"name" => %{"text" => name}, "id" => id, "venue" => %{"address" => address}, "start" => %{"local" => starttime}, "end" => %{"local" => endtime}, "category" => %{ "name" => etype}}) do
    %{ :id => id, :name => name, :address => address, :start => starttime, :end => endtime, :etype => etype, :email => "organizer@example.com", :phone => "615-867-5309"}
  end

  defp parse_events([event|more_events]) do
    [parse_single_event(event)|parse_events(more_events)]
  end

  defp parse_events([]) do
    []
  end

  def get_event_info(token) do
    u = "https://www.eventbriteapi.com/v3/users/me/owned_events/?token=#{token}"
    IO.puts u
    case HTTPoison.get(u) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        case Poison.decode body do
          {:ok, %{"events" => events}} ->
            parse_events(events)
          {:error, r} ->
            raise r
        end
      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} ->
        raise "Got #{status_code} (#{body})..."
      {:error, %HTTPoison.Error{reason: reason}} ->
        raise reason
    end
  end

  def get_single_event_info(token, event_id) do
    u = "https://www.eventbriteapi.com/v3/events/#{event_id}/?token=#{token}"
    IO.puts u
   
    case HTTPoison.get(u) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        case Poison.decode body do
          {:ok, event} ->
            parse_single_event(event)
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
