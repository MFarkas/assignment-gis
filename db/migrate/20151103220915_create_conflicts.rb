class CreateConflicts < ActiveRecord::Migration
  def change
    create_table :conflicts do |t|
      t.integer   :gwno
      t.string    :event_id_c
      t.integer   :event_id_n
      t.datetime  :event_date
      t.integer   :year
      t.string    :event_type
      t.string    :country
      t.string    :notes
      t.integer   :fatalities
      #t.column    :geometry, :geometry
      t.geometry :geometry
      t.timestamps null: false
    end
  end
end
