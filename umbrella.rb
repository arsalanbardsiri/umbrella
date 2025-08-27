#https://maps.googleapis.com/maps/api/geocode/json?address=YOUR_ADDRESS&key=YOUR_API_KEY
#https://api.pirateweather.net/forecast/{api_key}/{lat},{lon}
=begin
========================================
    Will you need an umbrella today?    
========================================

Where are you?
westlake village
Checking the weather at westlake village....
Your coordinates are 34.1466467, -118.8073729.
It is currently 69.27°F.
Next hour: Clear for the hour.
You probably won't need an umbrella.


========================================
    Will you need an umbrella today?    
========================================

Where are you?
etah
Checking the weather at etah....
Your coordinates are 27.5625106, 78.6654148.
It is currently 87.91°F.
Next hour: Possible drizzle for the hour.
In 1 hours, there is a 26% chance of precipitation.
In 2 hours, there is a 37% chance of precipitation.
In 3 hours, there is a 37% chance of precipitation.
In 4 hours, there is a 37% chance of precipitation.
In 5 hours, there is a 37% chance of precipitation.
In 6 hours, there is a 30% chance of precipitation.
In 7 hours, there is a 23% chance of precipitation.
In 8 hours, there is a 17% chance of precipitation.
In 9 hours, there is a 17% chance of precipitation.
In 10 hours, there is a 17% chance of precipitation.
In 11 hours, there is a 17% chance of precipitation.
In 12 hours, there is a 18% chance of precipitation.
You might want to take an umbrella!
=end
require "http"
require "json"
require "dotenv/load"
gmaps_key = ENV.fetch("GMAPS_KEY")
weather_key = ENV.fetch("PIRATE_WEATHER_KEY")

puts "
========================================
    Will you need an umbrella today?    
========================================
"
puts "Where are you?"

#Google Maps
address = gets.chomp
puts "Checking the weather at #{address}...."
gmaps_geo = "https://maps.googleapis.com/maps/api/geocode/json?address=#{address}&key=#{gmaps_key}"
raw_geo = HTTP.get(gmaps_geo)
formated_geo = JSON.parse(raw_geo)
list_data = formated_geo.fetch("results")
address_lat_lng = list_data.first["geometry"].fetch("location")
list_lat_lng = address_lat_lng.map{|k,v| v}
puts "Your coordinates are #{list_lat_lng[0]}, #{list_lat_lng[1]}."

#Weather
weather_api = "https://api.pirateweather.net/forecast/#{weather_key}/#{list_lat_lng[0]},#{list_lat_lng[1]}"
raw_weather = HTTP.get(weather_api)
formated_weather = JSON.parse(raw_weather)
current_weather = formated_weather["currently"]["temperature"]
summary =  formated_weather["hourly"]["summary"]

puts "It is currently #{current_weather}°F.."
puts "Next hour: #{summary}"
rain_flag = formated_weather["hourly"]["data"].first.fetch("precipType")

json_percip = formated_weather["hourly"]["data"][1..12]
precip_probability = json_percip.map {|n| n.fetch("precipProbability")}

if rain_flag == "rain"
  precip_probability.each do |element|
    puts "In #{precip_probability.index(element)+1} hours, there is a #{element*100}% chance of precipitation."
  end
else
  puts "You probably won't need an umbrella."
end
