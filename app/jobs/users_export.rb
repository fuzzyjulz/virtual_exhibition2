require 'concerns/temp_file_helper'

class UsersExport
  include Resque::Plugins::Status
  include TempFileHelper

  def perform
    begin
      puts "Parsing CSV and exporting..."
      optionHash = rekey_hash_by_sym(options)
      @use_redis = !optionHash[:test_only].present?
      event_id = optionHash[:event_id]
      puts "  options: #{"event:#{event_id}" if event_id} #{"test mode" if !@use_redis}"
      if event_id.present?
        @users = User.joins(:events).where(:events_users => {:event_id => event_id.to_i}).includes(:events)
      else
        @users = User.all
      end
      
      columns = %w{ id email title first_name last_name position work_phone company state industry mobile 
                    origin terms sign_in_count last_sign_in_at confirmed_at created_at last_seen
                    event_names role_names booth_names booth_closed_message }
      
      @users = @users.to_a
      
      prepared_user_list = map_user_resource_for_export(@users, columns)
      generate_csv_report(optionHash[:current_user_id], prepared_user_list, columns)
    
      puts "File export finished..."
    rescue => e
      puts("Unable to write users #{e}")
      print e.backtrace.join("\n")
      failed("Unable to write users #{e}")
    end

  end

  def generate_csv_report(user_id, users, columns)
    file_path = get_new_temp_file("users","csv")
    CSV.open(file_path, "wb") do |csv|
      csv << columns
      
      totalUsers = users.size
      
      users.each_with_index do |user, index|
        csv << user
        at(index, totalUsers) if @use_redis
      end
    end
    
    puts file_path
    user = User.find(user_id)
    write_file_to_user(user, file_path)
  end


  private

    def map_user_resource_for_export(resources, columnNames)
      
      resources.map! do |resource|
        columnNames.map do |columnName|
          begin
            case value = resource.send(columnName)
            when Array
              value.join("; ")
            else
              value.to_s
            end
          rescue => e
            "Method or relation not found: #{e}"
          end
        end
      end
    end
end