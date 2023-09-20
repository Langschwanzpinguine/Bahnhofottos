class CreateTrainStations < ActiveRecord::Migration[7.0]
  def change
    create_table :train_stations do |t|
      t.string :osm_id, null: false
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
    add_index :train_stations, [:osm_id, :user_id], unique: true
  end
end
