require 'spec_helper'

describe "MonkeyPatches" do
  
  it "ellipsizes" do
    "short thing".ellipsize.should == "short thing"
    "0123456789ABCDEFGHIJ".ellipsize(:max => 9).should == "0123...GHIJ"
    "0123456789ABCDEFGHIJ".ellipsize(:max => 10, :delimiter => "|").should == "01234|FGHIJ"
  end

  it "permalinkifies" do
    "zeke".permalinkify.should == "zeke"
    "Dog Breath".permalinkify.should == "dog-breath"
    "Shit for @@@ BRAINS!".permalinkify.should == "shit-for-brains"
    " A REal Doozi\"e?  \' ".permalinkify.should == "a-real-doozie"
  end

  it "prepends http only if needed" do
    "".add_http.should == ""
    "dog".add_http.should == "http://dog"
    "http://dog.com".add_http.should == "http://dog.com"
    "https://dog.com".add_http.should == "https://dog.com"
  end

  it "removes http and www" do
    "http://shitstorm.com".remove_http_and_www.should == "shitstorm.com"
    "http://www.google.com".remove_http_and_www.should == "google.com"
    "http://wwwxyz.com".remove_http_and_www.should == "wwwxyz.com"
    "www.abc.com".remove_http_and_www.should == "abc.com"
    "https://secure.com".remove_http_and_www.should == "secure.com"
    "https://www.dubsecure.com".remove_http_and_www.should == "dubsecure.com"
  end

  it "truncates by words" do
    #012345678901234567890123456789012345678901234567890123456789
    "this is short. should be fine.".truncate_preserving_words.should == "this is short. should be fine."
    "this is longer. will cut if we leave the default max_chars in place".truncate_preserving_words.should == "this is longer. will cut if we leave the default max_chars ..."
    "this will get cut".truncate_preserving_words(:max_chars => 15, :end_string => "..").should == "this will get .."
    "this doesn't have too many words".truncate_preserving_words(:max_words => 10).should == "this doesn't have too many words"
    "this has too many words".truncate_preserving_words(:max_words => 3).should == "this has too ..."
  end

  it "replaces wonky characters with ascii" do
    "\“Ulysses\”".replace_wonky_characters_with_ascii.should == "\"Ulysses\""
    "We ‘are’ single".replace_wonky_characters_with_ascii.should == "We 'are' single"
    "We ‘are’ single".replace_wonky_characters_with_ascii.should == "We 'are' single"
  end
  
  it "strips tags" do
    "whoa".strip_tags.should == "whoa"
    "<a href='http://shitstorm.com'>click</a>".strip_tags.should == "click"
    "this is <b>bold</b> and <em>emphatic</em>".strip_tags.should == "this is bold and emphatic"
  end
  
  it "nixes" do
    "this thing that thing".nix("thing").should == "this  that thing"
  end

  it "nixes globally" do
    "this thing that thing".gnix("thing").should == "this  that "
  end
  
  it "pollutes and sanitizes" do
    s = "test"
    s.pollute.should == "t^--^--^e^--^--^s^--^--^t^--^--^"
    s.sanitize.should == s
    s.pollute.sanitize.should == s
    
    s.pollute("-").should == "t-e-s-t-"
    s.sanitize("-").should == s
    s.pollute("-").sanitize("-").should == s
  end
  
  # Array specs

  it "removes first element" do
    %w(1 2 3).remove_first_element.should == %w(2 3)
  end

  it "removes last element" do
    %w(1 2 3).remove_last_element.should == %w(1 2)
  end


end
