# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

##########EVENT_TYPES################
sql= "INSERT INTO event_types VALUES
(0,'<Undefined>','#{Time.now}','#{Time.now}'),
(1,'Battle-Non-state actor overtakes territory','#{Time.now}','#{Time.now}'),
(2,'Riots/Protests','#{Time.now}','#{Time.now}'),
(3,'Non-violent activity by a conflict actor','#{Time.now}','#{Time.now}'),
(4,'Headquarters or base established','#{Time.now}','#{Time.now}'),
(5,'Non-violent transfer of territory','#{Time.now}','#{Time.now}'),
(6,'Battle-No change of territory','#{Time.now}','#{Time.now}'),
(7,'Violence against civilians','#{Time.now}','#{Time.now}'),
(8,'Remote violence','#{Time.now}','#{Time.now}'),
(9,'Battle-Government regains territory','#{Time.now}','#{Time.now}')"
puts "Event types loaded"
ActiveRecord::Base.connection.execute(sql)
##########COUNTRIES##################
sql ="INSERT INTO countries  VALUES
  (1,'<Undefined>','#{Time.now}','#{Time.now}'),
	(2,'Namibia','#{Time.now}','#{Time.now}'),
	(3,'Eritrea','#{Time.now}','#{Time.now}'),
	(4,'Libya','#{Time.now}','#{Time.now}'),
	(5,'Chad','#{Time.now}','#{Time.now}'),
	(6,'Madagascar','#{Time.now}','#{Time.now}'),
 	(7,'Algeria','#{Time.now}','#{Time.now}'),
	(8,'South Sudan','#{Time.now}','#{Time.now}'),
	(9,'Central African Republic','#{Time.now}','#{Time.now}'),
	(10,'Lesotho','#{Time.now}','#{Time.now}'),
	(11,'Cameroon','#{Time.now}','#{Time.now}'),
	(12,'Niger','#{Time.now}','#{Time.now}'),
	(13,'Zimbabwe','#{Time.now}','#{Time.now}'),
	(14,'Djibouti','#{Time.now}','#{Time.now}'),
	(15,'Republic of Congo','#{Time.now}','#{Time.now}'),
	(16,'Guinea-Bissau','#{Time.now}','#{Time.now}'),
	(17,'International','#{Time.now}','#{Time.now}'),
	(18,'Malawi','#{Time.now}','#{Time.now}'),
	(19,'Gambia','#{Time.now}','#{Time.now}'),
	(20,'Swaziland','#{Time.now}','#{Time.now}'),
	(21,'Liberia','#{Time.now}','#{Time.now}'),
	(22,'Nigeria','#{Time.now}','#{Time.now}'),
	(23,'Democratic Republic of Congo','#{Time.now}','#{Time.now}'),
	(24,'Guinea','#{Time.now}','#{Time.now}'),
	(25,'Togo','#{Time.now}','#{Time.now}'),
	(26,'Egypt','#{Time.now}','#{Time.now}'),
	(27,'Zambia','#{Time.now}','#{Time.now}'),
	(28,'Sierra Leone','#{Time.now}','#{Time.now}'),
	(29,'Kenya','#{Time.now}','#{Time.now}'),
	(30,'South Africa','#{Time.now}','#{Time.now}'),
	(31,'Somalia','#{Time.now}','#{Time.now}'),
	(32,'Equatorial Guinea','#{Time.now}','#{Time.now}'),
	(33,'Benin','#{Time.now}','#{Time.now}'),
	(34,'Uganda','#{Time.now}','#{Time.now}'),
	(35,'Mauritania','#{Time.now}','#{Time.now}'),
	(36,'Angola','#{Time.now}','#{Time.now}'),
	(37,'Burkina Faso','#{Time.now}','#{Time.now}'),
	(38,'Tunisia','#{Time.now}','#{Time.now}'),
	(39,'Ghana','#{Time.now}','#{Time.now}'),
	(40,'Ethiopia','#{Time.now}','#{Time.now}'),
	(41,'Gabon','#{Time.now}','#{Time.now}'),
	(42,'Ivory Coast','#{Time.now}','#{Time.now}'),
	(43,'Morocco','#{Time.now}','#{Time.now}'),
	(44,'Senegal','#{Time.now}','#{Time.now}'),
	(45,'Rwanda','#{Time.now}','#{Time.now}'),
	(46,'Burundi','#{Time.now}','#{Time.now}'),
	(47,'Mozambique','#{Time.now}','#{Time.now}'),
	(48,'Botswana','#{Time.now}','#{Time.now}'),
	(49,'Mali','#{Time.now}','#{Time.now}'),
	(50,'Sudan','#{Time.now}','#{Time.now}'),
	(51,'Tanzania','#{Time.now}','#{Time.now}')"
