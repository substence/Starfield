package entities
{
	import art.StarGraphic;
	
	import flash.geom.Point;

	public class Star
	{
		public var position:Point;
		public var size:uint;
		public var velocity:Point;
		public var next:Star;//works as a psuedo linked-list
		
		public function Star()
		{
			position = new Point();
			size = 0;
			velocity = new Point();
		}
		
		public function update():void
		{
			position = position.add(velocity);
		}
	}
}