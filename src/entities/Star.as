package entities
{
	import art.StarGraphic;
	
	import flash.geom.Point;

	public class Star
	{
		public var position:Point;
		public var size:Number;
		public var velocity:Point;
		public var next:Star;//works as a psuedo linked-list
		
		public function Star()
		{
			size = 0;
			position = new Point();
			velocity = new Point();
		}
	}
}