class Comment < ActiveRecord::Base
  belongs_to :commentable, :polymorphic => true
  belongs_to :blog

  default_scope :order => 'created_at ASC'

  validates :comment, :presence => true
end
