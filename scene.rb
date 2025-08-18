module Sceane
    image = Image.new(20,20,C_CYAN)
    $image2 = Image.load("~/kusogame/image/bottun1.jpg")
    $image3 = Image.load("~/kusogame/image/bottun1.jpg")
    $image3.set_color_key(C_WHITE)

    bottun = Image.load("~/kusogame/image/bottun1.jpg")
    $bottun1 = Sprite.new(0,270,bottun)
    $sceane1 = Image.load("~/kusogame/image/BG00a1_80.jpg")
    hpg2 = Image.load("~/kusogame/image/bottun1.jpg")
	$hpg2 = Sprite.new(300,270,hpg2)
    $point = Sprite.new(0,0,image)
	$hpg = Image.new(120,40,C_GREEN)

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


		$point.x = Input.mouse_pos_x
		$point.y = Input.mouse_pos_y
		Input.mouse_enable = false

		result = ($point === $bottun1)
		if result
        $bottun1.image = $image2
		else
			$bottun1.image = $image3
		end

		result2 = ($point === $hpg2)
		if result2
        $hpg2.image = $image2
		else
			$hpg2.image = $image3
		end

		if Input.mouse_push?(M_LBUTTON)
			if result
				  $scene = GameMap
				  $enemy.reset
			end
		end

		if Input.mouse_push?(M_LBUTTON)
			if result2
                  $enemy.attack
			end
		end

		if $hp == 0
			15.times do
				Window.draw_font(50,100,"戦闘終了",$font1,{:color=>C_BLACK})
			end
			$scene = GameMap
			$enemy.reset
		end

		$sceane = GameMap if Input.key_push?(K_N)
	end
end
