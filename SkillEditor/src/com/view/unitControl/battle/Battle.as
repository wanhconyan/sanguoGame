package  com.view.unitControl.battle
{
	import com.core.starling.battle.ai.BattleField;
	import com.core.starling.battle.view.GameRoot;
	
	import starling.display.Sprite;
	
	
	public class Battle extends Sprite
	{
		private var gameRoot:GameRoot = null;
		
		public function Battle()
		{
			super();
			init();
		}
		
		
		public function init():void
		{
			gameRoot = new GameRoot();
			BattleField.instance.battleContainer = gameRoot ;
			this.addChild(gameRoot);
		}
	
		
		public function end():void
		{
		
		}
	}
}