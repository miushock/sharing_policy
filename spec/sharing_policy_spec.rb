require "spec_helper"
require "sharing_policy"

describe ViewingPolicy do

  let(:user) {double}
  let(:node) {Node.new(user)}

  let(:pulling_policy_copyleft) {File.read('./spec/testcase_policy/pulling_policy_copyleft.json')}
  let(:viewing_policy_ffa) {File.read('./spec/testcase_policy/viewing_policy_ffa.json')}


  let(:resource_1) {Resource.new(user, "123", pulling_policy_copyleft)}
  let(:presentable_1) {Presentable.new(node, resource_1, viewing_policy_ffa)} 

  describe ".viewing_policy" do
    it "returns an viewing policy instance of given json spec" do
      puts SharingPolicy.policy(presentable_1)
    end

    it "raise parsing exception when failed to read or validate givine json" do
    end
  end

end

describe PullingPolicy do
  let(:user) {double}
  let(:node) {Node.new(user)}

  let(:pulling_policy_copyleft) {File.read('./spec/testcase_policy/pulling_policy_copyleft.json')}
  let(:viewing_policy_ffa) {File.read('./spec/testcase_policy/viewing_policy_ffa.json')}


  let(:resource_1) {Resource.new(user, "123", pulling_policy_copyleft)}
  let(:presentable_1) {Presentable.new(node, resource_1, viewing_policy_ffa)} 

  describe ".pulling_policy" do
    it "returns an pulling policy instance when given json spec" do
      puts SharingPolicy.policy(resource_1)
    end

    it "raise parsing exception when failed to read or validate givine json" do
    end
  end
end
