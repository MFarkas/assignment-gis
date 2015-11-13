# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
str= File.absolute_path("db/ACLED_GIS_2015.json")
file = File.read(str)
hash= ActiveSupport::JSON.decode(file)
i=0
hash["features"].each do |key, array|
        geom= hash["features"][i]["geometry"].to_s.gsub('=>',':')
        sql = "INSERT INTO conflicts  VALUES
        (#{i},#{hash["features"][i]["properties"]["GWNO"]},'#{hash["features"][i]["properties"]["EVENT_ID_C"]}',#{hash["features"][i]["properties"]["EVENT_ID_N"]},'#{hash["features"][i]["properties"]["EVENT_DATE"]}',#{hash["features"][i]["properties"]["YEAR"]},'#{hash["features"][i]["properties"]["EVENT_TYPE"]}','#{hash["features"][i]["properties"]["COUNTRY"]}','#{hash["features"][i]["properties"]["NOTES"].to_s.gsub("'", "").gsub("\n"," ").gsub(/"/, '')}',#{hash["features"][i]["properties"]["FATALITIES"]}, ST_GeomFromGeoJSON('#{geom}'),'#{Time.now}','#{Time.now}')"

  ActiveRecord::Base.connection.execute(sql)
  #puts "Loading...#{i}%"
  i=i+1
end

