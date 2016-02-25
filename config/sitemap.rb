# Change this to your host. See the readme at https://github.com/lassebunk/dynamic_sitemaps
# for examples of multiple hosts and folders.

Event.all.each do |event|
  event_domain = event.domain
  next if event_domain.nil?

  puts "Generating sitemap for #{event_domain}"
  
  folder "sitemaps/#{event_domain}"
  host event_domain
  
  sitemap :site do
    url root_url, last_mod: Time.now, change_freq: "weekly", priority: 1.0
    event.published_halls.each do |hall|
      url hall_visit_url(hall), last_mod: hall.updated_at, change_freq: "weekly", priority: 1.0
    end
    event.published_booths.each do |booth|
      url booths_visit_url(booth), last_mod: booth.updated_at, change_freq: "weekly", priority: 1.0
    end
    knowledge_hall = event.knowledge_hall
    if knowledge_hall.present?
      knowledge_hall.contents.each do |content|
        if content.publically_visibile? and content.valid_content?(:shallow)
          url hall_view_content_path(knowledge_hall, content), last_mod: content.updated_at, change_freq: "weekly", priority: 1.0
        end
      end
    end
  end
  
  #Store the sitemap using paperclip on the event.
  event.build_sitemap if event.sitemap.nil?

  File.open("#{DynamicSitemaps.temp_path}/sitemaps/#{event_domain}/site.xml") do |sitemap_file|
    event.sitemap.assets = sitemap_file
    event.save!
  end
  
  ping_with "http://#{host}/sitemap.xml" if Rails.env.production?
end
