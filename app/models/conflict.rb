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
      "actor1": "'+self.actor1.to_s+'",
      "actor2": "'+self.actor2.to_s+'",
      "marker-color": "#fc4353",
      "marker-size": "large",
      "marker-symbol": "danger"
    }
  }'
  end

  def self.search(attributes)

  end
end
