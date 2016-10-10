module ReleaseParser
  module Tokens
    class Base
      attr_reader :match

      def length
        match[0].length
      end

      def result
        match[1]
      end

      def normalized_result
        if match.names.any?
          match.names.each do |name|
            return name if match[name] != nil
          end
        else
          match[1]
        end
      end

      def === (remote)
        self.class::REGEX.match(remote).tap do |match|
          @match = match
        end
      end
    end

    class Unknown < Tokens::Base
      def initialize(match)
        @match = match
      end

      def length
        @match.length
      end

      def normalized_result
        @match
      end

    end

    class Freeleech < Tokens::Base
      REGEX = /^(\[FreeLeech\])/i

      def normalized_result
        true
      end
    end

    class Codec < Tokens::Base
      REGEX = /
        ^(?<x264>x264)|
        ^(?<h264>h264)|
        ^(?<x265>x265)|
        ^(?<xvidhd>XvidHD)|
        ^(?<xvid>Xvid)|
        ^(?<divx>divx)
      /ix
    end

    class Source < Tokens::Base
      REGEX = /
        ^(?<hdtv>HDTV)|
        ^(?<hdrip>HDRip)|
        ^(?<bluray>BluRay|Blu-Ray|HDDVD|BD)|
        ^(?<webdl>WEB[-_. ]DL|WEBDL|WebRip|iTunesHD|WebHD|WEB)|
        ^(?<bluray>BDRip)|
        ^(?<bluray>BRRip)|
        ^(?<dvd>DVD|DVDRip|NTSC|PAL|xvidvd)|
        ^(?<dsr>WS[-_. ]DSR|DSR)|
        ^(?<pdtv>PDTV)|
        ^(?<sdtv>SDTV)|
        ^(?<tvrip>TVRip)|
        ^(?<rawhd>RawHD|1080i[-_. ]HDTV|Raw[-_. ]HD|MPEG[-_. ]?2)
      /ix
    end

    class Language < Tokens::Base
      REGEX = /
        ^(?<italian>\b(?:ita|italian)\b)|
        ^(?<german>german\b|videomann)|
        ^(?<flemish>flemish)|
        ^(?<greek>greek)|
        ^(?<french>(?:\W|_)(?:FR|VOSTFR)(?:\W|_))|
        ^(?<russian>\brus\b)|
        ^(?<dutch>nl\W?subs?)|
        ^(?<hungarian>\b(?:HUNDUB|HUN)\b)
      /ix
    end

    class HardCodedSubs < Tokens::Base
      REGEX = /^HC /i

      def normalized_result
        true
      end
    end

    class Country < Tokens::Base
      REGEX = /
        ^(?<usa>US)|
        ^(?<uk>UK)
      /x
    end

    class Season < Tokens::Base
      REGEX =/^(S|Season |Season)(\d+)/i

      def normalized_result
        @match[2].to_i
      end
    end

    class Airdate < Tokens::Base
      REGEX =/^(\d{4} [012][\d|30|31] [012][\d|30|31])/i

      def normalized_result
        Date.parse(@match[2])
      end
    end

    class ReleaseGroup < Tokens::Base
      REGEX = /^-(\w+)$/i
    end

    class Episode < Tokens::Base
      REGEX = /^(E|Episode |Episode)(\d+)/i

      def normalized_result
        @match[2].to_i
      end
    end

    class Year < Tokens::Base
      REGEX = /^[\(]?(\d{4})[\)]?/i

      def normalized_result
        @match[1].to_i
      end
    end

    class Resolution < Tokens::Base
      REGEX = /
        ^(?<_480p>480p|640x480|848x480)|
        ^(?<_576p>576p)|
        ^(?<_720p>720p|1280x720)|
        ^(?<_1080p>1080p|1920x1080)|
        ^(?<_2160p>2160p)
      /ix

      def normalized_result
        super.gsub('_', '')
      end
    end

    class Audio < Tokens::Base
      REGEX = /^(TrueHD|True HD|7\.1 Atmos|5\.1)/i
    end

    class Separator < Tokens::Base
      REGEX = /^( |\.|_)/i
    end
  end
end
