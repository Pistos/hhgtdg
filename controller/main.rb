module ApplicationName; module Controllers

  class Main < Controller
    map '/'

    helper :stack

    def index
      @planets = []
      (1..14).each do |page|
        doc = Nokogiri::HTML(
          JSON.parse(
            open(
              "http://davesgalaxy.com/planets/list/all/#{page}/",
              "Cookie" => 'sessionid=e21fa8c408a1fe989da91c5c99b9f021'
            ).read
          )[ 'tab' ]
        )
        doc.search( 'tr.fleetrow' ).each do |tr|
          tds = tr.search( 'td' )
          @planets << PlanetInfo.new( *tds[4..8] )
        end
      end
    end

  end

end; end
