class CreateDirections < ActiveRecord::Migration
  def change
    create_table :directions do |t|
      t.string :title
      t.text :body
      t.datetime :published_at

      t.timestamps
    end
  end
end
