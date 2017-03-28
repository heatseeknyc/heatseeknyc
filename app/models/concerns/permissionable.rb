module Permissionable
  module InstanceMethods
    def able_to_see_tenant(tenant)
      self.id == tenant.id ||
      self.super_user? ||
      self.admin_or_more_powerful? ||
      self.advocate_or_more_powerful? && self.collaborators.include?(tenant)
    end

    def able_to_see_non_tenant(non_tenant)
      self.id == non_tenant.id ||
      self.super_user? ||
      non_tenant.advocate? && self.admin_or_more_powerful?
    end

    def advocate_or_more_powerful?
      permissions_at_or_more_powerful_than(:advocate)
    end

    def admin_or_more_powerful?
      permissions_at_or_more_powerful_than(:admin)
    end

    def team_member_or_more_powerful?
      permissions_at_or_more_powerful_than(:team_member)
    end

    def tenant?
      has_permissions_for(:user)
    end

    def advocate?
      has_permissions_for(:advocate)
    end

    def admin?
      has_permissions_for(:admin)
    end

    def team_member?
      has_permissions_for(:team_member)
    end

    def super_user?
      has_permissions_for(:super_user)
    end

    def list_permission_level_and_lower
      User::PERMISSIONS.select { |_k, v| v >= permissions }
    end

    def permissions_level
      inverted_permissions[permissions].to_s.gsub("_", " ")
    end

    private

      def has_permissions_for(key)
        self.permissions == User::PERMISSIONS[key]
      end

      def permissions_at_or_more_powerful_than(key)
        self.permissions <= User::PERMISSIONS[key]
      end

      def inverted_permissions
        levels = User::PERMISSIONS.invert
        levels[100] = "tenant"
        levels
      end
  end
end
