module ApplicationName; module Controllers

  class Main < Controller
    map '/'

    helper :stack

    def index
      @planets = []

      update_cache = ( request[ 'submit' ] == 'Update Cache' )
      if request.post?
        session[ 'sessionid' ] = h( request[ 'sessionid' ] )
        update_cache = true
      end

      return  if session['sessionid'].nil?

      @sid = session['sessionid']

      if ! update_cache
        @planets = session[ 'planets' ] || []
        return
      end

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
          td_text = tds[4..8].map { |td| td.content }
          @planets << PlanetInfo.new( *td_text )
        end
      end

      session[ 'planets' ] = @planets
    end

  end

end; end
