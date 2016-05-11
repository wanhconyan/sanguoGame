package  com.core.starling.battle.ai
{
	import com.core.starling.battle.view.GameRoot;
	import com.core.starling.battle.view.unit.view.Team;
	

	public class BattleField
	{
		
		private static var _instane:BattleField ;
		
		public var battleContainer:GameRoot ;
		
		private var unitCreator:UnitCreator ;
		public function BattleField()
		{
			unitCreator = new UnitCreator();
		}
		
		/**
		 * 获取战斗单利 
		 * @return 
		 */		
		public static function get instance():BattleField
		{
			if(!_instane)
			{
				_instane = new BattleField();
			}
			return _instane ;
		}
		
		
		public function createDefaultTeam():void
		{
			var team:Team = new Team();
			team.formationID = 0 ;
			team.type = "13";
			team.formationIndex = 18;
			team.course = 0 ;
			
			var enemy:Team = new Team();
			enemy.formationID = 0 ;
			enemy.type ="13";
			team.course = 1 ;
			enemy.formationIndex = 21 ;
			
			team.units = unitCreator.createUnitByTeam(team);
			enemy.units = unitCreator.createUnitByTeam(enemy);
		}
		
		
		
		/**
		 *战斗先是对象销毁 
		 */		
		public function dispose():void
		{
			battleContainer.visible = false;
			
		}
		
		
		public function start():void
		{
			if(battleContainer)
			{
				battleContainer.visible = true;
			}
		}
	}
}