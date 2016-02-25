module StringHelper
  def safe_chars(value)
    StringHelper.safe_chars(value)
  end

  def self.safe_chars(value)
    value.present? ? value.to_s.gsub(/[^0-9a-zA-z\-_: ,]/,'').html_safe : nil
  end
  
  def no_html(value)
    return nil if !value.present?
    value.to_s.gsub(/<.*?>/, "").gsub(/&nbsp;/,"")
  end

  def boolean_YN(boolean)
    boolean ? "Yes" : "No"
  end

  def clensedText(text)
    if text.nil?
      ""
    else
      text.gsub("<","&lt;").gsub(">","&gt;").gsub("\n","<br/>")
    end
  end
  
  #Forces a line break within html with a given line size, spaces are used to break and an ellipsis is added. If
  # the string is one long piece of text, it will put in a dash at the line break. 
  def forceLineBreaksOnHtml(messageArray, maximumLineSize)
    finalArr = []
    messageArray.each do |messageLine|
      lineCharIndex = 0
      lineStartFrom = 0
      lineInHtml = false
      lineLastCharIsSpace = false
      lineLastSpaceIndex = 0
      
      messageLine.chars.each_with_index do |char, index|
        if (char == "<")
          lineInHtml = true
        end
        
        isCharASpace = (char =~ /\s/) != nil
        
        if lineInHtml
        elsif (isCharASpace && !lineLastCharIsSpace)
          lineLastCharIsSpace = true
          lineLastSpaceIndex = index
          lineCharIndex += 1
        elsif (!isCharASpace)
          lineCharIndex += 1
        end
        lineLastCharIsSpace = isCharASpace if !lineInHtml
        
        lineInHtml = false if (char == ">")
        
        if (lineCharIndex > maximumLineSize)
          if (lineLastSpaceIndex > lineStartFrom)
            finalArr.push(messageLine[lineStartFrom..lineLastSpaceIndex-1] + "...")
            lineStartFrom = lineLastSpaceIndex
            lineCharIndex = 0
          else
            # this is a forced break in the middle of text
            finalArr.push(messageLine[lineStartFrom..index] + "-"+lineLastSpaceIndex.to_s+lineStartFrom.to_s)
            lineCharIndex = 0
            lineStartFrom = lineLastSpace = index
          end
          lineLastValidChar = ""
        end
        
        if index+1 == messageLine.size
          finalArr.push(messageLine[lineStartFrom..index])
        end
      end
    end
    
    finalArr
  end
end