require 'gosu'
require_relative 'timer'
require_relative 'player'
require_relative 'star'
require_relative 'nimph'

class GameWindow < Gosu::Window
	def initialize
		super 640, 480
		self.caption = "Gosu Tutorial Game"
		
		@background_image = Gosu::Image.new("media/space.png", :tileable => true)
		
		@player = Player.new
		@player.warp(320, 240)
		
		@star_anim = Gosu::Image::load_tiles("media/star.png", 25, 25)
		@stars = Array.new
		
		@nimphs = Array.new
		@shot_delay = 10
		@shot_ready = true
		
		@font = Gosu::Font.new(20)
		
		@timers = Array.new
	end
	
	def shot_ready(arg)
		@shot_ready = true
	end
	
	def startTimer(delay, meth, arg)
		timer = Timer.new(delay, meth, arg)
		@timers.push(timer)
		return timer
	end
	
	def update
		if Gosu::button_down? Gosu::KbLeft or Gosu::button_down? Gosu::GpLeft then
			@player.turn_left
		end
		if Gosu::button_down? Gosu::KbRight or Gosu::button_down? Gosu::GpRight then
			@player.turn_right
		end
		if Gosu::button_down? Gosu::KbUp or Gosu::button_down? Gosu::GpUp then
			@player.accelerate
		end
		if Gosu::button_down? Gosu::KbZ and @shot_ready then
			nimph = Nimph.new
			nimph.warp(@player.x, @player.y, @player.angle)
			@nimphs.push(nimph)
			startTimer(@shot_delay, self.method( :shot_ready ), 0 )
			@shot_ready = false
		end
		
		@player.move
		@player.collect_stars(@stars)
		
		if rand(100) < 4 and @stars.size < 25 then
			@stars.push(Star.new(@star_anim))
		end
		
		@nimphs.reject! { |nimph| nimph.update}
		
		@timers.reject! { |timer| timer.update}
	end
	
	def draw
		@player.draw
		@background_image.draw(0, 0, 0)
		@stars.each { |star| star.draw}
		@nimphs.each { |nimph| nimph.draw}
		@font.draw("Score: #{@player.score}", 10, 10, 2, 1.0, 1.0, 0xff_ffff00)
		@font.draw("Nimphs: #{@nimphs.size}", 10, 40, 2, 1.0, 1.0, 0xff_ffff00)
	end
	
	def button_down(id)
		if id == Gosu::KbEscape
			close
		end
	end
end

window = GameWindow.new
window.show