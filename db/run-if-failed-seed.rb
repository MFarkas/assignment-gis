########Full-text search####################
sql= "UPDATE conflicts SET tsv= to_tsvector(notes||' '||actor1||' '||actor2);"
ActiveRecord::Base.connection.execute(sql)

sql= "CREATE INDEX tsv_GIN ON conflicts USING gin(tsv);"
ActiveRecord::Base.connection.execute(sql)
###########INDEXES############################

sql= "CREATE UNIQUE INDEX fatalities_idx ON conflicts (fatalities);"
ActiveRecord::Base.connection.execute(sql)

sql= "CREATE UNIQUE INDEX event_date_idx ON conflicts (event_date);"
ActiveRecord::Base.connection.execute(sql)

sql= "CREATE UNIQUE INDEX country_id_idx ON conflicts (country_id);"
ActiveRecord::Base.connection.execute(sql)

sql= "CREATE UNIQUE INDEX event_type_idx ON conflicts (event_type);"
ActiveRecord::Base.connection.execute(sql)

sql= "CREATE UNIQUE INDEX inter1_idx ON conflicts (inter1);"
ActiveRecord::Base.connection.execute(sql)

sql= "CREATE UNIQUE INDEX inter2_idx ON conflicts (inter2);"
ActiveRecord::Base.connection.execute(sql)
