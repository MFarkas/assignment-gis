class Conflict < ActiveRecord::Base
belongs_to :country
belongs_to :event_type
  def build_geojson
    geojson=  '{
    "type": "Feature",
    "geometry": '+RGeo::GeoJSON.encode(self.geometry).to_s.gsub('=>' , ':') +',
    "properties": {
      "title": "'+self.event_type.type_name+'",
      "description": "'+self.notes.gsub('\n',' ').gsub('-',',').gsub(';',',')+'",
      "event_date": "'+self.event_date.to_date.to_s+'",
      "country": "'+self.country.name+'",
      "fatalities": "'+self.fatalities.to_s+'",
      "locfromcap": "'+self.locfromcap+'",
      "id": "'+self.id.to_s+'",
      "actor1": "'+self.actor1.to_s+'",
      "actor2": "'+self.actor2.to_s+'",
      "marker-color": "#fc4353",
      "marker-size": "'+self.size(self.fatalities)+'",
      "marker-symbol": "'+self.icon(self.event_type.id)+'"
    }
  }'
  end

def size(fatalities)
  # Return a case.
  return case fatalities
           when 0..10 then "small"
           when 10..50 then "medium"
           when 50..999999 then "large"
           else "Invalid"
         end
  end

def icon(event_type)
  # Return a case.
  return case event_type
           when 1,5,6,9 then "embassy"
           when 4 then "building"
           when 2 then "triangle"
           when 3 then "circle"
           when 7,8 then "danger"
           else "Invalid"
         end
  end
end
