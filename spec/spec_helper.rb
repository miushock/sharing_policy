require "active_support/core_ext/kernel"

warning = capture(:stderr) do
  require "sharing_policy"
end

class User < Struct.new(:email)
end

class Node < Struct.new(:owner)
end

class Presentable < Struct.new(:node, :resource, :policy)
  include ViewingPolicy
end

class Resource < Struct.new(:owner, :resource_id, :policy)
  include PullingPolicy
end
