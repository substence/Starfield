package entities
{
	import art.StarGraphic;
	
	import flash.geom.Point;

	public class Star
	{
		public var position:Point;
		public var size:uint;
		public var velocity:Point;
		public var graphic:StarGraphic;
		
		public function Star()
		{
			position = new Point();
			size = 0;
			velocity = new Point();
			//graphic = new StarGraphic();
		}
		
		public function setup():void
		{
			
		}
		
		public function update():void
		{
			position = position.add(velocity);
		}
		
		public function draw():void
		{
			//graphic.x = x;
			//graphic.y = y;
		}
	}
}