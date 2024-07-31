class AddInfoToTrainStation < ActiveRecord::Migration[7.0]
  def change
    add_column :train_stations, :country, :string
    add_column :train_stations, :operator, :string
  end
end
