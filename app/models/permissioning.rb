module Permissioning

  extend ActiveSupport::Concern

  included do

    has_many :permissions, :dependent => :destroy
    accepts_nested_attributes_for :permissions
    before_update :permission_sync

    class_attribute :_permissible_fields
    class_attribute :_default_permission

  end

  module ClassMethods

    def permissible_fields(fields = [])
      self._permissible_fields = Array.new(fields).flatten
    end

    def my_default_permission_field(value)
      self._default_permission = value
    end

  end

  module InstanceMethods

    def permissions_with_my_default
      default = my_default_permission
      permissions.select{|x| x.permission_type == default}
    end

    def my_default_permission
      @my_default_permission ||= send(self.class._default_permission).try(:to_sym)
    end

    def profile_permissions
      if @permission_objects.nil?
        dbp = db_permissions
        @permission_objects = self.class._permissible_fields.map do |f|
          dbp[f] || permissions.build(:permission_field => f, :permission_type => my_default_permission)
        end
      end
      @permission_objects
    end

    def db_permissions
      @db_permissions ||= permissions.index_by{|p| p.permission_field }
    end

    def all_field_permissions
      if @field_permissions.nil?
        @field_permissions = Hash.new(my_default_permission)
        dbp = db_permissions
        self.class._permissible_fields.each do |f|
          @field_permissions[f] = dbp[f].permission_type.to_sym if dbp[f]
        end
      end
      return @field_permissions
    end

    def fetch_permission_for(field)
      all_field_permissions[field]
    end

    def can_see_field(field, profile)
      field_permission = fetch_permission_for(field)
      return true if field_permission == :Everyone ||
                     (field_permission == :Myself && is_me?(profile)) ||
                      (field_permission == :Friends && friend_of?(profile))

#      return !field_permission ||
#             field.blank? ||
#             field_permission.everyone? ||
#             (field_permission.myself? && is_me?(profile) ||
#             (field_permission.friends? && friend_of?(profile)))

    end

    private

    def permission_sync
      return true if permissions.nil?
      permissions.delete permissions_with_my_default
    end

  end

end