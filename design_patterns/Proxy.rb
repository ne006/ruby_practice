#!/usr/local/rvm/rubies/ruby-2.3.0/bin/ruby

module ProxyExample

  #User: Part Of Client
  class User

    attr_reader :login, :role

    def initialize(login, password, role = :user)
      @login, @role = login, role
      @password = encode_pwd(password)
    end

    def encode_pwd(pwd)
      pwd
    end

    def match_pwd(pwd)
      encode_pwd(pwd) == @password
    end

    def set_role(role)
      @role = role
    end
  
  end

  #Resource: Real Object
  class Resource

    attr_reader :name
   
    def initialize(name)
      @name = name
    end

    def get
      puts "Got resource '#{@name}'"
    end

  end

  #ResourceAuth: Proxy
  class ResourceAuth < Resource
    
    attr_accessor :app

    def initialize(name)
      super
      @object = Resource.new(name)
    end

    def auth
      @roles.include?(@app.curr_user.role)
    end

    def set_roles(*roles_list)
      @roles = roles_list
    end

    def get
      if auth
        @object.get
      else
        puts "Access denied"
      end
    end

  end

  #Application: Part Of Client
  class Application

    def initialize
      @resources = []
    end

    def add_resource(resource)
      resource.app = self
      @resources << resource
    end

    def get_resources
      @resources
    end
  
    def curr_user
      @curr_user
    end

    def login(login, pwd = "")
      @curr_user = User.new(login, pwd)
    end

  end

end

app = ProxyExample::Application.new
app.login("ne006")
app.add_resource(ProxyExample::ResourceAuth.new("article"))
app.get_resources[0].set_roles(:admin)
app.get_resources[0].get
app.curr_user.set_role(:admin)
app.get_resources[0].get
