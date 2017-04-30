#!/usr/local/rvm/rubies/ruby-2.3.0/bin/ruby

module FlyweightExample

  class User

    def initialize(login, pwd)
      @login, @pwd = login, pwd
    end

  end

  class UserFactory

    def initialize
      @users = Hash.new
    end

    def new_user(login, pwd = nil)
      if @users[login.to_sym].nil?
        @users[login.to_sym] = User.new(login, pwd)
        puts "Creating new instance of User (#{login})"
      else
        @users[login.to_sym]
        puts "Fetching instance of User (#{login})"
      end
    end

    def users_count
      @users.size
    end

  end

  class Group

    attr_accessor :users
    
    def initialize
      @users = []
    end

  end

end

uf = FlyweightExample::UserFactory.new
gr_a = FlyweightExample::Group.new
gr_b = FlyweightExample::Group.new
gr_a.users << uf.new_user("user1")
gr_a.users << uf.new_user("user2")
gr_b.users << uf.new_user("user1")
gr_b.users << uf.new_user("user2")

puts "Total amount of Users: #{uf.users_count}"
