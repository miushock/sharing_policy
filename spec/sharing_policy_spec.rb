require "spec_helper"
require "sharing_policy"

describe ViewingPolicy do

  let(:litters_digest) {Node.new(unhappy)}

  #3 kittens
  let(:dummy) {User.new("dummy@litter.com")}
  let(:unhappy) {User.new("unhappy@litter.com")}
  let(:tom) {User.new("tom@wb.com")}

  #a rabbit and a bird
  let(:bugs_bunny) {User.new("bbunny@wb.com")}
  let(:tweety) {User.new("tweety@wb.com")}

  #kitten user group
  let(:cats) {UserGroup.new(litters_digest, [dummy, unhappy, tom])}
  let(:litter_executives) {UserGroup.new([dummy, unhappy])}

  let(:node) {Node.new(unhappy)}

  let(:pulling_policy_copyleft) {File.read('./spec/testcase_policy/pulling_policy_copyleft.json')}
  let(:viewing_policy_ffa) {File.read('./spec/testcase_policy/viewing_policy_ffa.json')}
  let(:pay_once_policy) {File.read('./spec/testcase_policy/pay_once.json')}
  let(:cats_only) {File.read('./spec/testcase_policy/cats_only.json')}

  let(:resource_1) {Resource.new(dummy, "1", pulling_policy_copyleft)}
  let(:presentable_1) {Presentable.new(node, resource_1, viewing_policy_ffa)}

  let(:resource_2) {Resource.new(dummy, "2", pulling_policy_copyleft)}
  let(:presentable_2) {Presentable.new(node, resource_2, cats_only)}

  let(:pay_once_resource) {Resource.new(dummy, "3" , pulling_policy_copyleft)}
  let(:pay_once_presentable) {Presentable.new(node, pay_once_resource, pay_once_policy)}
  
  #create actions
  let(:pay_for_resource_3) {Action.new("payment", "3", nil)}

  describe ".viewing_policy" do
    it "returns an viewing policy instance of given json spec" do
      #puts SharingPolicy.policy(presentable_1)
    end

    it "raise parsing exception when failed to read or validate givine json" do
    end
  end

  describe "#authorize" do
    it "return OK status on public viewable resource" do
      presentable_1.init_policy(viewing_policy_ffa)
      result = presentable_1.authorize(tom, DummyPredicates.method(:member_of_group?), DummyPredicates.method(:action_conducted?))

      result[0][0].should eql(200)
    end

    it "return OK status on self visit" do
      presentable_1.init_policy(viewing_policy_ffa)
      result = presentable_1.authorize(dummy, DummyPredicates.method(:member_of_group?), DummyPredicates.method(:action_conducted?))

      result[0][0].should eql(200)
    end

    it "let cats access cats only resource" do
      presentable_2.init_policy(cats_only)
      result = presentable_2.authorize(unhappy, DummyPredicates.method(:member_of_group?), DummyPredicates.method(:action_conducted?))

      result[0][0].should eql(200)
    end

    it "reject public from accessing cats resource" do
      presentable_2.init_policy(cats_only)
      result = presentable_2.authorize(bugs_bunny, DummyPredicates.method(:member_of_group?), DummyPredicates.method(:action_conducted?))

      result[0][0].should eql(400)
    end

    it "accept/reject payed/unpayed user from accessing pay_once_resource" do
      unhappy.take_action(pay_for_resource_3)
      
      pay_once_presentable.init_policy(pay_once_policy)
      paid_result = pay_once_presentable.authorize(unhappy,  DummyPredicates.method(:member_of_group?), DummyPredicates.method(:action_conducted?))
      unpaid_result = pay_once_presentable.authorize(bugs_bunny,  DummyPredicates.method(:member_of_group?), DummyPredicates.method(:action_conducted?))
      
      
      
      paid_result[0][0].should eql(200)
      unpaid_result[0][0].should eql(300)
    end

    it "reject strangers from cats only resources" do
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
#      puts SharingPolicy.policy(resource_1)
    end

    it "raise parsing exception when failed to read or validate givine json" do
    end
  end
end
