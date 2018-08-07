class CreateUserConfigs < ActiveRecord::Migration
  def change
    create_table :user_configs do |t|
      t.string :base_id
      t.string :employee_id
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
