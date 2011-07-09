require "spec_helper"

describe HashWithMethod do

  it 'should be created with hash.' do
    anon = Class.new(HashWithMethod)
    hwm = anon.from({:a => 1, 'b' => 'x', 'c' => { 'x' => 1, 'y' => 'iroha'}})
    hwm.c.y.should == 'iroha'
    hwm['c'].should be_nil
    hwm[:c].should == {x: 1, y: 'iroha'}
    HashWithMethod.new.respond_to?(:c).should_not be_true
    anon.new.respond_to?(:c).should be_true
  end
end