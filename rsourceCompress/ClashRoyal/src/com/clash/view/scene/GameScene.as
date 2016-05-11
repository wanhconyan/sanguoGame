package com.clash.view.scene
{
	import com.clash.component.City;
	
	import flash.display.Sprite;
	
	public class GameScene extends Sprite
	{
		public var enemy:Array = [];
		
		public var hero:Array = [];
		
		public var enemyCitys:Array= [];
		
		public var heroCitys:Array = [];
		
		public var cardBoard:CardBoard;
		
		private static var cityNum:int = 3; 
		
		public function GameScene()
		{
			super();
		}
		
		public function start():void
		{
		
			initScene();
		}
		
		public function initScene():void
		{
			var enemyCity:City ;
			var heroCity:City ;
			for (var i:int = 0 ;i < cityNum ; i ++)
			{
				enemyCity = new City((i+3).toString());
				enemyCitys.push(enemyCity);
				enemyCity.y  = 500 ;
				enemyCity.x = 50 * (i +1) ;
				trace("x:" +enemyCity.x ,"y"+ enemyCity.y);
				enemyCity.addTo(this);
			}
			
			for ( i = 0 ;i < cityNum ; i ++)
			{
				heroCity = new City((i+3).toString());
				heroCitys.push(heroCity);
				
				heroCity.y  = 50 ;
				heroCity.x = 50 * (i +1) ;
				heroCity.addTo(this);
				trace("x:" +heroCity.x ,"y"+ heroCity.y);
			}
			trace(this.numChildren);
		}
		

	}
}