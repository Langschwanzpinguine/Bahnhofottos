class RenameColumn < ActiveRecord::Migration[7.0]
  def change
    rename_column :train_stations, :type, :station_type
  end
end
