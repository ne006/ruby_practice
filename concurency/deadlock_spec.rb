#!/usr/bin/env ruby

describe "Deadlock" do
  before :all do
    m = Mutex.new
    n = Mutex.new

    @t = proc do
      n.lock
      puts "Thread t locked Mutex n"
      sleep 1
      puts "Thread t waits for Mutex m"
      m.lock
      puts "Thread t locked Mutex m"
    end

    @s = proc do
      m.lock
      puts "Thread s locked Mutex m"
      sleep 1
      puts "Thread s waits for Mutex n"
      n.lock
      puts "Thread s locked Mutex n"
    end
  end

  it "should raise a deadlock exception when facing one" do
    expect do
      Thread.new &@t
      Thread.new &@s
      Thread.list.each { |t| t.join if t != Thread.current }
    end.
    to raise_error(/No live threads left. Deadlock?.*/)
  end

end
