require "sharing_policy/version"
require "active_support/concern"
require "active_support/dependencies/autoload"

module SharingPolicy

  extend ActiveSupport::Concern

  included do
  end

  class << self
    def policy(policy_holder)
      require 'json'
      JSON.parse(policy_holder.policy)
    end
  end

  def init_policy(policy_text)
    require 'json'
    @policy = JSON.parse(policy_text)
  end
end

module ViewingPolicy
  extend ActiveSupport::Concern
  include SharingPolicy

  included do
  end

  def init_policy(policy_text)
    require 'json'
    @policy = JSON.parse(policy_text)
  end

  #tries to authorize user against policy, test against each user group
  def authorize(user, membership_assert, action_assert)
    auth_responses = []
    @policy["cases"].each do |user_group, required_actions|
      response_of_group = authorize_case(user, user_group, membership_assert, action_assert)
      auth_responses << response_of_group
    end

    #responde with highest authorization can give
    status_codes = auth_responses.map {|response| response[0]}

    auth_responses.reject {|response| response[0] > status_codes.min}

  end

  #authorize user for each group specified in policy
  #return [STATUS_CODE, MESSAGE, BODY]
  def authorize_case(user, user_group, membership_assert, action_assert)
    status_code, message, body = 500, "internal error", []

    if membership_assert.call(user, user_group, self)
      @group_policy = @policy["cases"][user_group]
      required_actions = @group_policy["actions"]

      if required_actions.size >= 1
        required_actions.each { |action| 
          body << action if !action_assert.call(user, action, self)
        }
      end

      if body.empty?
        status_code, message = 200, "authorized as member of #{user_group}"
      else
        status_code = 300
        message = "actions required"
      end

    else

      status_code = 400
      message = "no membership found"
    end

    [status_code, message, body]

  end

end

module PullingPolicy
  extend ActiveSupport::Concern
  include SharingPolicy


  def init_policy(policy_text)
    require 'json'
    @policy = JSON.parse(policy_text)
  end

  included do
  end
end
