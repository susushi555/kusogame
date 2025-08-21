class BattleSceane
	# main.rbで再定義したため、このクラスは不要
end

class Bottun < Sprite
    def initialize(x,y, image_path="~kusogame/image/bottun1.jpg")
        super
        begin
          self.image = Image.load(image_path)
        rescue DXRuby::DXRubyError
          puts "ボタン画像 '#{image_path}' が見つかりません。"
          # 代替の画像を生成
          self.image = Image.new(100, 40, C_BLUE)
        end
        self.image.set_color_key(C_WHITE)
        self.x = x
        self.y = y
        @font = Font.new(30,"MS明朝",{:weight=>false, :italic=>false})
    end

    def draw(text)
        super()
        Window.draw_font(self.x + 10, self.y + 5, text, @font, {:color=>C_BLACK})
    end
end

class Sceane
	# main.rbで再定義したため、このクラスは不要
end