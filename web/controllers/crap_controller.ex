defmodule CodeForConduct.CrapController do
  use Phoenix.Controller
  import HTTPoison
  import Poison
  import EventBrite

  alias CodeForConduct.Router
  alias CodeForConduct.Repo
  alias CodeForConduct.Event

  plug :action

  def list_eb(conn, _params) do
    case get_session(fetch_session(conn), :eb_token) do
      nil ->
        redirect conn, to: CodeForConduct.Router.Helpers.page_path(:auth)
      token ->
        ei = EventBrite.get_event_info(token)
        json conn, ei
    end
  end

  defp calculate_initial_cofc(event_title, 
                              event_type, 
                              contact_email, 
                              contact_phone, 
                              %{"alcohol" => alcohol, 
                                "concerns" => concerns,
                                "minAge" => minAge,
                                "overnight" => overnight,
                                "parties" => parties
                               }) do
    #"Come on, don't be an asshole. Really, just don't."
    "<h2>Code of Conduct</h2>

<h3>Harassment</h3>

<p>
The #{event_title} is dedicated to providing a harassment-free #{event_type} experience for everyone (regardless of gender, sexual orientation, disability, physical appearance, body size, race, or religion). We do not tolerate harassment of #{event_type} participants in any form. #{event_type} participants violating these rules may be sanctioned or expelled from the #{event_type} without a refund at the discretion of the #{event_type} organizers. If you have any questions or concerns, please contact us at #{contact_email}.
</p>
<p>
Harassment includes verbal comments that reinforce social structures of domination (related to gender, gender identity and expression, sexual orientation, disability, physical appearance, body size, race, age, religion, #{concerns}), sexual images in public spaces, deliberate intimidation, stalking, following, harassing photography or recording, sustained disruption of talks or other events, inappropriate physical contact, and unwelcome sexual attention. Participants asked to stop any harassing behavior are expected to comply immediately.
</p>
<p>
#{parties} are subject to the anti-harassment policy. In particular, #{parties} should not use sexualized images, activities, or other material. #{event_title} staff (including volunteers) should not use sexualized clothing/uniforms/costumes, or otherwise create a sexualized environment.
</p>
<p>
If a #{parties} engages in harassing behavior, the #{event_type} organizers may take any action they deem appropriate, including warning the offender or expulsion from the #{event_type}. If you are being harassed, notice that someone else is being harassed, or have any other concerns, please contact a member of #{event_type} staff immediately. 
</p>
<p>
#{event_type} staff will be happy to help #{parties} contact hotel/venue security or local law enforcement, provide escorts, or otherwise assist those experiencing harassment to feel safe for the duration of the #{event_type}. We value your attendance.
</p>
<p>
#{contact_email}
</p>
<p>
#{contact_phone}
</p>
<h3>Additional Rules</h3>
<p>
At #{event_title}, alcohol consumption will be permitted. #{parties} are not allowed to possess any open can, bottle or other receptacle containing any alcoholic beverages, except in areas specifically designated for the consumption of alcohol. Since alcohol consumption will be permitted, all participants must be 21 years of age in order to drink alcohol. All participants must drink responsibly. Alcohol may not be consumed prior to any sporting or physical activity.  The excessive consumption of alcohol, and any violent or inappropriate behavior as a result of alcohol, or otherwise will not be tolerated.
</p>
<p>
The possession or use of illegal or illicit drugs at #{event_title} is strictly prohibited.
</p>
<p>
Possession of any item that can be used as a weapon, which may cause danger to others if used in a certain manner, will not be tolerated. 
</p>
<p>
Smoking is not permitted other than in designated areas.
</p>
<p>
Assembling for the purpose of, or resulting in, disturbing the peace, or committing any unlawful act or engaging in any offensive behavior will not be tolerated. 
</p>
<p>
There is no minimum age for admittance.
</p>
<p>
This #{event_type} permits #{parties} to be present in the venue overnight.
</p>
<p>
If a #{parties} engages in any behavior that violates the rules of this Code of Conduct, the #{event_type} organizers may take any action they deem appropriate, including warning the offender or expulsion from the #{event_type}. If you see any #{parties} participating in behavior that violates the rules of this Code of Conduct, or have any other concerns, please contact a member of #{event_title} staff immediately. 
</p>
<p>
We expect #{parties} to follow these rules at all #{event_title} venues and #{event_title}-related social events.
</p>
<h3>Photo & Video Release</h3>
<p>
With regard to photographs or video taken during the #{event_title}, I hereby grant the #{event_title} coordinators permission to use my likeness in a photograph or other digital reproduction in any and all of its publications, including website entries, without payment or any other consideration. I understand and agree that these materials will become the property of #{event_title} and will not be returned. In addition, I waive the right to inspect or approve the finished product, including written or electronic copy, wherein my likeness appears. Additionally, I waive any right to royalties or other compensation arising or related to the use of the photograph or video. I hereby hold harmless and release and forever discharge #{event_title} from all claims, demands, and causes of action which I, my heirs, representatives, executors, administrators, or any other persons acting on my behalf or on behalf of my estate have or may have by reason of this authorization.
</p>
<p>
This policy is based on several other policies, including the Geek Feminism Wiki, Black Hat and CitySwarm.
</p>"
  end

  def create_conduct_text(conn, params) do
    %{"eventID" => ebid} = params
    token = get_session(conn, :eb_token)
    e = EventBrite.get_single_event_info(token, ebid)   
    cofc = calculate_initial_cofc(e.name, e.etype, e.email, e.phone, params)

    event = %Event{ebid: ebid, cofc: cofc, ownerid: "me"}
    event = Repo.insert(event)

    json conn, %{:eventID => ebid, :htmlData => cofc, :conductID => event.id}
  end

  def create_conduct(conn, params) do
    %{"conductID" => id} = params
    %{"htmlData" => cofc} = params

    event = Repo.get(Event, id)

    event = %{event | cofc: cofc}
    Repo.update(event)

    json conn, %{:id => event.id, :cocHTML => cofc, :htmlData => cofc, :conductID => event.id}
  end

  def edit_conduct(conn, _params) do
    render conn, "edit_conduct.html"
  end

  def send_info(conn, params) do
    %{"conductID" => id} = params

    event = Repo.get(Event, id)

    json conn, %{:id => event.id, :conductID => event.id}
  end
    
end
