module JobRunStatusHelper
  def job_run_status 
    @job_run_status = Resque::Plugins::Status::Hash.get(session["job_id-#{current_user.id}"]) if session["job_id-#{current_user.id}"]
    if @job_run_status.present? and @job_run_status.options["jobType"].present?
      begin
        job_class = Object.const_get(@job_run_status.options["jobType"])
        @job_output_type = job_class::OUTPUT_TYPE if defined? job_class::OUTPUT_TYPE
      rescue
      end
    end
  end
end
