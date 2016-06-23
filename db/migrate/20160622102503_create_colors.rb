class CreateColors < ActiveRecord::Migration
  def change
    create_table :colors do |t|

      t.string :origin
      t.string :hex
      t.string :rgb
      t.string :hsv
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
