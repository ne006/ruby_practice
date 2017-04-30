#!/usr/local/rvm/rubies/ruby-2.3.0/bin/ruby

module InterpreterExample

  class LitExpr

    def initialize(expr)
      @expr = expr
    end

    def interpret(expr)
      @expr == expr
    end

  end

  class AltExpr

    def initialize(expr1, expr2)
      @expr1, @expr2 = expr1, expr2
    end

    def interpret(expr)
      @expr1.interpret(expr) || @expr2.interpret(expr)
    end

  end

  class SeqExpr

    def initialize(expr1, expr2)
      @expr1, @expr2 = expr1, expr2
    end

    def interpret(expr)
      @expr1.interpret(expr) && @expr2.interpret(expr)
    end

  end

  class NotExpr

    def initialize(expr)
      @expr = expr
    end

    def interpret(expr)
      !@expr.interpret(expr)
    end

  end

end

pattern = InterpreterExample::AltExpr.new(
  InterpreterExample::LitExpr.new("cat"),
  InterpreterExample::SeqExpr.new(
    InterpreterExample::LitExpr.new("bird"),
    InterpreterExample::NotExpr.new(
      InterpreterExample::LitExpr.new("dog")
    )
  )
)

puts pattern.interpret(ARGV[0])
