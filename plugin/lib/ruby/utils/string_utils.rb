# Class to provide common string manipulation utilities
class StringUtils

  # Strip html and replace newline and space formatting with text equiv
  def self.html2text(string)
    string.gsub!(/<(br)(\ +\/)?>/, "\n")    # replace newlines
    string.gsub!(/<\/?[^>]*>/, "")          # remove html tags
    string.gsub!(/&nbsp;/, " ")             # replace spaces
    string
  end

end
