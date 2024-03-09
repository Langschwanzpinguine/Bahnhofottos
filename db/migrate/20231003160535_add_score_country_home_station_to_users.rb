class AddScoreCountryHomeStationToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :score, :integer
    add_column :users, :country, :string
    add_column :users, :home_station, :integer
  end
end
