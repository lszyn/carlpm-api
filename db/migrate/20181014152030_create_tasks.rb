class CreateTasks < ActiveRecord::Migration[5.1]
  def change
    create_table :tasks do |t|
      t.string :name
      t.boolean :done, default: false
      t.date :deadline
      t.references :project, foreign_key: true

      t.timestamps
    end
  end
end
