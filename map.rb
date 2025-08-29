class Map
    # Expose the parsed map data for read-only access
    attr_reader :mapdata
    def initialize(filename,mapimage,target=Window)
        @mapimage, @target = mapimage, target
        @mapdata = []
        File.open(filename, "rt") do |fh|
            lines = fh.readlines
            lines.each do |line|
                ary = []
                line.chomp.each_char do |o|
                    if o != "x"
                        ary << o.to_i
                    else
                        ary << nil
                    end
                end
                @mapdata << ary
            end
        end
    end
    def [](x, y)
        @mapdata[y % @mapdata.size][x % @mapdata[0].size]
    end

    def []=(x, y, v)
        @mapdata[y % @mapdata.size][x % @mapdata[0].size] = v
    end
end
