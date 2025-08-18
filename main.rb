require "dxruby"
require_relative "map"
#require_relative "scene"
require_relative "gamemap"
require_relative "menu"
#require_relative "enemy"

@mapimage = Image.load_tiles("~/kusogame/image/640x480/map.png",8,11)

Window.caption = "TEST"

module FiberSprite
    def initialize(x=0,y=0,image=nil)
        super
        @fiber = Fiber.new do
            self.fiber_proc
        end
    end

    def update
        @fiber.resume
        super
    end

    def wait(t=1)
        t.times{Fiber.yield}
    end
end


class Player < Sprite
    include FiberSprite
    attr_accessor :mx, :my

    def initialize(x, y, map, map2, target=Window)
      @mx, @my, @map, self.target = x, y, map, target
      super(8.5 * 32, 6 * 32)

      self.center_x = 0
      self.center_y = 16
      self.offset_sync = true

      self.image = Image.new(32, 48).
      circle(15, 5, 5, [255, 255, 255]).
      line(5, 18, 26, 18, [255, 255, 255]).
      line(15, 10, 15, 31, [255, 255, 255]).
      line(15, 31, 5, 47, [255, 255, 255]).
      line(15, 31, 25, 47, [255, 255, 255])
    end

    def fiber_proc
        loop do
          ix, iy = Input.x, Input.y

          if ix + iy != 0 and (ix == 0 or iy == 0) and
            @map2[@mx/32+ix, @my/32+iy] == 0 and
            @mx/32 + ix >= 0 and @mx/32 + ix < @map.size_x and
            @my/32 + iy >= 0 and @my/32 + iy < @map.size_y
            8.times do
              @mx += ix * 4
              @my += iy * 4
              self.x += ix * 4
              self.y += iy * 4
              wait
            end
          else
            wait
          end
		if ix + iy
        end
    end
end


$rt = RenderTarget.new(640-64, 480-64)

$font1 = Font.new(30,"MS明朝",{:weight=>false, :italic=>false})

$map_base = Map.new("~/kusogame/mdat/map2.dat", @mapimage, $rt)
$map_sub = Map.new("~/kusogame/mdat/map_sub3.dat", @mapimage, $rt)



$player = Player.new(480, 480, $map_sub, $map_base, $rt)

#$enemy = Enemy.new

$map_x = $player.mx - $player.x
$map_y = $player.my - $player.y


$min_x = 128
$max_x = 640 - 64 - 128 - 32
$min_y = 128
$max_y = 480 - 64 - 128 - 32

$scene = MainMenu
Window.loop do
include Sceane
$scene.exec()


  break if Input.key_push?(K_ESCAPE)
end
end
