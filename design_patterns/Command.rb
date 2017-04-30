#!/usr/local/rvm/rubies/ruby-2.3.0/bin/ruby

require 'colorize'

module CommandExample

  #Receiver
  class DataSource

    attr_accessor :data

    def initialize
      @data = {}
    end

  end

  #Command: Abstract
  class Query

    def initialize(source, params)
      @source, @params, @executed = source, params, false
    end

    def execute
      puts "#{self.class.name.split("::").last.red}: executed successfuly"
      @executed = true
    end

    def executed?
      return false unless @executed
      true
    end

    def rollback
      puts "#{self.class.name.split("::").last.red}: rolling back"
      @executed = false
    end

  end

  #Command: Select
  class SelectQuery < Query

    #execute
    def execute

      from = @params[:from]
      fields = @params[:fields]
      
      if !(from && fields)
        raise "Query is incorrect"
      end      
         
      table = @source.data[from.to_sym]
      if !table
        raise "Table doesn't exist"
      end

      where = @params[:where]
      if where
        pre_result = table.select do |row|
          pass = true
          where.each do |field, value|
            pass = false if row[field] != value
          end
          pass
        end
      else
        pre_result = table
      end
      result = pre_result.inject([]) do |result, row|
        filtered_row = {}
        fields.each do |field|
          filtered_row[field] = row[field]
        end
        result << filtered_row
      end      
      super      
      result  
  
    end

    #rollback: it's a select, nothing to rollback, blank override
    def rollback
      true
    end

  end

  #Command: Upsert
  class UpsertQuery < Query

    #execute
    def execute
      
      to = @params[:to]
      rows = @params[:rows]
      
      if !(to && rows)
        raise "Query is incorrect"
      end      
         
      if !@source.data[to.to_sym]
        @source.data[to.to_sym] = []
      end
      table = @source.data[to.to_sym]

      table.concat rows
      super

    end

    #rollback
    def rollback
      raise "Query has not been executed" unless executed?

      to = @params[:to]
      rows = @params[:rows]

      table = @source.data[to.to_sym]
      if !table
        raise "Table doesn't exist"
      end

      rows.each do |row|
        table.delete row
      end
      
      super

    end

  end

  #Command: Delete
  class DeleteQuery < Query

    #execute
    def execute

      from = @params[:from]
      
      if !from
        raise "Query is incorrect"
      end      
         
      table = @source.data[from.to_sym]
      if !table
        raise "Table doesn't exist"
      end

      where = @params[:where]
      if where
        result = table.select do |row|
          pass = true
          where.each do |field, value|
            pass = false if row[field] != value
          end
          pass
        end
      else
        result = table
      end
      @backup = result
      result.each do |row|
        table.delete row
      end
      super       
  
    end

    #rollback
    def rollback
      raise "Query has not been executed" unless executed?

      from = @params[:from]
      table = @source.data[from.to_sym]
      if !table
        raise "Table doesn't exist"
      end  
  
      table.concat @backup

      super
    
    end

  end


end

#Db testing
db = CommandExample::DataSource.new
db.data[:request] = [
  {id: 1, status: :error, user: "john"},
  {id: 2, status: :received, user: "kowalsky"}
]

#Select testing
q = CommandExample::SelectQuery.new(
  db,
  {
    from: :request,
    fields: [:id,:status,:user],
    where: {
      user: "kowalsky"
    }
  }
)
puts q.execute
q = CommandExample::SelectQuery.new(
  db,
  {
    from: :request,
    fields: [:id,:status,:user]
  }
)
puts q.execute

#Upsert testing
u =  CommandExample::UpsertQuery.new(
  db,
  {
    to: :request,
    rows: [
    {id: 3, status: :received, user: :john},
    {id: 4, status: :created, user: :kowalsky}
    ]
  }
)
u.execute
puts q.execute
puts
u.rollback
puts q.execute

#delete testing
u.execute
puts q.execute
d = CommandExample::DeleteQuery.new(
  db,
  {
    from: :request,
    where: {
      id: 2
    }
  }
)
puts
d.execute
puts q.execute
puts
d.rollback
puts q.execute
