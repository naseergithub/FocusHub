class CreateTasks < ActiveRecord::Migration[7.2]
  def change
    create_table :tasks do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.datetime :due_date, null: false
      t.integer :status, null: false, default: 0
      t.string :category, null: false, default: "Personal"
      t.references :user, foreign_key: true, null: false
      t.timestamps
    end
    add_index :tasks, :title
    add_index :tasks, :category
    add_index :tasks, :status
    add_index :tasks, :due_date
  end
end
