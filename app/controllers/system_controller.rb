class SystemController < ApplicationController
  include JobRunStatusHelper
  before_action :job_run_status

  def sitemap
    content = @current_event.sitemap.content if @current_event.present? and @current_event.sitemap.present?
    content ||= ""
    render xml: content
  end

  def robots
    sitemap = ""
    if @current_event.present? and @current_event.sitemap.present?
      sitemap = @current_event.event_url + "/sitemap.xml"
    end

    @sitemap_location = sitemap
    render layout: false, content_type: "text/plain"
  end

  def job_status
  end
  
  def update_job_status
    respond_to do |format|
      format.html {render action: "index"} if current_user.has_role? :test_admin
      format.js {render action: "update_job_status"}
    end
  end
end