 require "dxruby"
 require_relative "map"
 require_relative "enemy"
 require_relative "imgset"

-# ファイルパスを相対パスに変更
-# 画像やデータファイルは、実行するスクリプトからの相対パスで指定するのが一般的です。
-# この例では、スクリプトがプロジェクトのルートディレクトリにあると仮定しています。
-MAP_IMAGE_PATH = "C:/Users/dotdo/OneDrive/ドキュメント/GitHub/kusogame/image/640x480/map1.png"
-MAP_DATA_PATH = "C:/Users/dotdo/OneDrive/ドキュメント/GitHub/kusogame/mdat/map2.dat"
-MAP_SUB_DATA_PATH = "C:/Users/dotdo/OneDrive/ドキュメント/GitHub/kusogame/mdat/map_sub3.dat"
-BG_IMAGE_PATH = "C:/Users/dotdo/OneDrive/ドキュメント/GitHub/kusogame/image/BG00a1_80.jpg"
-BUTTON_IMAGE_PATH = "C:/Users/dotdo/OneDrive/ドキュメント/GitHub/kusogame/image/bottun1.jpg"
-ENEMY_IMAGE_PATH = "C:/Users/dotdo/OneDrive/ドキュメント/GitHub/kusogame/image/ruby.png"
+# ファイルパスを相対パスで指定する
+BASE_DIR = __dir__
+MAP_IMAGE_PATH    = File.join(BASE_DIR, "image", "640x480", "map1.png")
+MAP_DATA_PATH     = File.join(BASE_DIR, "mdat", "map2.dat")
+MAP_SUB_DATA_PATH = File.join(BASE_DIR, "mdat", "map_sub3.dat")
+BG_IMAGE_PATH     = File.join(BASE_DIR, "image", "BG00a1_80.jpg")
+BUTTON_IMAGE_PATH = File.join(BASE_DIR, "image", "bottun1.jpg")
+ENEMY_IMAGE_PATH  = File.join(BASE_DIR, "image", "ruby.png")

 # マップ画像の読み込み
-begin
-  @mapimage = Image.load_tiles(MAP_IMAGE_PATH, 8, 11)
+$mapimage = begin
+  Image.load_tiles(MAP_IMAGE_PATH, 8, 11)
 rescue DXRuby::DXRubyError
   puts "マップ画像 '#{MAP_IMAGE_PATH}' が見つかりません。"
   exit
 end

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
       @mx, @my, @map, @target = x, y, map, target
-      @map2 = map2 # map2をインスタンス変数として保持
+      # map2 はプレイヤーの移動制限に利用する衝突判定用マップ
+      @map2 = map2
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
         end
     end
 end

-@rt = RenderTarget.new(640-64, 480-64)
+$rt = RenderTarget.new(640-64, 480-64)

 # フォントの定義
 $font1 = Font.new(30,"MS明朝",{:weight=>false, :italic=>false})

 # マップの読み込み
-begin
-  map_base = Map.new(MAP_DATA_PATH, @mapimage, @rt)
-  map_sub = Map.new(MAP_SUB_DATA_PATH, @mapimage, @rt)
+$map_base = begin
+  Map.new(MAP_DATA_PATH, $mapimage, $rt)
 rescue Errno::ENOENT
   puts "マップデータファイルが見つかりません。"
   exit
 end

-@player = Player.new(480, 480, @map_sub, @map_base, @rt)
+$map_sub = begin
+  Map.new(MAP_SUB_DATA_PATH, $mapimage, $rt)
+rescue Errno::ENOENT
+  puts "マップデータファイルが見つかりません。"
+  exit
+end

-@map_x = @player.mx
-@map_y = @player.my
+$player = Player.new(480, 480, $map_sub, $map_base, $rt)

-@min_x = 128
-@max_x = 640 - 64 - 128 - 32
-@min_y = 128
-@max_y = 480 - 64 - 128 - 32
+$map_x = $player.mx
+$map_y = $player.my

 $enemy = Enemy.new(ENEMY_IMAGE_PATH) # 敵キャラクターの生成

 # Sceaneモジュールをクラスとして再定義
 class BattleScene
   def initialize
     begin
       @image2 = Image.load(BUTTON_IMAGE_PATH)
       @image3 = Image.load(BUTTON_IMAGE_PATH)
       @image3.set_color_key(C_WHITE)
       @sceane1 = Image.load(BG_IMAGE_PATH)
     rescue DXRuby::DXRubyError => e
       puts "戦闘シーンの画像読み込みに失敗しました: #{e.message}"
       exit
     end

     @bottun1 = Sprite.new(0, 270, @image3.dup) # dupで画像を複製
     @hpg2 = Sprite.new(300, 270, @image3.dup)
     @point = Sprite.new(0, 0, Image.new(1, 1, C_CYAN)) # 1x1の見えないスプライト
     @hpg = Image.new(120, 40, C_GREEN)

     Window.width = 480
     Window.height = 480
     Input.mouse_enable = false
   end
