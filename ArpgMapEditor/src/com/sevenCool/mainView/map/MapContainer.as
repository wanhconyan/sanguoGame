package com.sevenCool.mainView.map
{
	import com.sevenCool.manager.MapManager;
	import com.sevenCool.map.MapData;
	import com.sevenCool.map.Node;
	
	import flash.display.Stage;
	import flash.events.MouseEvent;
	
	import mx.core.FlexGlobals;
	import mx.core.UIComponent;
	
	public class MapContainer extends UIComponent
	{
		/**
		 * 设置当前单利 
		 */		
		private static var _isInstance:Boolean = false;
		
		private static var _instance:MapContainer = null;
		
		private var _map:Map = null;
		public function MapContainer()
		{
			super();
			_map = new Map();
			this.addChild(_map);
			_map.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			_map.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
		}
		
		
		private var _lastX:Number = 0 ;
		private var _lastY:Number = 0 ;
		protected function onMouseMove(event:MouseEvent):void
		{
			if(!MapManager.getInstance().isMove)
			{
				return ;
			}
			_map.x += event.stageX - _lastX ;
			_map.y += event.stageY - _lastY ;
			rejustMap();
			_lastX = event.stageX;
			_lastY = event.stageY;
		}
		
		
		/**
		 * 设置当前地图位置信息 
		 */		
		private function rejustMap():void
		{
			if(_map.x >= 0)
			{
				_map.x =0;
			}
			if(_map.y >= 0)
			{
				_map.y = 0;
			}
			if(_map.x <= -_map.width + stage.stageWidth)
			{
				_map.x = -_map.width + stage.stageWidth;
			}
			if(_map.y <= -_map.height + stage.stageHeight)
			{
				_map.y = -_map.height + stage.stageHeight;
			}
		}
		
		protected function onMouseUp(event:MouseEvent):void
		{
			_map.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
		}
		
		protected function onMouseDown(event:MouseEvent):void
		{
			_map.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			_lastX = event.stageX;
			_lastY = event.stageY;
		}
		
		/**
		 * 地图 
		 */
		public function get map():Map
		{
			return _map;
		}

		/**
		 * 地图创建器 
		 */
		public static function get instance():MapContainer
		{
			return _instance;
		}

		/**
		 * @private
		 */
		public static function set instance(value:MapContainer):void
		{
			if(_isInstance)
			{
				throw new Error("you can't set a instance twice!");
			}
			_instance = value;
			_isInstance = true;
		}
		
		
		/**
		 * 创建地图
		 */
		public function createMap($mapData:MapData):void
		{
			_map.createMap($mapData);
		}
	}
}