#!/usr/bin/env ruby

describe "Condition variable" do
  before :all do
    @c = 0 # "resource"

    lock = Mutex.new
    cv = ConditionVariable.new

    inc = proc do
      lock.synchronize do
        #cv.wait lock
        @c+=1
        #p @c
        cv.signal
      end
    end
    dec = proc do
      lock.synchronize do
        cv.wait lock
        @c-=1
        #p @c
        cv.signal
      end
    end

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

  1.times do
    it "should set @c to 0 (in the end at least)" do
      expect(@c).to be_zero
    end
  end
end
