module ApplicationName; module Controllers

  class Main < Controller
    map '/'

    helper :stack

    def index
      @title = "Home"
    end

  end

end; end
