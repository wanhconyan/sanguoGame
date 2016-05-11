package com.sevenCool.mainView.map
{
	import flash.display.Sprite;
	
	public class MapGrid extends Sprite
	{
		public static const WALK_ROAD:int = 1 ;
		
		public static const UN_WALK_ROAD:int =2 ;
		
		public static const MASK:int =3 ;
		
		public static var WIDTH:int = 30 ;
		
		public static var HEIGHT:int = 30 ;
		
		public var nx:int = 0 ;
		public var ny:int = 0 ;
		
		/**
		 * 当前格子行走状态 
		 */		
		private var _walkable:Boolean = true;
		
		private var _isMask:Boolean = false;
		public function MapGrid()
		{
			super();
			this.alpha = 0.5 ;
		}
		
		
		/**
		 *是否是遮罩
		 */
		public function get isMask():Boolean
		{
			return _isMask;
		}

		/**
		 * @private
		 */
		public function set isMask(value:Boolean):void
		{
			_isMask = value;
			draw()
		}

		/**
		 * 行走状态 
		 */
		public function get walkable():Boolean
		{
			return _walkable;
		}

		/**
		 * @private
		 */
		public function set walkable(value:Boolean):void
		{
			_walkable = value;
			draw() ;
		}

		/**
		 * 获取当前格子颜色 
		 * @return 
		 */		
		public function get color():uint
		{
			var color:uint = walkable ? 0x00ff00:0 ;
			color = isMask ? 0x0ffc00:color ;
			return color;	
		}
		
		/**
		 * 重绘
		 */		
		public function draw():void
		{
			this.graphics.clear();
			this.graphics.beginFill(color);
			this.graphics.lineStyle(1,0xffffff);
			this.graphics.drawRect(0,0,WIDTH,HEIGHT);
			this.graphics.endFill() ;
			trace("MapGrid.draw()" + color);
		}
	}
}