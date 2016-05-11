package com.sevenCool.mainView.map
{
	import com.sevenCool.loader.LoadManager;
	import com.sevenCool.manager.MapManager;
	import com.sevenCool.map.MapData;
	import com.sevenCool.map.Node;
	import com.sevenCool.map.WalkPoint;
	
	import flash.display.Bitmap;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class Map extends Sprite
	{
		/**
		 * 当前地图信息 
		 */		
		private var _mapData:MapData = null;
		
		private var _grids:Vector.<MapGrid> = null;
		
		public var backImg:Bitmap = null;
		
		private var _url:String = null;
		
		public function Map()
		{
			backImg = new Bitmap();
			this.addChild(backImg);
			this.addEventListener(MouseEvent.MOUSE_MOVE,onMouseClick);
		}
		

		protected function onMouseClick(event:MouseEvent):void
		{
			var grid:MapGrid = null;
			if(event.target is MapGrid && MapControl.getIntance().brush)
			{
				grid = event.target as MapGrid;
				grid.isMask = (MapManager.getInstance().brush == MapGrid.MASK);
				grid.walkable = (MapManager.getInstance().brush == MapGrid.WALK_ROAD);
				_mapData.nodes[grid.nx][grid.ny].isMask = grid.isMask ;
				_mapData.nodes[grid.nx][grid.ny].walkable = grid.walkable ;
			}			
		}
		
		/**
		 * 创建地图
		 */
		public function createMap($mapData:MapData):void
		{
			_mapData = $mapData ;
			addBackImage();
			var len:int = _mapData.nodes.length ;
			var grid:MapGrid = null;
			var node:Node = null;
			MapGrid.WIDTH = $mapData.nodeWidth ;
			MapGrid.HEIGHT = $mapData.nodeHegiht ;
			clear();
			var i:int ;
			var j:int ;
			if(len == 0 )
			{
				for( i = 0 ; i < $mapData.row ;i++)
				{
					_mapData.nodes[i] = new Vector.<Node>();
					for( j = 0 ; j<$mapData.col ; j ++)
					{
						grid = new MapGrid();
						node = Node.getNode() as Node;
						grid.walkable = true;
						node.x = grid.x = i * MapGrid.WIDTH;
						node.y = grid.y = j * MapGrid.HEIGHT;
						node.x = i * MapGrid.WIDTH;
						node.y = j * MapGrid.HEIGHT;
						grid.nx = node.nx = i ;
						grid.ny = node.ny = j ;
						_mapData.nodes[i].push(node);
						_grids.push(grid);
						this.addChild(grid);
					}
				}
			}
			for( i = 0 ; i < len ; i ++)
			{
				for(j = 0 ; j<$mapData.col ; j ++)
				{
					grid = new MapGrid();
					node = _mapData.nodes[i][j];
					grid.isMask = node.isMask ;
					grid.walkable = node.walkable ;
					grid.x = node.x ;
					grid.y = node.y;
					grid.nx = node.nx  ;
					grid.ny = node.ny ;
					_grids.push(grid);
					this.addChild(grid);
				}
			}
		}
		
		private function clear():void
		{
			if(!_grids)
			{
				_grids = new Vector.<MapGrid>()
			}else
			{
				var len:int = _grids.length ;
				for(var i:int = 0 ; i < len ; i ++)
				{
					_grids[i] = null;
					if(this.contains(_grids[i]))
					{
						this.removeChild(_grids[i]);
					}
				}
				_grids = new Vector.<MapGrid>();
			}
		}
		
		/**
		 * 添加背景图 
		 * 
		 */		
		protected function addBackImage():void
		{
			LoadManager.getInstance().loadData(_mapData.mapUrl,imageLoadComplete);
		}
		
		
		/**
		 * 地图背景加载完成 
		 * @param $event
		 */
		private function imageLoadComplete($event:Event):void
		{
			if(backImg.bitmapData)
			{
				backImg.bitmapData.dispose() ;
			}
			var target:LoaderInfo = $event.target as LoaderInfo;
			backImg.bitmapData = (target.content as Bitmap).bitmapData;
		}
	}
}