class Nimph 
  
  attr_reader :x, :y
  
  def initialize
	@image = Gosu::Image.new("media/Nimph.png")
    @vel_x = @vel_y = 0
  end
  
  def kill
	#@window.destroy_instance(self)
  end
  
  def checkCollisionA(x,y)
	return Gosu::distance(@x, @y, x, y) < 17
  end
  
  def update
	@x += @vel_x
    @y += @vel_y
	
    if (@x > 640 or @x < 0 or @y > 480 or @y < 0) then  # Return true if outside screen
		return true
	end
	
	return false
	
    # if @window.collisionfighter(@x, @y) and @window.fighterexist then
        # @window.fighter.takedamage(8)
        # @window.destroy_instance(self)
    # end
  end
  
  def warp(x, y, angle)
    @x, @y = x, y
	@angle = angle
	@vel_x = Gosu::offset_x(@angle, 14)
    @vel_y = Gosu::offset_y(@angle, 14)
  end
  
  def draw
    @image.draw_rot(@x, @y, 1, @angle)
  end
end
