ActiveRecord::Schema.define do
  self.verbose = false

  create_table :likes, :force => true do |t|
    t.integer :user_id
    t.integer :video_id
    t.string :foobar

    t.timestamps null: false
  end

end
