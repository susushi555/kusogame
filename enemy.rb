class Enemy
	def initialize
		@image = Image.load("D:\PortableRuby\workspace\test4\image/ruby.png")
		x = 340
		y = 120
	end

	$hp = 10
	def attack
		$hp = $hp - rand(3.4)
		Window.draw_font(120,200,"ダメージ",$font1,{:color=>C_BLACK})
	end

	def reset
		$hp = 10
	end

	def draw
		Window.draw(340,120,@image)
	end
end
