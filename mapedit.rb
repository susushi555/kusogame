# �ȈՃ}�b�v�G�f�B�^
require 'dxruby'
require_relative 'map'

# �}�b�v�f�[�^
map = Array.new(60) { [1] * 60 }

# �G�̃f�[�^�����
mapimage = Image.load_tiles("C:/Krasnacht/test3/image/640x480/pipo-map001.png",8,11)



wakuimage = Image.new(36, 36).box(0, 0, 35, 35, [255, 255, 255, 255]) # �I��g

rt = RenderTarget.new(32*32, 32*32)

filename = Window.open_filename([["dat file(*.dat)", "*.dat"]], "open file name")
ext = File.extname(filename)
basename = File.basename(filename, ext)

map_base = Map.new(filename, mapimage, rt)
map_sub = Map.new(basename + "_sub" + ext, mapimage, rt)

select = 19

Window.height = 512

# ���C�����[�v
Window.loop do

  # �}�E�X���N���b�N
  if Input.mouse_down?(M_LBUTTON) then
    x, y = Input.mouse_pos_x, Input.mouse_pos_y
    if x >= 512 then # �E�̂ق��Ȃ�
      for i in 0..9
        if x >= 560 and x < 592 and y >= i * 64 + 64 and y < i * 64 + 96 then
          select = i
          break
        end
      end
    else            # ���̂ق��Ȃ�
      if x > 0 and y > 0 and y < 512 then
        map_base[x/16, y/16] = select
        map_sub[x/16, y/16-1] = (select == 2 ? 1 : nil)
      end
    end
  end

  # �I��g�`��
  Window.draw(558, select * 64 + 62, wakuimage)

  # �}�b�v�`�b�v�`��
  for i in 0..9
    Window.draw(560, i * 64 + 64, mapimage[9])
  end

  # �}�b�v��rt�ɕ`��
  map_base.draw(0, 0)
  map_sub.draw(0, 0)

  # �S�̐}�`��
  Window.draw_ex(0, 0, rt, :center_x => 0, :center_y => 0, :scale_x => 0.5, :scale_y => 0.5)

  if Input.key_push?(K_ESCAPE) then
    filename = Window.save_filename([["dat file(*.dat)", "*.dat"]], "save file name")
    if filename
      ext = File.extname(filename)
      basename = File.basename(filename, ext)
      File.open(filename, "wt") do |fh|
        map_base.mapdata.each do |line|
          data = ""
          line.each do |o|
            data += o.to_s
          end
          fh.puts(data)
        end
      end
      File.open(basename + "_sub" + ext, "wt") do |fh|
        map_sub.mapdata.each do |line|
          data = ""
          line.each do |o|
            if o
              data += "4"
            else
              data += "x"
            end
          end
          fh.puts(data)
        end
      end
      break
    end
  end
end
