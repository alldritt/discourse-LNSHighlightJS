# name: 	LNSHighlightJS
# about: 	Patch HighlightJs module to provide applescript:// links
# version: 	0.1
# authors: 	Mark Alldritt
# url:		https://github.com/alldritt/discourse-LNSHighlightJS


after_initialize do

  #puts("LNSHighlightJS.a")
  
  module ::HighlightJs
#    def self.languages
#	  Dir.glob(File.dirname(__FILE__) << "/../../lib/highlight_js/assets/lang/*.js").map do |path|
#	    File.basename(path)[0..-4]
#	  end
#   end

    def self.bundle(langs)
      warn("LNSHighlightJS.HighlightJs.bundle");

	  path = File.dirname(__FILE__) << "/../../lib/highlight_js/assets/"

 	  result = File.read(path + "highlight.js")
	
	  # Patch the contents of highlight.js (now in result) to incldue our code.  Note that this version of
	  # highlight.js has been minified and the variable names have been changed:
	  #
	  #		e = name
	  #		L = result
	  #		t = value
	  #
	  matchCode = "return{"
	  newCode = "if(e==\"applescript\"){L=\"<p><strong><a class=\\\"hljs-title no-track-link\\\" onclick='window.open(\\\"sdapplescript://com.apple.scriptdebugger?action=new&script=\"+encodeURIComponent(t).replace(\"\\\"\",\"%34\")+\"\\\",\\\"_self\\\");return 0;'>Open in Script Debugger</a></strong></p>\"+L;}"
	  
	  result = result.sub(matchCode, newCode + matchCode)

	  langs.each do |lang|
	    begin
		  result << "\n" << File.read(path + "lang/#{lang}.js")
	    rescue Errno::ENOENT
		  # no file, don't care
	    end
	  end

	  result
    end

#    def self.version(lang_string)
#	  (@lang_string_cache ||= {})[lang_string] ||=
#	    Digest::SHA1.hexdigest(bundle lang_string.split("|"))
#    end

#    def self.path
#	  "/highlight-js/#{Discourse.current_hostname}/#{version SiteSetting.highlighted_languages}.js"
#    end
  end
end

