#Captures the campaign data from the session and tries to create a campaign object in the session if it does exist
class UtmCampaign < GabbaGMP::GabbaGMP::Campaign
  UTM_SESSION_PARAM = :utm_session

  def self.campaign(session)
    if defined? session[UTM_SESSION_PARAM] and (campaign = session[UTM_SESSION_PARAM]).present?
      campaign
    else
      nil
    end
  end
  
  def self.create_campaign(session, request, params)
    campaign = UtmCampaign.new()
    campaign.name = params[:utm_campaign] if params[:utm_campaign].present?
    campaign.source = params[:utm_source] if params[:utm_source].present?
    campaign.medium = params[:utm_medium] if params[:utm_medium].present?
    campaign.keyword = params[:utm_term] if params[:utm_term].present?
    campaign.content = params[:utm_content] if params[:utm_content].present?
      
    #In the case where we are picing up an origin code, it should map to the more modern field of source
    campaign.source = params[:origin] if !campaign.present? && params[:origin].present?
    
    session[UTM_SESSION_PARAM] = campaign if campaign.present?
    UtmCampaign.campaign(session)
  end
  
  def clear
    name = source = medium = keyword = content = nil
  end
end