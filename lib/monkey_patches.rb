class String

  # Pollute the space between every letter in a string,
  # so it will be exempt from any impending string searches.
  def pollute(delimiter = "^--^--^")
    self.split('').map{|letter| "#{letter}#{delimiter}" }.join
  end

  # Meant to be paired with the pollute method, this removes 'pollution' from the string
  def sanitize(delimiter = "^--^--^")
    self.gsub(delimiter, "")
  end

  # Removes the middle from long strings, replacing with a placeholder
  def ellipsize(options={})
     max = options[:max] || 40
     delimiter = options[:delimiter] || "..."
     return self if self.size <= max
     offset = max/2
     self[0,offset] + delimiter + self[-offset,offset]
  end
  
  # Generates a permalink-style string, with odd characters removed, etc.
  def permalinkify
    result = self.to_s
    result.gsub!(/[^\x00-\x7F]+/, '') # Remove anything non-ASCII entirely (e.g. diacritics).
    result.gsub!(/[^\w_ \-]+/i,   '') # Remove unwanted chars.
    result.gsub!(/[ \-]+/i,      '-') # No more than one of the separator in a row.
    result.gsub!(/^\-|\-$/i,      '') # Remove leading/trailing separator.
    result.downcase
  end

  # Remove first instance of string
  def nix(string)
    self.sub(string, "")
  end

  # Remove all instances of string
  def gnix(string)
    self.gsub(string, "")
  end

  # Prepends 'http://' to the beginning of non-empty strings that don't already have it.
  def add_http
    return "" if self.blank?
    return "http://#{self}" unless self.starts_with?("http")
    self
  end
  
  # Removes presentationally superflous http and/or www text from the beginning of the string
  def remove_http_and_www
    return "" if self.blank?
    return self.split(".").remove_first_element.join(".") if self.starts_with?("www.")
    self.gsub("http://www.", "").gsub("http://", "").gsub("https://www.", "").gsub("https://", "")
  end
  
  # Shortens a string, preserving the last word. Truncation can be limited by words or characters
  def truncate_preserving_words(options={})
    end_string = options[:end_string] || "..."
    max_words = options[:max_words] || nil
    if max_words
      words = self.split()
      return self if words.size < max_words
      words = words[0..(max_words-1)]
      words << end_string
      words.join(" ")
    else
      max_chars = options[:max_chars] || 60
      return self if self.size < max_chars
      out = self[0..(max_chars-1)].split(" ")
      out.pop
      out << end_string
      out.join(" ")
    end
  end

  def replace_wonky_characters_with_ascii
    t = self.to_s
    t.gsub!(/&#8211;/, '-')      # en-dash
    t.gsub!(/&#8212;/, '--')     # em-dash
    t.gsub!(/&#8230;/, '...')     # ellipsis    
    t.gsub!(/&#8216;/, "'")      # open single quote
    t.gsub!(/&#8217;/, "'")      # close single quote
    t.gsub!(/&#8220;/, '"')      # open double quote
    t.gsub!(/&#8221;/, '"')      # close double quote
    
    t.gsub!("\342\200\042", "-")    # en-dash
    t.gsub!("\342\200\041", "--")   # em-dash
    t.gsub!("\342\200\174", "...")  # ellipsis
    t.gsub!("\342\200\176", "'")    # single quote
    t.gsub!("\342\200\177", "'")    # single quote
    t.gsub!("\342\200\230", "'")    # single quote
    t.gsub!("\342\200\231", "'")    # single quote
    t.gsub!("\342\200\234", "\"")   # Double quote, right
    t.gsub!("\342\200\235", "\"")   # Double quote, left
    t.gsub!("\342\200\242", ".")
    t.gsub!("\342\202\254", "&euro;");   # Euro symbol
    t.gsub!(/\S\200\S/, " ")             # every other strange character send to the moon
    t.gsub!("\176", "\'")  # single quote
    t.gsub!("\177", "\'")  # single quote
    t.gsub!("\205", "-")		# ISO-Latin1 horizontal elipses (0x85)
    t.gsub!("\221", "\'")	# ISO-Latin1 left single-quote
    t.gsub!("\222", "\'")	# ISO-Latin1 right single-quote
    t.gsub!("\223", "\"")	# ISO-Latin1 left double-quote
    t.gsub!("\224", "\"")	# ISO-Latin1 right double-quote
    t.gsub!("\225", "\*")	# ISO-Latin1 bullet
    t.gsub!("\226", "-")		# ISO-Latin1 en-dash (0x96)
    t.gsub!("\227", "-")		# ISO-Latin1 em-dash (0x97)
    t.gsub!("\230", "\'")  # single quote
    t.gsub!("\231", "\'")  # single quote
    t.gsub!("\233", ">")		# ISO-Latin1 single right angle quote
    t.gsub!("\234", "\"")  # Double quote
    t.gsub!("\235", "\"")  # Double quote
    t.gsub!("\240", " ")		# ISO-Latin1 nonbreaking space
    t.gsub!("\246", "\|")	# ISO-Latin1 broken vertical bar
    t.gsub!("\255", "")	  # ISO-Latin1 soft hyphen (0xAD)
    t.gsub!("\264", "\'")	# ISO-Latin1 spacing acute
    t.gsub!("\267", "\*")	# ISO-Latin1 middle dot (0xB7)
    t    
  end

  # Cleans up MS Word-style text, getting rid of things like em-dashes, smart quotes, etc..
  def replace_wonky_characters_with_entities
    t = self.to_s
    t.gsub!("\342\200\042", "&ndash;")   # en-dash
    t.gsub!("\342\200\041", "&mdash;")   # em-dash
    t.gsub!("\342\200\174", "&hellip;")  # ellipsis
    t.gsub!("\342\200\176", "&lsquo;")   # single quote
    t.gsub!("\342\200\177", "&rsquo;")   # single quote
    t.gsub!("\342\200\230", "&rsquo;")   # single quote
    t.gsub!("\342\200\231", "&rsquo;")   # single quote
    t.gsub!("\342\200\234", "&ldquo;")   # Double quote, right
    t.gsub!("\342\200\235", "&rdquo;")   # Double quote, left
    t.gsub!("\342\200\242", ".")
    t.gsub!("\342\202\254", "&euro;");   # Euro symbol
    t.gsub!(/\S\200\S/, " ")             # every other strange character send to the moon
    t.gsub!("\176", "\'")  # single quote
    t.gsub!("\177", "\'")  # single quote
    t.gsub!("\205", "-")		# ISO-Latin1 horizontal elipses (0x85)
    t.gsub!("\221", "\'")	# ISO-Latin1 left single-quote
    t.gsub!("\222", "\'")	# ISO-Latin1 right single-quote
    t.gsub!("\223", "\"")	# ISO-Latin1 left double-quote
    t.gsub!("\224", "\"")	# ISO-Latin1 right double-quote
    t.gsub!("\225", "\*")	# ISO-Latin1 bullet
    t.gsub!("\226", "-")		# ISO-Latin1 en-dash (0x96)
    t.gsub!("\227", "-")		# ISO-Latin1 em-dash (0x97)
    t.gsub!("\230", "\'")  # single quote
    t.gsub!("\231", "\'")  # single quote
    t.gsub!("\233", ">")		# ISO-Latin1 single right angle quote
    t.gsub!("\234", "\"")  # Double quote
    t.gsub!("\235", "\"")  # Double quote
    t.gsub!("\240", " ")		# ISO-Latin1 nonbreaking space
    t.gsub!("\246", "\|")	# ISO-Latin1 broken vertical bar
    t.gsub!("\255", "")	  # ISO-Latin1 soft hyphen (0xAD)
    t.gsub!("\264", "\'")	# ISO-Latin1 spacing acute
    t.gsub!("\267", "\*")	# ISO-Latin1 middle dot (0xB7)
    t
  end
  
  unless method_defined? "ends_with?"
    # Snagged from Rails: http://api.rubyonrails.org/classes/ActiveSupport/CoreExtensions/String/StartsEndsWith.html#M000441
    def ends_with?(suffix)
      suffix = suffix.to_s
      self[-suffix.length, suffix.length] == suffix
    end
  end
  
  unless method_defined? "starts_with?"
    # Snagged from Rails: http://api.rubyonrails.org/classes/ActiveSupport/CoreExtensions/String/StartsEndsWith.html#M000441
    def starts_with?(prefix)
      prefix = prefix.to_s
      self[0, prefix.length] == prefix
    end
  end
  
end

class Array
  
  # Like Array.shift, but returns the array instead of removed the element.
  def remove_first_element
    self[1..self.size]
  end

  # Like Array.pop, but returns the array instead of removed the element.
  def remove_last_element
    self[0..self.size-2]
  end
  
end

class Object
  
  unless method_defined? "blank?"
    # Snagged from Rails: http://api.rubyonrails.org/classes/Object.html#M000265
    def blank?
      respond_to?(:empty?) ? empty? : !self
    end
  end
  
end