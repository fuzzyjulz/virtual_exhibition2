class UsersController < ApplicationController
  include JobRunStatusHelper
  include FileImportProcess
  
  before_filter :authenticate_user!, :except => [:invite_users]
  load_and_authorize_resource :except => [:show, :invite_users]
  skip_load_resource :only => [:create]
  before_action :sidebar_menu, only: CRUD_ACTIONS | [:import_new, :create_user, :import_complete]
  before_action :job_run_status, only: :index
    
  respond_to :html, :json
  responders :flash

  helper_method :locations, :available_roles

  def self.menu(controller)
    items = []
    items << [controller.users_path, "List users"] if controller.can? :index, User
    if controller.can? :new, User
      items << [controller.new_user_path, "Create a user"] << [controller.new_user_invitation_path, "Invite user"] << [controller.import_users_path, "Import users"]
    end
    items
  end
  
  def index
    respond_to do |format|
      format.html
      format.json { render json: UsersDatatable.new(view_context) }
    end
  end

  def edit
    build_resources
  end

  def new
    build_resources
  end
  
  def build_resources
    build_resource :uploaded_file
  end

  def show
  end


  def create_user
    @user = User.new(user_params)
    
    validate_user :new

    @user.terms = true
    
    
    if !@user.errors.present?
      if @user.save
        @user.confirm! if defined? @user.confirm!
      end
    end
    respond_with @user, location: users_path()
  end

  def available_roles
    if current_user.has_role?(:admin)
      Role.all.order(:name)
    else
      if @user.has_role?(:admin)
        Role.all.order(:name)
      else
        Role.all.order(:name).select{|role| role.name != "admin"}
      end
    end
  end
  
  def available_booths
    booths = (@user.booths| super).uniq
  end
  
  def validate_user(type)
    userRoles = @user.roles.map {|role| role.name}
    @user.errors.add(:booths, 'A booth must be set for a booth rep.') if userRoles.include?("booth_rep") and @user.booths.empty?
    @user.errors.add(:events, 'An event must be set for a booth rep.') if userRoles.include?("booth_rep") and @user.events.empty?
    if type == :new
      @user.errors.add(:password, 'Password and password confirmation must be identical.') if @user.password != @user.password_confirmation
      @user.errors.add(:email, 'Email address must be unique.') if User.exists?(email: @user.email)
    end
  end
  
  def update
    if params[:user][:password].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end
    onDashboardChange = (@user.status != user_params[:status])
    
    @user.assign_attributes(user_params)
    validate_user :existing
    @user.save if !@user.errors.present?
    if onDashboardChange
      respond_with @user, location: root_path()
    else
      respond_with @user
    end
  end

  def destroy
    @user.destroy
    respond_with @user
  end


  
  def export_users_to_csv
    run_job(UsersExport)

    system_job_status
  end
  
  def export_users_to_csv_by_event
    run_job(UsersExport, event_id: params[:user][:event_ids])

    system_job_status
  end

  def locations()
    return User::LOCATIONS.invert
  end
  
  def import_new
  end
  
  def import_process
    process_import(UsersImport, params[:importFile])
  end
  
  def system_job_status
    respond_to do |format|
      format.html {redirect_to system_job_status_path}
      format.js {redirect_to update_job_status_path(:js)}
    end
  end
  
  private
    def user_params
      params.require(:user).permit(:email, :encrypted_password, :password, :password_confirmation, :current_password, :status, :booth_closed_message,
    :title, :first_name, :last_name, :position, :work_phone, :mobile, :company, :state, :industry, :interested_topic, :skip_invitation, { uploaded_file_attributes: [:assets, :id] }, 
          { csv_file_attributes: [:assets, :id] }, { :role_ids => [] }, { :event_ids => [] }, { :booth_ids => [] }, :user_id)
    end

    def sidebar_menu
        super ["Users", "users"], "user-nav", [[users_path, "List users"], [new_user_path, "Create a user"], [new_user_invitation_path, "Invite user"], [import_users_path, "Import users"]], true
    end
end
