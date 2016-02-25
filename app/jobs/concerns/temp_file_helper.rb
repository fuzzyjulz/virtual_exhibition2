module TempFileHelper

  def get_new_temp_file(fileName, extension)
    tmpDir = Rails.root.to_s+"/tmp"
    Dir.mkdir(tmpDir) unless File.exists?(tmpDir)
    
    finalName = tmpDir+'/'+fileName+'-'+Time.now.strftime("%d-%m-%Y-%H%M%S")+'.'+extension
    puts "Creating file: "+finalName
    
    finalName
  end
  
  def write_file_to_user(user, fileName)
    updated = nil
    File.open(fileName) do |logFile|
      updated = user.update(:csv_file_attributes => { :assets => logFile, assets_content_type: "text/csv"})
    end
    
    if updated
      begin
        File.delete(fileName)
        puts "Removed temp file"
      rescue => e
        puts "Couldn't remove log file."
      end
      true
    else
      puts "Update failed, messages:"
      puts user.errors.messages.to_s
      false
    end
  end
  
  def rekey_hash_by_sym(origHash)
    newHash = {}
    origHash.each_pair {|key, value| key.is_a?(Symbol) ? newHash[key] = value : newHash[key.to_sym] = value}
      
    return newHash
  end
end