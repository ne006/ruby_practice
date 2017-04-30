#!/usr/local/rvm/rubies/ruby-2.3.0/bin/ruby
#Pretty print
require 'colorize'
require 'singleton'

module StateExample

  #Abstract
  class RequestState

    def self.name
      raise NotImplementedError
    end

    def self.send(rq)
      raise NotImplementedError
    end

    def self.get_response(rq)
      raise NotImplementedError
    end

  end

  #Created
  class CreatedState < RequestState

    def self.name
      "Created"
    end

    def self.send(rq)
      puts "Sending request ##{rq.request_id.red}"
      rq.state = SentState
      201
    end

    def self.get_response(rq)
      raise "Request ##{rq.request_id.red} has not been sent"
    end

  end

  #Sent
  class SentState < RequestState

    def self.name
      "Sent"
    end

    def self.send(rq)
      raise "Request ##{rq.request_id.red} has been sent already"
    end

    def self.get_response(rq)
      chance = rand(100)
      case chance
        when 0..20
          puts "Request ##{rq.request_id.red} has not been processed yet"
          202
        when 20..50
          rq.state = FailedState
          raise "Request ##{rq.request_id.red} has failed"
        when 50..100
          rq.state = ReceivedState
          puts "Request ##{rq.request_id.red} has been processed"
          200
        else
          raise "Internal Error"
      end
    end

  end

  #Received
  class ReceivedState < RequestState

    def self.name
      "Received"
    end

    def self.send(rq)
      raise "Request ##{rq.request_id.red} has been sent already"
    end

    def self.get_response(rq)
      rq.state = SentState
      puts "Re-sending request ##{rq.request_id.red}" 
      202     
    end

  end

  #Failed
  class FailedState < RequestState

    def self.name
      "Failed"
    end

    def self.send(rq)
      raise "Request ##{rq.request_id.red} has been sent already"
    end

    def self.get_response(rq)
      rq.state = SentState
      puts "Re-sending request ##{rq.request_id.red}" 
      202     
    end

  end

  class ServerRequest

    @@last_request_id = 0

    def request_id
      @request_id.to_s
    end

    attr_writer :state

    def initialize
      @state = CreatedState
      @request_id = @@last_request_id+=1
    end

    def send
      begin
        @state.send(self)
      rescue Exception => e
        puts e.message
        :error
      end
    end

    def check_status
      begin
        @state.name
      rescue Exception => e
        puts e.message
        :error
      end
    end

    def get_response
      begin
        @state.get_response(self)
      rescue Exception => e
        puts e.message
        :error
      end
    end    

  end

end

rq1 = StateExample::ServerRequest.new
puts rq1.check_status
rq1.send
puts rq1.check_status
begin
  status = rq1.get_response
  puts rq1.check_status
end until status == 200
