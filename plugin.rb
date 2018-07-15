# name: 	LNSHighlightJS
# about: 	Patch HighlightJs module to provide applescript:// links
# version: 	0.2
# authors: 	Mark Alldritt
# url:		https://github.com/alldritt/discourse-LNSHighlightJS

#
#  This is a hack.  Discourse uses the minified version of highlight.js to perform code highlighting.  This plugin hacks the contents
#  of highlight.js to introduce additional HTML for AppleScript code snippets.  This is *extreamly* fragile in that any significant
#  change to highlight.js will render this code in operable (it has already happened).
#
#  To fix this, you have to find the part of the highlight(...) function within highlight.js which returns the highlighted HTML
#  string, and insert the additional HTML code.  This can only be done by looking at the source version on the HighlighJS GitHub
#  page, and then find the corresponding code in the minified version.
#
#

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
	  matchCode = ";return{r:B,value:y,language:e,top:"
	  newCode = ";if(e==\"applescript\"){y=\"<p><strong><a class=\\\"hljs-title no-track-link\\\" onclick=\\\"window.open('sdapplescript://com.apple.scriptdebugger?action=new&script=\"+encodeURIComponent(t).replace(/\\\"/g,\"%22\").replace(/'/g,\"%27\")+\"','_self');return 0;\\\">Open in Script Debugger</a></strong></p>\"+y;}"
	  
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