diff --git a/main.rb b/main.rb
index ce89114cf5eedef44ca66aaf5234ed5c3512c8de..0cf41de81c00f7f2309a440ac3825eaf2c35c442 100644
--- a/main.rb
+++ b/main.rb
@@ -161,88 +162,68 @@ class BattleScene

     if Input.mouse_push?(M_LBUTTON)
       if @point === @bottun1
         $scene = :game_map
         $enemy.reset
       elsif @point === @hpg2
         $enemy.attack
       end
     end

     if $enemy.hp <= 0
       Window.draw_font(50, 100, "戦闘終了", $font1, {:color=>C_BLACK})
       Window.update # 画面を更新してメッセージを表示
       sleep(1) # 1秒待つ
       $scene = :game_map
       $enemy.reset
     end

     $scene = :game_map if Input.key_push?(K_N)
   end
 end

 module GameMap
   module_function
   def exec
+    prev_x = $player.mx
+    prev_y = $player.my

-    #@player.update
+    $player.update

-    # プレイヤーの移動とマップスクロールのロジック
-    dx = 0
-    dy = 0
-
-    if Input.key_down?(K_UP)
-      dy = -4
-    elsif Input.key_down?(K_DOWN)
-      dy = 4
-    elsif Input.key_down?(K_LEFT)
-      dx = -4
-    elsif Input.key_down?(K_RIGHT)
-      dx = 4
-    end
-
-    # 移動先に障害物がないかチェック
-    #if @map_base[(@player.mx + dx) / 32, (@player.my + dy) / 32] == 0
-    #  @player.mx += dx
-    #  @player.my += dy
-    #end
-
-    # スクロール処理
-    #@map_x = @player.mx - (Window.width / 2)
-    #@map_y = @player.my - (Window.height / 2)
+    # プレイヤーを中心にスクロール
+    $map_x = $player.mx - $rt.width / 2
+    $map_y = $player.my - $rt.height / 2

+    $player.x = $player.mx - $map_x
+    $player.y = $player.my - $map_y

     # 敵とのエンカウント判定
-    if (dx != 0 || dy != 0) && rand(100) < 5 # 5%の確率でエンカウント
-        $scene = :battle
+    if ($player.mx != prev_x || $player.my != prev_y) && rand(100) < 5
+      $scene = :battle
     end

-    print @map_base
-
     # 描画処理
-    @rt.draw_tile(0, 0, map_base.map_date, mapimage, @map_x, @map_y,
-                  (@rt.width + @mapimage[0].width - 1) / @mapimage[0].width,
-                  (@rt.height + @mapimage[0].height - 1) / @mapimage[0].height)
+    $rt.draw_tile(0, 0, $map_base.mapdata, $mapimage, $map_x, $map_y,
+                  ($rt.width + $mapimage[0].width - 1) / $mapimage[0].width,
+                  ($rt.height + $mapimage[0].height - 1) / $mapimage[0].height)

-    #@player.x = @player.mx - @map_x
-    #@player.y = @player.my - @map_y
-    #@player.draw
+    $player.draw

-    @rt.draw_tile(0, 0, map_sub.map_date, @mapimage, @map_x, @map_y,
-                   (@rt.width + @mapimage[0].width - 1) / @mapimage[0].width,
-                   (@rt.height + @mapimage[0].height - 1) / @mapimage[0].height)
+    $rt.draw_tile(0, 0, $map_sub.mapdata, $mapimage, $map_x, $map_y,
+                  ($rt.width + $mapimage[0].width - 1) / $mapimage[0].width,
+                  ($rt.height + $mapimage[0].height - 1) / $mapimage[0].height)

-    Window.draw(32, 32, @rt)
+    Window.draw(32, 32, $rt)
   end
 end

 # シーンの管理
 $scenes = {
   game_map: GameMap,
   battle: BattleScene.new
 }
 $scene = :game_map

 Window.loop do
   $scenes[$scene].exec()
   break if Input.key_push?(K_ESCAPE)
 end
