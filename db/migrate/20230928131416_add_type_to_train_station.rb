class AddTypeToTrainStation < ActiveRecord::Migration[7.0]
  def change
    add_column :train_stations, :type, :string
  end
end