puts "Countries loaded"
ActiveRecord::Base.connection.execute(sql)
###########CITIES###################
puts "Reading File, standby"
str= File.absolute_path("db/ne_50m_populated_places_simple.json")
file = File.read(str)
size=  File.foreach(str).count
hash= ActiveSupport::JSON.decode(file)
i=0
j=0
hash["features"].each do |key, array|
  if(j % (size/100)==0)
    puts "Loading, please wait-#{((j/size.to_f)*100).round(0)}"
  end
	if((hash["features"][j]["properties"]["featurecla"] == "Admin-0 capital") && (!Country.where("name = ?",hash["features"][j]["properties"]["sov0name"]).blank?))
		geom= hash["features"][j]["geometry"].to_s.gsub('=>',':')
    sql = "INSERT INTO cities  VALUES
				(#{i},'#{hash["features"][j]["properties"]["name"].gsub("'","")}',ST_GeomFromGeoJSON('#{geom}'),(SELECT id FROM countries WHERE name = '#{hash["features"][j]["properties"]["sov0name"]}'), '#{Time.now}','#{Time.now}')"

    ActiveRecord::Base.connection.execute(sql)
			i=i+1
  end
	#puts "Loading...#{i}%"
	j=j+1
end
puts "Cities loaded"
##########Full-text search##########
sql= "ALTER TABLE conflicts ADD COLUMN tsv tsvector;"
ActiveRecord::Base.connection.execute(sql)
##########CONFLICTS#################
puts "Reading File, standby"
str= File.absolute_path("db/ACLED_GIS_2015.json")
file = File.read(str)
#size=  File.foreach(str).count
size=5000
hash= ActiveSupport::JSON.decode(file)
i=0

hash["features"].each do |key, array|
	if(i % (size/100)==0)
		puts "Loading, please wait-#{((i/size.to_f)*100).round(0)}"
	end
        geom= hash["features"][i]["geometry"].to_s.gsub('=>',':')
        sql = "INSERT INTO conflicts  VALUES
        (#{i},#{hash["features"][i]["properties"]["GWNO"]},'#{hash["features"][i]["properties"]["EVENT_ID_C"]}',#{hash["features"][i]["properties"]["EVENT_ID_N"]},'#{hash["features"][i]["properties"]["EVENT_DATE"]}',#{hash["features"][i]["properties"]["YEAR"]},(SELECT id FROM event_types WHERE type_name= '#{hash["features"][i]["properties"]["EVENT_TYPE"]}'),(SELECT id FROM countries WHERE name= '#{hash["features"][i]["properties"]["COUNTRY"]}'),'#{hash["features"][i]["properties"]["NOTES"].to_s.gsub("'", "").gsub("\n"," ").gsub(/"/, '').gsub("\t"," ")}',#{hash["features"][i]["properties"]["FATALITIES"]},#{hash["features"][i]["properties"]["INTER1"]},#{hash["features"][i]["properties"]["INTER2"]},'#{hash["features"][i]["properties"]["ACTOR1"].to_s.gsub(":","-")}','#{hash["features"][i]["properties"]["ACTOR2"]}',#{hash["features"][i]["properties"]["INTERACTIO"]}, ST_GeomFromGeoJSON('#{geom}'),'#{Time.now}','#{Time.now}')"

  ActiveRecord::Base.connection.execute(sql)
  #puts "Loading...#{i}%"
  i=i+1
  if(i>(size+3000))
    break
  end
end
puts "Conflicts loaded"
########Full-text search####################
sql= "UPDATE conflicts SET tsv= to_tsvector(notes||' '||actor1||' '||actor2);"
ActiveRecord::Base.connection.execute(sql)

sql= "CREATE INDEX tsv_GIN ON conflicts USING gin(tsv);"
ActiveRecord::Base.connection.execute(sql)

