class CreateConflicts < ActiveRecord::Migration
  def change
    create_table :conflicts do |t|
      t.integer   :gwno
      t.string    :event_id_c
      t.integer   :event_id_n
      t.datetime  :event_date
      t.integer   :year
      t.integer   :event_type_id
      t.integer   :country_id
      t.string    :notes
      t.integer   :fatalities
      t.integer   :inter1
      t.integer   :inter2
      t.string    :actor1
      t.string    :actor2
      t.integer   :interaction
      #t.column    :geometry, :geometry
      t.geometry :geometry
      t.timestamps null: false
    end
  end
end
