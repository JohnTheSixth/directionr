class AddShortUrlColumnToDirections < ActiveRecord::Migration
  def change
  	add_column :directions, :short_url, :string, :limit => 255
  end
end
