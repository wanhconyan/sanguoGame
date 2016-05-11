package com.sevenCool.mainView.map
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.graphics.LinearGradient;
	
	import spark.primitives.Rect;
	
	public class MiniMapContainer extends UIComponent
	{
		/**
		 *选择框 
		 */		
		private var _selectBorder:Shape = null;
		
		/**
		 * 地图纹理容器 
		 */		
		private var _backContainer:Sprite = null;
		
		/**
		 *当前地图纹理 
		 */		
		private var _bitmap:Bitmap = null;
		public function MiniMapContainer()
		{
			super();
			this.addEventListener(FlexEvent.CREATION_COMPLETE,onCreate);
			this.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			this.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
		}
		
		protected function onMouseUp(event:MouseEvent):void
		{
			this.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
		}
		
		protected function onMouseDown(event:MouseEvent):void
		{
			this.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);		
		}
		
		protected function onMouseMove(event:MouseEvent):void
		{
			_selectBorder.x = event.localX ;
			_selectBorder.y = event.localY ;
		}
		
		/**
		 * 当前地图纹理 
		 */
		public function get bitmap():Bitmap
		{
			return _bitmap;
		}

		/**
		 * @private
		 */
		public function set bitmap(value:Bitmap):void
		{
			_bitmap = value;
		}

		
		public function createMiniMap():void
		{
			
			
		}
		
		
		protected function onCreate(event:FlexEvent):void
		{
			this.graphics.beginFill(0xf0f0f0);
			this.graphics.drawRect(0,0,this.width,this.height);
			this.graphics.endFill() ;
			_selectBorder = new Shape();
			_backContainer = new Sprite();
			draw();
			drawSelect();
			_backContainer.x = 4; 
			_backContainer.y = 4;
			this.addChild(_backContainer);
			_bitmap = new Bitmap(new BitmapData(126,126,true,0x916536));
			_backContainer.addChild(_bitmap);
			_backContainer.addChild(_selectBorder);
		}
		
		private function draw():void
		{
			this.graphics.clear() ;
			this.graphics.lineStyle(4,0,1);
			this.graphics.drawRect(0,0,130,130);
			this.graphics.endFill() ;
		}
		
		private function drawSelect($w:Number=26,$h:Number=13):void
		{
			_selectBorder.graphics.clear() ;
			_selectBorder.graphics.lineStyle(1,0x00ffff,1);
			_selectBorder.graphics.drawRect(0,0,$w,$h);
			_selectBorder.graphics.endFill() ;
		}
	}
}