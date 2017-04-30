#!/usr/bin/env ruby

describe "Mutex" do
  before :all do
    @c = 0 # "resource"

    lock = Mutex.new

    inc = proc { lock.synchronize { @c+=1} }
    dec = proc { lock.synchronize { @c-=1} }

    run_count = 100
    run_count.times do |num|
      if num.even?
        Thread.new &inc
      else
        Thread.new &dec
      end
    end
    Thread.list.each { |t| t.join if t != Thread.current }
  end

  100.times do
    it "should set @c to 0 (in the end at least)" do
      expect(@c).to be_zero
    end
  end
end
