require "dxruby"
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
        self.image = Image.load("D:/PortableRuby/workspace/test4/image/bottun1.jpg")
        self.image.set_color_key(C_WHITE)
        self.x = x
        self.y = y
        @font1 = Font.new(30,"MS明朝",{:weight=>false, :italic=>false})
    end

    def draw
        Window.draw(self.x,self.y,self.image)
        Window.draw_font(50,300,"戦う",@font1,{:color=>C_BLACK})
    end

end

class Sceane
    def initialize
        @image = Image.load("C:/Krasnacht/test/image/BG00a1_80.jpg")
    end

    def draw
        Window.draw(0,480,@image)
        Window.draw_scale(-160,-180,@image,0.6,0.4,400,300)
    end
end

image = Image.new(20,20,C_CYAN)
image2 = Image.load("D:\PortableRuby\workspace\test4\image\bottun1.jpg")
image3 = Image.load("D:\PortableRuby\workspace\test4\image\bottun1.jpg")
image3.set_color_key(C_WHITE)

sceane = BattleSceane.new
bottun1 = Bottun.new(0,270)
sceane1 = Sceane.new

point = Sprite.new(0,0,image)



Window.loop do
    sceane.draw
    bottun1.draw
    sceane1.draw
    point.draw

    point.x = Input.mouse_pos_x
    point.y = Input.mouse_pos_y

    result = (point === bottun1)
    p result
    if result
        bottun1.image = image2
    else
        bottun1.image = image3
    end

    if Input.mouse_push?(M_LBUTTON)
        if result

        end
    end

    break if Input.key_push?(K_ESCAPE)
end
