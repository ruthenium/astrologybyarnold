class CreateSynastries < ActiveRecord::Migration
  def change
    create_table :synastries do |t|
      t.string :name
      t.string :date
      t.string :city
      t.string :name2
      t.string :date2
      t.string :city2

      t.timestamps
    end
  end
end
