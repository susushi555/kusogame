module MainMenu
	Window.width = 480
	Window.height = 480
	image = Image.new(120,60,C_BLUE)
	$bottun = Sprite.new(130,130,image)
	image1 = Image.new(20,20,C_CYAN)
	$point = Sprite.new(0,0,image1)
	
	module_function
	def exec
		Sprite.draw($bottun)
		Window.draw_font(130,130,"始める",$font1,{:color=>C_BLACK})
		Sprite.draw($point)
		
		$point.x = Input.mouse_pos_x
		$point.y = Input.mouse_pos_y
		Input.mouse_enable = false
		
		result = ($bottun === $point)
		
		if Input.mouse_push?(M_LBUTTON)
			if result
				$scene = GameMap
			end
		end
	end
end
		