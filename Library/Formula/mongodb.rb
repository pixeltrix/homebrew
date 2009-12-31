require 'formula'
require 'hardware'

class Mongodb <Formula
  homepage 'http://www.mongodb.org/'

  aka :mongo

  if Hardware.is_64_bit? and not ARGV.include? '--32bit'
    url 'http://downloads.mongodb.org/osx/mongodb-osx-x86_64-1.2.1.tgz'
    md5 'b5ac0642a6e370b0c4bd24157445c96e'
    version '1.2.1-x86_64'
  else
    url 'http://downloads.mongodb.org/osx/mongodb-osx-i386-1.2.1.tgz'
    md5 'f7707bb5756380a580c08fc11f0a351a'
    version '1.2.1-i386'
  end

  def skip_clean? path
    true
  end

  def install
    # Copy the prebuilt binaries to prefix
    system "cp -prv * #{prefix}"

    # Create the data and log directories under /var
    (var+'mongodb').mkpath
    (var+'log/mongodb').mkpath

    # Write the configuration files and launchd script
    (prefix+'mongod.conf').write mongodb_conf
    (prefix+'org.mongodb.mongod.plist').write startup_plist
  end

  def caveats; <<-EOS
You can enable mongodb to automatically load on login with:
    launchctl load -w #{prefix}/org.mongodb.mongod.plist

Or start it manually:
    mongod run --config #{prefix}/mongod.conf
EOS
  end

  def mongodb_conf
    return <<-EOS
# Store data in #{var}/mongodb instead of the default /data/db
dbpath = #{var}/mongodb

# Only accept local connections
bind_ip = 127.0.0.1
EOS
  end

  def startup_plist
    return <<-EOS
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>org.mongodb.mongod</string>
  <key>ProgramArguments</key>
  <array>
    <string>#{bin}/mongod</string>
    <string>run</string>
    <string>--config</string>
    <string>#{prefix}/mongod.conf</string>
  </array>
  <key>RunAtLoad</key>
  <true/>
  <key>KeepAlive</key>
  <true/>
  <key>UserName</key>
  <string>#{`whoami`}</string>
  <key>WorkingDirectory</key>
  <string>#{HOMEBREW_PREFIX}</string>
  <key>StandardErrorPath</key>
  <string>#{var}/log/mongodb/output.log</string>
  <key>StandardOutPath</key>
  <string>#{var}/log/mongodb/output.log</string>
</dict>
</plist>
EOS
  end
end
