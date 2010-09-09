module ApplicationName; module Controllers

  class Main < Controller
    map '/'

    helper :stack

    def index
      @planets = []

      if request.post?
        session[ 'sessionid' ] = h( request[ 'sessionid' ] )
      end

      return  if session['sessionid'].nil?

      @sid = session['sessionid']

      (1..14).each do |page|
        doc = Nokogiri::HTML(
          JSON.parse(
            open(
              "http://davesgalaxy.com/planets/list/all/#{page}/",
              "Cookie" => "sessionid=#{@sid}"
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
