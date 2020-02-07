class CreateTasks < ActiveRecord::Migration[5.1]
  def change
    create_table :tasks do |t|
      t.references :project, index: true
      t.text :content, null: false
      t.boolean :done, default: false, null: false
      t.integer :position, unique: true

      t.timestamps
    end
  end
end
