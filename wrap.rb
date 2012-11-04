#!/usr/bin/env ruby
TMP_FILE_NAME = ".findspotify"
script_content = File.read("run.rb")

script = <<-END
RUBY_TEMPFILE=#{TMP_FILE_NAME}
cat > $RUBY_TEMPFILE <<DELIM
#{script_content}
DELIM
/usr/bin/env ruby $RUBY_TEMPFILE {query}
rm $RUBY_TEMPFILE
END

File.open("extension","w").write(script)