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
		public var bounds:Rectangle;
		public var copyRectangle:Rectangle;
		
		public function StarField()
		{
			bounds = new Rectangle(0,0,Settings.STAGE_WIDTH, Settings.STAGE_HEIGHT);
			copyRectangle = new Rectangle();
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
		
		private function createStarPool():void
		{
			var i:int = 0;
			entryStar = new Star();
			var previousStar:Star = entryStar;
			do 
			{
				var star:Star = new Star();
				resetStar(star);
				previousStar.next = star;
				previousStar = star;
				i++
			} while(i < Settings.MAX_STARS);
		}
		
		private function updateStars():void
		{
			canvas.lock();
			canvas.fillRect(canvas.rect, 0x000000);
			var star:Star = entryStar;
			while(star)
			{
				var position:Point = star.position.add(star.velocity);
				star.position = position;
				if (!bounds.containsPoint(position))
					resetStar(star);
				copyRectangle.width = star.size; 
				copyRectangle.height = star.size;
				canvas.copyPixels(starBitmapData, copyRectangle, position);
				star = star.next;
			}
			if (doesBlur)
				canvas.applyFilter(canvas, canvas.rect, new Point(), new BlurFilter());
			canvas.unlock();
		}
		
		private function resetStar(star:Star):void
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
		
		private function onKeyDown(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.B)
				doesBlur = !doesBlur;
		}
		
		private function onEnterFrame(event:Event):void
		{
			updateStars();
			profilier.update();
		}
	}
}