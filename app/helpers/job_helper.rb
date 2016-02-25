module JobHelper
  def run_job(jobClass, options = {})
    options[:current_user_id] = current_user.id
    options[:jobType] = jobClass.name
    if current_user.has_role? :test_admin
      #if we are running tests then don't use Redis
      options[:test_only] = "true"
      jobClass.new(current_user.id, options).perform()
    else
      job_id = jobClass.create(options)
      set_job_id job_id
    end
  end

  def set_job_id job_id
    session["job_id-#{current_user.id}"] = job_id
  end
end