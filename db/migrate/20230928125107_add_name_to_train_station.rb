class AddNameToTrainStation < ActiveRecord::Migration[7.0]
  def change
    add_column :train_stations, :name, :string
  end
end
