package
{
	import art.StarGraphic;
	
	import config.Settings;
	
	import entities.Star;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	
	import utilities.Profiler;
	
	[SWF(width="640", height="480", frameRate="50", backgroundColor="#000000")]
	public class StarField extends Sprite
	{
		public static const MAX_RADIANS:Number = Math.PI * 2;
		//entry point to access the linked list
		public var entryStar:Star;
		//the only instance of the star graphic
		public var starBitmapData:BitmapData;
		public var canvas:BitmapData;
		public var profilier:Profiler;
		public var doesBlur:Boolean;
		
		public function StarField()
		{
			profilier = new Profiler();
			canvas = new BitmapData(Settings.STAGE_WIDTH, Settings.STAGE_HEIGHT, false);
			starBitmapData = new BitmapData(Settings.MAX_STAR_SIZE, Settings.MAX_STAR_SIZE, false);
			starBitmapData.draw(new StarGraphic(Settings.MAX_STAR_SIZE));
			createStarPool();
			addChild(new Bitmap(canvas));
			addChild(profilier.textField);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyDown);
		}
		
		protected function onKeyDown(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.B)
				doesBlur = !doesBlur;
		}
		
		private function createStarPool():void
		{
			var i:int = 0;
			entryStar = new Star();
			var previousStar:Star = entryStar;
			do 
			{
				var star:Star = new Star();
				initializeStar(star);
				previousStar.next = star;
				previousStar = star;
				i++
			} while(i < Settings.MAX_STARS);
		}
		
		public function onEnterFrame(event:Event):void
		{
			updateStars();
			profilier.update();
		}
		
		private function updateStars():void
		{
			canvas.lock();
			canvas.fillRect(canvas.rect, 0x000000);
			var star:Star = entryStar;
			while(star)
			{
				star.update();
				if (isOutOfBounds(star))
					initializeStar(star);
				canvas.copyPixels(starBitmapData, new Rectangle(0,0, star.size, star.size), star.position);
				star = star.next;
			}
			if (doesBlur)
				canvas.applyFilter(canvas, canvas.rect, new Point(), new BlurFilter());
			canvas.unlock();
		}
		
		private function initializeStar(star:Star):void
		{
			var angle:Number = Math.random() * MAX_RADIANS;
			var random:Number = Math.random();
			var speed:Number = .1 + (random * Settings.MAX_STAR_SPEED); //'.1' so stars dont get stuck at 0 speed
			var cos:Number = Math.cos(angle);
			var sin:Number = Math.sin(angle);
			star.velocity.x = cos * speed;
			star.velocity.y = sin * speed;
			star.size = random * Settings.MAX_STAR_SIZE;
			star.position = new Point(Settings.HALF_WIDTH + (cos * ((random - .1) * Settings.HALF_WIDTH)), Settings.HALF_HEIGHT + (sin * ((random - .1)* Settings.HALF_HEIGHT)));
		}
		
		//try rect.contains
		public function isOutOfBounds(star:Star):Boolean
		{
			const x:Number = star.position.x;
			const y:Number = star.position.y;
			if (x > Settings.STAGE_WIDTH || x < 0 || y > Settings.STAGE_HEIGHT || y < 0)
				return true;
			return false;
		}
	}
}