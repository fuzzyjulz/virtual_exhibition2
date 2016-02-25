class ConfirmationsController < Devise::ConfirmationsController
  layout :layout_by_resource

  def visitor_actions
    ["show"]
  end

  def show
    if user_signed_in?
      respond_to do |format|
        format.html { redirect_to events_dashboard_path() }
      end
    else
      super
      if @user.confirmed?
        record_event(GaEvent.new(category: :login_process, action: :confirmed, label: :direct, user: @user))
        if !user_signed_in?
          sign_in resource_name, resource, :bypass => true
        end
      end
    end
  end
  def set_context_objects
  end
end