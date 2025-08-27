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
=end
require "http"
require "json"
require "dotenv/load"
gmaps_key = ENV.fetch("GMAPS_KEY")
weather_key = ENV.fetch("PIRATE_WEATHER_KEY")

#Google Maps
address = "westlake village"
gmaps_geo = "https://maps.googleapis.com/maps/api/geocode/json?address=#{address}&key=#{gmaps_key}"
raw_geo = HTTP.get(gmaps_geo)
formated_geo = JSON.parse(raw_geo)
list_data = formated_geo.fetch("results")
address_lat_lng = list_data.first["geometry"].fetch("location")
list_lat_lng = address_lat_lng.map{|k,v| v}

#Weather
weather_api = "https://api.pirateweather.net/forecast/#{weather_key}/#{list_lat_lng[0]},#{list_lat_lng[1]}"
raw_weather = HTTP.get(weather_api)
formated_weather = JSON.parse(raw_weather)
pp formated_weather["minutely"]["summary"]
pp formated_weather["currently"]["temperature"]
