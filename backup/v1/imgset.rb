class BattleSceane
	WINDOW_WIDTH = 480
    WINDOW_HEIGHT = 480

    def initialize
        Window.width = WINDOW_WIDTH
        Window.height = WINDOW_HEIGHT
        @image = Image.new(WINDOW_WIDTH,WINDOW_HEIGHT,C_WHITE)
        @image.box_fill(0,480,480,240,C_YELLOW)
    end

    def draw
        Window.draw(0,0,@image)
    end
end

class Bottun < Sprite
    def initialize(x,y)
        super
        self.image = Image.load("~kusogame/image/bottun1.jpg")
        self.image.set_color_key(C_WHITE)
        self.x = x
        self.y = y
        self.font1 = Font.new(30,"MS明朝",{:weight=>false, :italic=>false})
    end

    def draw
        Window.draw(self.x,self.y,self.image)
        Window.draw_font(50,300,"戦う",@font1,{:color=>C_BLACK})
    end

end

class Sceane
    def initialize
        @image = Image.load("~/kusogame/image/BG00a1_80.jpg")
    end

    def draw
        Window.draw(0,480,@image)
        Window.draw_scale(-160,-180,@image,0.6,0.4,400,300)
    end
end
