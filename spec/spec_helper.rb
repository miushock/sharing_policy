require "active_support/core_ext/kernel"

warning = capture(:stderr) do
  require "sharing_policy"
end

class User

  attr_accessor :id

  def initialize (id)
    @id = id
    @action_list = []
  end

  def actions
    @action_list
  end

  def take_action(action)
    @action_list << action
  end
end

class Node < Struct.new(:owner)
end

class Presentable < Struct.new(:node, :resource, :policy)
  include ViewingPolicy

  def owner
    resource.owner
  end

  def resource_id
    resource.resource_id
  end
end

class Resource < Struct.new(:owner, :resource_id, :policy)
  include PullingPolicy
end

class UserGroup < Struct.new(:owner, :roster)
end

class Action
  attr_accessor :type, :resource_id, :content
  def initialize(type, resource_id, content)
    @type, @resource_id, @content  = type, resource_id, content
  end

  def eql?(other_action)
    (@type.eql? other_action.type) && (@resource_id.eql? other_action.resource_id)
  end
  attr_accessor :type
end

module DummyPredicates
  def self.member_of_group? (user, user_group, resource=nil)

    case user_group
    when "public"
      return true
    when "self"
      return (resource.nil? ? false : resource.owner == user)
    when "cats"
      case user.id
      when "dummy@litter.com"
        return true
      when "unhappy@litter.com"
        return true
      when "tom@wb.com"
        return true
      else
        return false
      end
    else
      return false
    end
  end

  def self.action_conducted? (user, requirement, resource)
    action = Action.new(requirement[0], resource.resource_id, nil)
    action_record_list = user.actions
    result = action_record_list.select do |record|
      record.eql? action
    end

    return result.size > 0
  end
end
