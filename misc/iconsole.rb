#/usr/bin/env ruby
class IConsole
  
  def help
    puts "Some hints should be here"
  end
  
  def reset
    self.class.new.run
  end
  
  def run
    @binding = binding
    
    while cmd = gets
      cmd.chomp!
      if cmd
        case cmd
          when "exit"
            break
          when "help"
            help
          when "reset"
            #implement killing this session
            reset
          when "debug"
            require "pry"
            binding.pry
          else
            begin
              puts "=> #{eval(cmd,@binding)}"
            rescue StandardError => e
              puts e.message
            end
        end
      end
    end
  end
end
IConsole.new.run                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         