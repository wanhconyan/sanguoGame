package  com.core.component
{
	import flash.display.Sprite;
	
	public class PolyState extends Sprite
	{
		private static const DEFAULT_COLOR:uint = 0x999999 ;
		private var _polygon:Polygon  = null;
		
		private var _state:int = 0 ;
		
		private var color:uint = 0 ;
		
		private var _xNode:int ;
		
		private var _yNode:int ;
		public function PolyState($width:Number = 40,$len:int = 6)
		{
			super();
			_polygon = new Polygon($width,$len);
			this.addChild(_polygon);
		}
		
		public function get xNode():int
		{
			return _xNode;
		}

		public function set xNode(value:int):void
		{
			_xNode = value;
		}

		public function get yNode():int
		{
			return _yNode;
		}

		public function set yNode(value:int):void
		{
			_yNode = value;
		}

		public function get sideLength():int
		{
			return _polygon.sideLength;
		}

		/**
		 * 当前选中标识 
		 */
		public function get state():int
		{
			return _state;
		}

		/**
		 * @private
		 */
		public function set state(value:int):void
		{
			_state = value;
			var color:uint = state == 1 ? 0xffffff* Math.random():DEFAULT_COLOR;
			_polygon.draw(color);
		}
	}
}