module KnowledgeHall
  extend ActiveSupport::Concern
  
  included do
    NAV_ITEMS = { keynotes: Tag::TAG_TYPE[:keynote], 
                  topics: Tag::TAG_TYPE[:topic],
                  featured: "Featured",
                  latest: "Latest",
                  all: "Browse All"
                }
    HallsController::VIEW_CONTENT << :content_list
    
    helper_method :get_contents
    helper_method :kc_nav_items
    helper_method :previewContent
    helper_method :contents, :content_title
    helper_method :nav_type, :nav_type_contents
    helper_method :filter_params, :kaminari_url

    delegate_to class: :sub_controller, method: :content_list
  end

  class KnowledgeHallController < HallsController::HallsSubController
    attr_reader :kc_nav_items, :contents, :nav_type, :nav_type_contents, :previewContent
    attr_reader :content_title
    attr_reader :filter_params, :kaminari_url
  
    def new_nav_item(id, name, path)
      ActiveSupport::OrderedOptions.new.tap do |nav_item|
        nav_item.id = id
        nav_item.name = name
        nav_item.path = path
        nav_item.content_count = get_content_list(nav_item.id).size
      end
    end
  
    def visit()
      set_kc_nav_items
      @nav_type = @kc_nav_items[0].id
      
      @kaminari_url = content_list_hall_path(hall.id)
      tags = get_selected_tags
      @nav_type_contents = @nav_type
      if tags.present?
        @nav_type = "#{tags[0].tag_type}s".to_sym
        @nav_type_contents = :tagged_content
      end 
      @filter_params = "&type=#{@nav_type_contents}#{tags.present? ? "&tag=#{tags[0].id}" : ""}"
      preview_content_id = params[:content_id] || params[:previewContent]
      @previewContent = Content.find(preview_content_id) if preview_content_id
      set_content_title(tags)
    end
    
    def content_list
      @nav_type = params[:type].to_sym if params[:type]
      @nav_type ||= :all
      @contents = get_contents(@nav_type)
      @filter_params = "&type=#{@nav_type}"
      @filter_params += "&tags=#{params[:tags]}" if params[:tags].present?
      set_content_title(get_selected_tags)
      render layout: "modal_box"
    end
    
    def set_content_title(tags)
      @content_title = tags.map { |tag| tag.name}.join(", ") if tags.present? and ([:tagged_content, :topics, :keynotes].include? @nav_type)
    end
    
    def get_content_list(contents_type)
      case contents_type
        when :latest
          contents = hall.recently_updated_content
        when :featured
          contents = hall.featured_content
        when :topics
          contents = hall.topics
        when :keynotes
          contents = hall.keynotes
        when :all
          contents = hall.contents
        when :tagged_content
          contents = hall.tagged_content(get_selected_tags)
      end
      return [] if contents.nil?
      contents = contents.includes(:thumbnail_image).order(featured: :desc, updated_at: :desc)
      
      group_contents_by_type(contents, contents_type)
    end
    
    def get_selected_tags
      tags = params[:tags] || params[:tag]
      return nil unless tags.present?
      tags = tags.gsub(/[\[\]]/,"")
      return tags.split(",").map { |tag| Tag.find(tag)}
    end
  
    def group_contents_by_type(contents, contents_type)
      contents = contents.select {|content| (!defined? content.valid_content?) || content.valid_content?(:shallow)} if contents.present?
      if [:topics, :keynotes].include?(contents_type)
        groupedContents = contents
      else
        groupedContents = contents.select {|content| content.is_video?}
        groupedContents = groupedContents | contents.select {|content| content.is_content_type?(:slideshare)}
        groupedContents = groupedContents | contents.select {|content| !(content.is_video? or content.is_content_type?(:slideshare))}
      end
      groupedContents ||= []
    end
    
    def set_kc_nav_items
      @kc_nav_items = []
      NAV_ITEMS.each_pair do |code, label|
        @kc_nav_items << new_nav_item(code, label, content_list_hall_path(hall.id, type: code))
      end
      
      @kc_nav_items.keep_if {|nav_item| nav_item.id == :all or nav_item.content_count > 0}
    end
    
    
    def get_contents(contents_type)
      contents = get_content_list(contents_type)
      contents = Kaminari.paginate_array(contents).page(params[:page]).per(6)
      contents
    end
  end
end