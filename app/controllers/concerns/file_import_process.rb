module FileImportProcess
  extend ActiveSupport::Concern
  
  def process_import(job_class, file_parameter, options = {})
    user = current_user
    user.build_import_csv_file
    user.import_csv_file.assets = file_parameter
    if user.save
      file_parameter.close
      
      run_job(job_class, options)
    
      redirect_to system_job_status_path
    else
      file_parameter.close
      flash[:error] = "Couldn't import #{controller_name.gsub(/_/," ")}: #{user.errors.messages.values.join(",")}"

      redirect_to :back
    end
  end
end
