# name: 	LNSHighlightJS
# about: 	Patch HighlightJs module to provide applescript:// links
# version: 	0.1
# authors: 	Mark Alldritt
# url:		https://github.com/alldritt/discourse-LNSHighlightJS


after_initialize do

  puts("LNSHighlightJS.a")
  puts("LNSHighlightJS.a.1: " + self.class.name);
  

end

module ::HighlightJs
#    def self.languages
#	  Dir.glob(File.dirname(__FILE__) << "/../../lib/assets/lang/*.js").map do |path|
#	    File.basename(path)[0..-4]
#	  end
#   end

    def self.bundle(langs)
	  path = File.dirname(__FILE__) << "/../../lib/highlight_js/assets/"

 	  result = File.read(path + "highlight.js")
	
	  # Patch the contents of highlight.js (now in result) to incldue our code...
	  matchCode = "return{"
	  newCode = "if (name == \"applescript\") {
  result = \"<p><strong><a class=\\\"hljs-title\\\" href=\\\"sdapplescript://com.apple.scriptdebugger?action=new&script=\" + encodeURIComponent(value) + \"\\\">Open in Script Debugger</a></strong></p>\" + result;
}"
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
