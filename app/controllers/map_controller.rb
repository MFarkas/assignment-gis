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
    puts @geojson
    #@geojson= @conflicts.first.build_geojson
  end
  def search

    render :show
  end
end
