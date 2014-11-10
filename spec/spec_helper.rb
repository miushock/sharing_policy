require "active_support/core_ext/kernel"

class User < Struct.new (:email)
end

class Node < Struct.new (:owner)
end

class Resource < Struct.new (:owner)
end
