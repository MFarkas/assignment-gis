class Conflict < ActiveRecord::Base

  def build_geojson
    geojson=  '{
    "type": "Feature",
    "geometry": '+RGeo::GeoJSON.encode(self.geometry).to_s.gsub('=>' , ':') +',
    "properties": {
      "title": "'+self.event_type+'",
      "description": "'+self.notes.gsub('\n',' ')+'",
      "event_date": "'+self.event_date.to_date.to_s+'",
      "country": "'+self.country+'",
      "fatalities": "'+self.fatalities.to_s+'",
      "marker-color": "#fc4353",
      "marker-size": "large",
      "marker-symbol": "danger"
    }
  }'
  end
end
