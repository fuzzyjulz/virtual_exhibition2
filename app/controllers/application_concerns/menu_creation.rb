module MenuCreation
  extend ActiveSupport::Concern
  
  included do
    ICONS= {
              event: "calendar",
              hall: "cubes",
              booth: "cube",
              promotion: "cube",
              promotion_code: "cube",
              template: "paw",
              content: "file-photo-o",
              product: "trophy",
              user: "users",
              dashboard: "dashboard",
              tag: "tags"
    }
  end
  
  def sidebar_menu(top_level=nil, menu_class=nil, menu_items=nil, expanded=nil)
    @sidebar_menu_item ||= []
    
    menuItems = [:event, :hall, :booth, :promotion, :promotion_code, :template, :content, :product, :tag, :user]

    menuItems.each do |menuItemType|
      create_menu_for_type(menuItemType)
    end
  end
    
  def create_menu_for_type(menuItemType)
    path = request.fullpath
    menuItemType_str = menuItemType.to_s
            
    if @hall.present? and @hall.id.present? and respond_to? "hall_#{menuItemType_str}s_path"
      menuItemType_pathstr = "hall_#{menuItemType_str}"
      menuItemType_pathparams = [@hall]
    elsif @event.present? and @event.id.present?  and respond_to? "event_#{menuItemType_str}s_path"
      menuItemType_pathstr = "event_#{menuItemType_str}"
      menuItemType_pathparams = [@event]
    elsif @promotion.present? and @promotion.id.present?  and respond_to? "promotion_#{menuItemType_str}s_path"
      menuItemType_pathstr = "promotion_#{menuItemType_str}"
      menuItemType_pathparams = [@promotion]
    elsif respond_to? "#{menuItemType_str}s_path"
      menuItemType_pathstr = menuItemType_str
      menuItemType_pathparams = []
    else
      return
    end
    
    index_path = "#{menuItemType_pathstr}s_path"
    new_path = "new_#{menuItemType_pathstr}_path"
    controller_str = "#{menuItemType_str.gsub(/_/," ").titleize.gsub(" ","")}sController"
    controller = Object.const_get(controller_str)
    class_obj = Object.const_get("#{menuItemType_str.gsub(/_/," ").titleize.gsub(" ","")}")
    
    if defined? controller.menu
      items = controller.menu(self)
    else
      items = []
      items << [send(index_path, menuItemType_pathparams), "List #{menuItemType_str.gsub(/_/," ")}s"] if can? :index, class_obj
      items << [send(new_path, menuItemType_pathparams), "Create #{menuItemType_str.gsub(/_/," ")}"] if can? :new, class_obj
    end
    if items.present?
      add_sidebar_menu([menuItemType_str.capitalize.gsub(/_/," "), ICONS[menuItemType]], "#{menuItemType_str}-nav", items, "#{menuItemType_str}s" == params[:controller])
    end
  end

  def add_sidebar_menu(top_level, menu_class, menu_items, expanded)
    @sidebar_menu_item << [top_level, menu_class, menu_items, expanded]
  end
  
  def hide_sidebar value = nil
    @hide_sidebar = value
  end
end