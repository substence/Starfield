package
{
	import art.StarGraphic;
	
	import config.Settings;
	
	import entities.Star;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import utilities.Profiler;
	
	[SWF(width="640", height="480", frameRate="50", backgroundColor="#000000")]
	public class StarField extends Sprite
	{
		public var entryStar:Star;
		public var canvas:BitmapData;
		public var starBitmapData:BitmapData;
		public var profilier:Profiler;
		//
		private var _scaleMatrix:Matrix;
		
		public function StarField()
		{
			profilier = new Profiler();
			_scaleMatrix = new Matrix();
			canvas = new BitmapData(Settings.STAGE_WIDTH, Settings.STAGE_HEIGHT, true, 0);
			starBitmapData = new BitmapData(Settings.MAX_STAR_SIZE, Settings.MAX_STAR_SIZE, true, 0);
			starBitmapData.draw(new StarGraphic(Settings.MAX_STAR_SIZE));
			createStarPool();
			addChild(new Bitmap(canvas));
			addChild(profilier.textField);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function createStarPool():void
		{
			var i:int = 0;
			entryStar = new Star();;
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
			canvas.unlock();
		}
		
		private function initializeStar(star:Star):void
		{
			var angle:Number = Math.random() * (Math.PI * 2);
			var speed:Number = .1 + (Math.random() * Settings.MAX_STAR_SPEED);
			star.velocity.x = Math.cos(angle) * speed;
			star.velocity.y = Math.sin(angle) * speed;
			star.size = (speed / Settings.MAX_STAR_SPEED) * Settings.MAX_STAR_SIZE;
			star.position = new Point(Settings.HALF_WIDTH + (star.velocity.x * 75), Settings.HALF_HEIGHT + (star.velocity.y * 75));
		}
		
		//try rect.contains
		public function isOutOfBounds(star:Star):Boolean
		{
			const width:uint = Settings.STAGE_WIDTH;
			const height:uint = Settings.STAGE_HEIGHT;
			const x:Number = star.position.x;
			const y:Number = star.position.y;
			if (x > width || x < 0 || y > height || y < 0)
				return true;
			return false;
		}
	}
}