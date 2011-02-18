ActiveRecord::Schema.define(:version => 2) do

  create_table :comments, :force => true do |t|
    t.belongs_to :photo
    t.string     :author
    t.text       :body
    t.timestamps
  end

  create_table :photos, :force => true do |t|
    t.string     :title
    t.text       :description
    t.belongs_to :camera
    t.timestamps
  end

  create_table :cameras, :force => true do |t|
    t.string     :make
    t.string     :model
    t.belongs_to :user
  end

  create_table :users, :force => true do |t|
    t.string :name
  end



end
