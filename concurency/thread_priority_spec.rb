#!/usr/bin/env ruby

describe "Thread priority" do
  before :all do
    @result = ""
    @result_wait = ""
    a = Thread.new { a.priority=1;@result += "a";sleep(1);@result_wait += "a"}
    Thread.new {@result += "b";@result_wait += "b"}

    Thread.list.each { |t| t.join unless t == Thread.current }
  end

  it "should wait for a Thread with higher priority to finish" do
    expect(@result).to eq("ab")
  end

  it "should let low-priority Threads work if HP Threads are not active" do
    expect(@result_wait).to eq("ba")
  end
end
