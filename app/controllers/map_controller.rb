class MapController < ApplicationController

  def show
    @conflicts= Conflict.where("id<5")
    @geojson= []
    @geojson << '['
    @conflicts.each.with_index do |c, index|
      @geojson << JSON[c.build_geojson.to_s.gsub('\n', '')]
      if(index < (@conflicts.size-1))
        @geojson<< ','
      end
    end
    @geojson << ']'
    @countries= Country.all
    @event_types= EventType.all
  end
  def search
    @countries= Country.all
    @event_types= EventType.all
    @conflicts= Conflict.all
    if(params[:event][:kwds]!= "")
      @conflicts= @conflicts.where("tsv @@ plainto_tsquery(?)",params[:event][:kwds])
    end
    if(params[:event][:type_id]!= "0")
      @conflicts= @conflicts.where("EVENT_TYPE_ID = ?",params[:event][:type_id])
    end
    if(params[:event][:country_id]!= "1")
      @conflicts= @conflicts.where("COUNTRY_ID = ?",params[:event][:country_id])
    end
    if(params[:event][:actor1]!= "0")
      @conflicts= @conflicts.where("INTER1 = ?",params[:event][:actor1])
    end
    if(params[:event][:actor2]!= "0")
      @conflicts= @conflicts.where("INTER2 = ?",params[:event][:actor2])
    end
    if(params[:event][:fatals]!="")
      @conflicts= @conflicts.where("FATALITIES #{params[:event][:fatals][0]} ?",params[:event][:fatals][1..-1])
    end
    if((params[:event][:date_stop]!="") && (params[:event][:date_start]!=""))
      start= params[:event][:date_start]+ " 00:00:00"
      stop=  params[:event][:date_stop] + " 00:00:00"
      @conflicts= @conflicts.where("event_date between ? and ?",start,stop)
    end
    @geojson= []
    @geojson << '['
    @conflicts.includes(:country).each.with_index do |c, index|
      @geojson << JSON[c.build_geojson.to_s.gsub('\n', '')]
      if(index < (@conflicts.size-1))
        @geojson<< ','
      end
    end
    @geojson << ']'
    render :show
  end

  def show_related_conflicts
    @countries= Country.all
    @event_types= EventType.all

    selected_conflict= Conflict.find(params[:id])
    sc_json= JSON[selected_conflict.build_geojson]
    @center= { :y => sc_json["geometry"]["coordinates"][0], :x => sc_json["geometry"]["coordinates"][1] }
    @conflicts= Conflict.all.where("ST_DWithin(geometry, ?,0.5)",selected_conflict.geometry)
    #,selected_conflict.event_date,
    #28>abs(EXTRACT( DAY FROM (event_date- ?)))) AND
    @geojson= []
    @geojson << '['
    @conflicts.each.with_index do |c, index|
      @geojson << JSON[c.build_geojson.to_s.gsub('\n', '')]
      if(index < (@conflicts.size-1))
        @geojson<< ','
      end
    end
    @geojson << ']'
    @countries= Country.all
    @event_types= EventType.all
    render :show
  end
end
