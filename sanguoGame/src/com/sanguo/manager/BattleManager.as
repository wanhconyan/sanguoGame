package com.sanguo.manager
{
	import com.core.vo.fraction.FractionVO;
	import com.starling.battle.view.unit.view.Team;
	
	import flash.utils.Dictionary;

	public class BattleManager
	{
		private static var _instance:BattleManager ;
		
		
		public var formationDic:Dictionary = null;
		
		
		public function BattleManager()
		{
			init();
		}
		
		
		

		public function init():void
		{
			formationDic = new Dictionary();
		}
		
		
		public function getFraction($id:int):FractionVO
		{
			var fractionVO:FractionVO = formationDic[$id];
			return fractionVO ;
		}
		
		
		public function setFormation($id:int,$formation:FractionVO):void
		{
			formationDic[$id] = $formation;
		}
		
		public static function get instance():BattleManager
		{
			if(!_instance)
			{
				_instance = new BattleManager();
			}
			return _instance;
		}
	}
}