#!/usr/bin/env ruby
require 'open-uri'
require 'tempfile'

DEBUG = false
def log(s)
  puts s if DEBUG
end

query = ARGV.shift
exit(1) if query.nil?
query = query.gsub(' ','+')
SEARCH = "http://ws.spotify.com/search/1/track.json?q=%s"
log "search for #{query}"

def call_apple_script(track_name)
  log "call apple script #{track_name}"
  file = Tempfile.new('foo')
  file.write <<-END
tell application "Spotify"
  play track "#{track_name}"
end tell
  END
  file.close
  system("osascript #{file.path}")
  file.delete
end

open(SEARCH % query) do |content|
  data = content.readlines.join
  log "got data"
  begin
    match = data.match /(spotify:track:.+?)"/
    url = match[1]
    log "found #{url}"
    puts "Playing song"
    call_apple_script(url)
  rescue NoMethodError
    puts "No song found"
  end
end