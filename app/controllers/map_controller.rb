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
  end
  def search
    @conflicts= Conflict.all
    if(params[:event][:country]!= "")
      @conflicts= @conflicts.where("COUNTRY LIKE '#{params[:event][:country]}'")
    end
    if(params[:event][:fatals]!="")
      @conflicts= @conflicts.where("FATALITIES #{params[:event][:fatals][0]} '#{params[:event][:fatals][1..-1]}'")
    end
    if((params[:event][:date_stop]!="") && (params[:event][:date_start]!=""))
      start= params[:event][:date_start]+ " 00:00:00"
      stop=  params[:event][:date_stop] + " 00:00:00"
      @conflicts= @conflicts.where("event_date between '#{start}' and '#{stop}'")
    end
    @geojson= []
    @geojson << '['
    @conflicts.each.with_index do |c, index|
      @geojson << JSON[c.build_geojson.to_s.gsub('\n', '')]
      if(index < (@conflicts.size-1))
        @geojson<< ','
      end
    end
    @geojson << ']'
    render :show
  end
end
