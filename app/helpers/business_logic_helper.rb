module BusinessLogicHelper
  def filter_contents(contents, contentTypeArr)
    contents.select {|content| contentTypeArr.include?(content.content_type_code) and content.valid_content?(:shallow)}
  end
  
  def get_event_id()
    event = get_event
    return nil unless event
    event.id
  end
  
  def get_event()
    host = request.host
    host = host.sub("www.","")
    Event.where("event_url like '%"+host+"%'").first
  end
  
end
