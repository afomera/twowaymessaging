class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :to
      t.string :from
      t.string :status
      t.string :body
      t.string :message_sid
      t.string :account_sid
      t.string :messaging_service_sid
      t.string :direction
      t.references :user, index: true, foreign_key: true
      t.references :conversation, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
