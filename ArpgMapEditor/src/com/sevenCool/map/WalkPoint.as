package com.sevenCool.map
{
	import com.sevenCool.util.Colors;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;

	/**
	 * 地图格子类 
	 * @author wangcongyan
	 * @modified wangfuyuan
	 * 
	 */	
	public class WalkPoint extends Sprite
	{
		/**
		 * 卟可行走点 
		 */		
		public static const UN_WALKABLE:int = 0;
		
		/**
		 * 平地 
		 */		
		public static const PLAN_ROAD:int = 1 ;
		
		/**
		 * 山地 
		 */		
		public static const HILL_ROAD:int = 2
		
			
		/**
		 * 水路 
		 */			
		public static const WATER_ROAD:int = 3;
		
		/**
		 * 城墙 
		 */		
		public static const WALL_ROAD:int = 4;
		
		/**
		 * 城门 
		 */		
		public static const GATE_ROAD:int = 5; 
		
		/**
		 * 内城 
		 * */
		public static const INNER_GATE:int = 6 ;
		
		/**
		 * 是否是遮罩 
		 */		
		public var isMask:Boolean = false;
		
		public var _diamond:Shape ;
		
		private var _u:Number;
		private var _v:Number;
		private var _state:int = -1;
		private var _uw:int;
		
		public function WalkPoint(uw:int)
		{
			_diamond = new Shape();
			this.addChild(_diamond);
			_uw = uw;
			init();
		}
		
		
		
		/**
		 * 初始化 
		 * 
		 */		
		private function init():void
		{
			drawGrid();
		}
		
		
		/**
		 * 绘制事件 
		 * @param state
		 */		
		public function drawGrid(state:int = PLAN_ROAD):void
		{
			_diamond.graphics.clear();
			switch(state)
			{
				case UN_WALKABLE://不可行走
					//_diamond.graphics.beginFill(0xf93e3e);
					_diamond.graphics.beginFill(Colors.UN_WALKABLE,.5);
					break;
				case PLAN_ROAD://草地或这平地
					_diamond.graphics.beginFill(Colors.PLAN_ROAD,0.8);
					break;
				case HILL_ROAD://山地 林地 黄色
					_diamond.graphics.beginFill(Colors.HILL_ROAD);
					break;
				case WATER_ROAD://水路 蓝色
					_diamond.graphics.beginFill(Colors.ORANGE);
					break;
				case GATE_ROAD://城门 蓝色
					_diamond.graphics.beginFill(Colors.BLUE);
					break;
				case WALL_ROAD://城墙 黄色
					_diamond.graphics.beginFill(Colors.ORANGE);
					break;
				default:
					throw new Error("state"+state);
			}
			this.alpha = isMask? 0.5 : 0.9 ;
			if(!this.contains(_diamond))this.addChild(_diamond);
		}
		
		//发送设置格子状态事件
		protected function onSetTile(event:Event):void
		{
			//tile_State.onSetTile();
		}
		
		
		
		public function set u($u:Number):void
		{
			_u = $u;
		}
		public function get u():Number
		{
			return _u;
		}
		public function set v($v:Number):void
		{
			
			_v = $v;
		}
		public function get v():Number
		{
			return _v;
		}
		public function get state():int
		{
			return _state;
		}
		public function set state($state:int):void
		{
			_state = $state;
			drawGrid($state)
		}
		public function get uw():int
		{
			return _uw;
		}
		private function set uw($uw:int):void
		{
			_uw = $uw;
		}
	}
}