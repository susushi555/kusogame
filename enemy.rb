class Enemy
  attr_reader :hp

  def initialize(image_path)
    begin
      @image = Image.load(image_path)
    rescue DXRuby::DXRubyError
      puts "敵画像 '#{image_path}' が見つかりません。"
      exit
    end
    @x = 340
    @y = 120
    @hp = 10
  end

  def attack
    damage = rand(2..4) # 2から4の間のダメージ
    @hp -= damage
    puts "#{damage}のダメージ！" # コンソールにダメージ表示
  end

  def reset
    @hp = 10
  end

  def draw
    Window.draw(@x, @y, @image)
  end
end
