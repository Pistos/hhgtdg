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

      (1..16).each do |page|
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

          planet_id = tds[0].at('img')['id'][ /planetinfo(\d+)/, 1 ].to_i
          info_text = []
          pdoc = Nokogiri::HTML(
            JSON.parse(
              open(
                "http://davesgalaxy.com/planets/#{planet_id}/info/",
                "Cookie" => "sessionid=#{@sid}"
              ).read
            )[ 'tab' ]
          )
          table = pdoc.at( "//h3[contains(.,'Resources')]" ).parent.at( 'table' )
          info_tds = table.search( 'td.planetinfo2' )
          info_text << info_tds[0].content
          info_text << info_tds[3].content
          info_text << info_tds[6].content
          info_text << info_tds[9].content
          info_text << info_tds[12].content
          info_text << info_tds[15].content
          info_text << info_tds[18].content

          @planets << PlanetInfo.new( *td_text, *info_text, page )
        end
      end

      session[ 'planets' ] = @planets
    end

  end

end; end
