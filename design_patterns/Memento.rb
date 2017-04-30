#!/usr/local/rvm/rubies/ruby-2.3.0/bin/ruby

module MementoExample

  ERROR_CHANCE = 33
  
  #Task class (Originator)
  class Task
    
    @@last_id = 0
    
    def initialize(name)
      @name, @status, @task_id = name, :scheduled, @@last_id+=1
    end

    def name
      @name
    end

    def status
      @status
    end

    def task_id
      @task_id
    end

    def process
      error_roll = (Random.new).rand(100)
      if error_roll > 0 && error_roll < ERROR_CHANCE   
        @status = :error
      else
        @status = :completed
      end
    end

    def get_state
      TaskState.new(@name, @status, @task_id)
    end

    def set_state(task_state)
      @name, @status = task_state.name, task_state.status
    end

    def ==(other)
      if other.respond_to? :task_id
        @task_id == other.task_id
      else
        false
      end
    end     

  end

  #TaskState class (Memento)
  class TaskState

    attr_reader :name, :status, :task_id

    def initialize(name, status, task_id)
      @name, @status, @task_id = name, status, task_id
    end

    def ==(other)
      if other.respond_to? :task_id
        @task_id == other.task_id
      else
        false
      end
    end 

  end

  #QueueServer class (Caretaker)
  class QueueServer

    def initialize
      @queue = []
      @archive = []
      @state_queue = []
      @started = false
    end

    def start
      @started = true
    end

    def stop
      @started = false
    end

    def queue_task(name)
      @queue << Task.new(name)
      list_queue
      process
    end

    def list_queue
      puts "\n" + "-"*2 + "Task" + "-"*2 + " " + "-"*2 + "Status" + "-"*2
      @queue.each do |task|
        puts " " + task.name + " " + task.status.to_s
      end
      @archive.each do |task|
        puts " " + task.name + " " + task.status.to_s
      end      
    end

    def process
      @queue.each do |task|

        if task.status == :scheduled
            @state_queue << task.get_state
            puts "processing \"#{task.name}\""
            task.process
        end
        if task.status == :error
            @state_queue.each do |state|
              if task == state
                task.set_state(state)
                @state_queue.delete(state)
                puts "\"#{task.name}\" processing failed. rolling back"
                @archive << TaskState.new(task.name, task.status, task.task_id)
                @queue.delete(task)
                break
              end
            end
        end
        if task.status == :completed
           @state_queue.each do |state|
              if task == state
                @state_queue.delete(state)
                puts "\"#{task.name}\" processing finished"
                @archive << TaskState.new(task.name, task.status, task.task_id)
                @queue.delete(task)
                break
              end
           end
        end

      end
      process if @queue.size > 0
    end        

  end

end

srv = MementoExample::QueueServer.new
srv.start
srv.queue_task("Upload photos")
srv.queue_task("Process photos")
srv.queue_task("Download photos")
srv.queue_task("Fetch news")
