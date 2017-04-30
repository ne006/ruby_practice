#!/usr/bin/env ruby
require 'dbi'

class DBconn

  #Initialize connection
  def initialize(host, port, adapter, user, password, database)

    begin
      @conn = DBI.connect("DBI:#{adapter}:#{database}:#{host}", user, password)
    rescue DBI::DatabaseError => e
      puts e.message
      @conn.disconnect if @conn
    end

  end

  #Execute SQL Statement
  def execute(statement)
    sth = @conn.execute statement
    yield sth if block_given?
  end

  #Execute select statement
  def select(table, columns = "*", where = nil)
    #Construct statement
    stm = "select "
    #Push columns
    if (columns != "*" && columns.respond_to?(:each))
      columns.each_with_index do |column, i|
        stm += column.to_s
        if i == columns.size-1
          stm += " "
        else
          stm += ", "
        end
      end
    elsif columns == "*"
      stm += "* "
    else
      #throw "Invalid SQL statement: columns should be an Array or a '*' String"
    end
    #Push from
    stm += "from #{table.to_s}"
    #Push where if not nil
    if (where.is_a?(Hash) && where.size > 0)
      stm += " where"
      where.each_with_index do |cond, i|
        if i == 0
          stm+= " "
        else
          stm+= " AND "
        end
        stm+= "#{cond[0]} "
        if cond[1].nil?
          stm+="IS NULL"
        else
          stm+="= '#{cond[1]}'"
        end
      end
    elsif where
      #throw "Invalid SQL statement: where should be a Hash"
    end
    #Execute already
    result = []
    @conn.execute(stm) do |rows|
      rows.each do |row|
        result.push row.to_h
      end
    end
    result
  end

  #Here be THE INSERT method
  def insert()

  end

  def commit
    @conn.commit
  end

  def rollback
    @conn.rollback
  end

  def close
    @conn.disconnect
  end

end
