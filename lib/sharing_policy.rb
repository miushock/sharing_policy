require "sharing_policy/version"
require "active_support/concern"
require "active_support/dependencies/autoload"

module SharingPolicy

  extend ActiveSupport::Concern

  included do
    class_eval do
      def self.policy(policy_holder)
        require 'json'
        JSON.parse(policy_holder.policy)
      end
    end
  end

  class << self
    def policy(policy_holder)
      require 'json'
      JSON.parse(policy_holder.policy)
    end
  end
end

module ViewingPolicy
  extend ActiveSupport::Concern
  include SharingPolicy

  included do
  end

end

module PullingPolicy
  extend ActiveSupport::Concern
  include SharingPolicy

  included do
  end
end
