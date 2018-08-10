# =>BackupScript-2.0 : Revamped simple ruby script to remotely copy and erase files - twitter to notify the user of process
# => Author: Fadini
# => 9/10/2018

require 'twitter'

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = "CONSUMER_KEY_HERE"
  config.consumer_secret     = "CONSUMER_SECRET_HERE"
  config.access_token        = "ACCESS_TOKEN_HERE"
  config.access_token_secret = "ACCESS_TOKEN_SECRET_HERE"
end

randNUm = rand(1...500000)


#PINGS TO SEE IF IT CAN CONNECT TO LOCATION
startCommand = 'ping -c 2 "IPADDRESS"'

pingTest = system(startCommand)

if pingTest == true
	#twitter has a stupid thing where consecuitive tweets cannot be the same, this avoids this
	#by throwing a random number inside the tweet

	client.update("Backup has started.. @YOUR_TWITTER_HANDLE 
		#{randNUm}")

	puts "Connecting to host and copying files."
	pid0 = Kernel.spawn('scp -r USERNAME@IPADDRESS:REMOTE_LOCATION "LOCAL_LOCATION"')
	Process.wait pid0
	
	pid1 = Kernel.spawn('ssh USERNAME@IPADDRESS rm -rf "REMOTE_LOCATION"')
	Process.wait pid1
	
	puts "Deleting copied files"
	pid2 = Kernel.spawn('ssh USERNAME@IPADDRESS mkdir "REMOTE_LOCATION"')
	Process.wait pid2
	puts "Folder cleaned up"

	client.update("Backup has completed... @YOUR_TWITTER_HANDLE
		#{randNUm}")

else
	client.update("There was a problem attempting a backup... probably not on the same network or its turned off @YOUR_TWITTER_HANDLE
		
		Please run it manually...

		#{randNUm}")
end
