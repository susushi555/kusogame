require "dxruby"
require_relative "map"
#require_relative "scene"
#require_relative "gamemap"
#require_relative "menu"
require_relative "enemy"
require_relative "imgset"

#@mapimage = Image.load_tiles("~/kusogame/image/640x480/map1.png",8,11)
@mapimage = Image.load_tiles("C:/Users/dotdo/OneDrive/ドキュメント/GitHub/kusogame/image/640x480/map1.png",8,11)



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
            @map2[mx/32+ix, my/32+iy] == 0 and
            mx/32 + ix >= 0 and mx/32 + ix < @map.size_x and
            my/32 + iy >= 0 and my/32 + iy < @map.size_y
            8.times do
              mx += ix * 4
              my += iy * 4
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


@rt = RenderTarget.new(640-64, 480-64)

font1 = Font.new(30,"MS明朝",{:weight=>false, :italic=>false})

@map_base = Map.new("C:/Users/dotdo/OneDrive/ドキュメント/GitHub/kusogame/mdat/map2.dat", @mapimage, @rt)
@map_sub = Map.new("C:/Users/dotdo/OneDrive/ドキュメント/GitHub/kusogame/mdat/map_sub3.dat", @mapimage, @rt)



@player = Player.new(480, 480, @map_sub, @map_base, @rt)

#$enemy = Enemy.new

@map_x = @player.mx #- @player.x
@map_y = @player.my #- @player.y


@min_x = 128
@max_x = 640 - 64 - 128 - 32
@min_y = 128
@max_y = 480 - 64 - 128 - 32



module MainMenu
	Window.width = 480
	Window.height = 480
	@image = Image.new(120,60,C_BLUE)
	@bottun = Sprite.new(130,130,@image)
	@image1 = Image.new(20,20,C_CYAN)
	@point = Sprite.new(0,0,@image1)
  @font = Font.new(30,"MS明朝",{:weight=>false, :italic=>false})

	module_function
	def exec
		Sprite.draw(@bottun)
		Window.draw_font(130,130,"始める",@font,{:color=>C_BLACK})
		Sprite.draw(@point)

		@point.x = Input.mouse_pos_x
		@point.y = Input.mouse_pos_y
		Input.mouse_enable = false

		#@result = (@bottun === @point)

		#if Input.mouse_push?(M_LBUTTON) and @bottun == @point or Input.key_push?(K_SPACE)
		if Input.key_push?(K_SPACE)
      @scene = GameMap
		end
	end
end


module Sceane
  image = Image.new(20,20,C_CYAN)
  image2 = Image.load("C:/Users/dotdo/OneDrive/ドキュメント/GitHub/kusogame/image/bottun1.jpg")
  image3 = Image.load("C:/Users/dotdo/OneDrive/ドキュメント/GitHub/kusogame/image/bottun1.jpg")
  image3.set_color_key(C_WHITE)

  bottun = Image.load("C:/Users/dotdo/OneDrive/ドキュメント/GitHub/kusogame/image/bottun1.jpg")
  bottun1 = Sprite.new(0,270,bottun)
  sceane1 = Image.load("C:/Users/dotdo/OneDrive/ドキュメント/GitHub/kusogame/image/BG00a1_80.jpg")
  hpg2 = Image.load("C:/Users/dotdo/OneDrive/ドキュメント/GitHub/kusogame/image/bottun1.jpg")
	hpg2 = Sprite.new(300,270,hpg2)
  point = Sprite.new(0,0,image)
	hpg = Image.new(120,40,C_GREEN)

	Window.width = 480
	Window.height = 480

	module_function
	def exec

		Window.draw_box_fill(0,480,480,240,C_YELLOW)
		Window.draw(0,480,$sceane1)
		Window.draw_scale(-160,-180,$sceane1,0.6,0.4,400,300)
		Sprite.draw($bottun1)
		Window.draw_font(50,300,"逃げる",$font1,{:color=>C_BLACK})
		Sprite.draw($hpg2)
		Window.draw_font(350,300,"闘う",$font1,{:color=>C_BLACK})
		Window.draw(340,100,$hpg)
		Window.draw_font(340,100,"#{$hp}",$font1,{:color=>C_BLACK})
		Sprite.draw($point)
		$enemy.draw


		point.x = Input.mouse_pos_x
		point.y = Input.mouse_pos_y
		Input.mouse_enable = false

		result = ($point === $bottun1)
		if result
        bottun1.image = image2
		else
			bottun1.image = image3
		end

		result2 = (point === hpg2)
		if result2
        hpg2.image = image2
		else
			hpg2.image = $image3
		end

		if Input.mouse_push?(M_LBUTTON)
			if result
				  scene = GameMap
				  enemy.reset
			end
		end

		if Input.mouse_push?(M_LBUTTON)
			if result2
        enemy.attack
			end
		end

		if hp == 0
			15.times do
				Window.draw_font(50,100,"戦闘終了",font1,{:color=>C_BLACK})
			end
			scene = GameMap
			enemy.reset
		end

		scene = GameMap if Input.key_push?(K_N)
	end
end

module GameMap

	module_function
	def exec
		#@player.update


		if @player.mx < @min_x

			if @map_x > 0
				@map_x -= 4
				@player.mx += 4
			end
		end
		if @player.mx > @max_x
			if @map_x < @map_base.size_x * 32 - @rt.width
				@map_x += 4
				@player.mx -= 4
			end
		end
		if @player.my < @min_y
			if @map_y > 0
				@map_y -= 4
				@player.y += 4
			end
		end
		if @player.my > @max_y
			if @map_y < @map_base.size_y * 32 - @rt.height
				@map_y += 4
				@player.my -= 4
			end
		end

		if Input.key_down?(K_UP)
			1.times do |i|
				i = rand(30.50)
				if i == 1
					@scene = Sceane
				end
				print i
			end
		end
		if Input.key_down?(K_DOWN)
			1.times do |i|
				i = rand(30.50)
				if i == 1
					@scene = Sceane
				end
				print i
			end
		end
		if Input.key_down?(K_LEFT)
			1.times do |i|
				i = rand(30.50)
				if i == 1
					@scene = Sceane
				end
				print i
			end
		end
		if Input.key_down?(K_RIGHT)
			1.times do |i|
				i = rand(30.50)
				if i == 1
					@scene = Sceane
				end
				print i
			end
		end

		@map_base.draw(@map_x, @map_y)

		@player.draw

		@map_sub.draw(map_x, map_y)

		Window.draw(32, 32, @rt)
	end
end

@scene = GameMap

Window.loop do
  include Sceane
  @scene.exec()
    break if Input.key_push?(K_ESCAPE)

    end
end
