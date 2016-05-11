package  com.view.unitControl.battle
{
	import com.core.event.BattleEvent;
	import com.core.util.Dispatcher;
	import com.core.view.BaseModule;
	

	public class BattleModule extends BaseModule
	{
		private var _baseMediator:BattleMediator ;
		public function BattleModule()
		{
			_baseMediator = new BattleMediator();
		}
		
		override public function start():void
		{
			addModuleEvent();
		}
		
		override protected function addModuleEvent():void
		{
			Dispatcher.register(BattleEvent.BATTLE_START,onBattleStart);
			Dispatcher.register(BattleEvent.BATTLE_END,onBattleEnd);
		
		}
		
		private function onBattleEnd($obj:Object):void
		{
			_baseMediator.end();
			
		}
		
		private function onBattleStart($obj:Object):void
		{
			
			_baseMediator.start();
		}		
		
		
		override protected function removeModuleEvent():void
		{
		
		
		
		}
		
		public function play():void
		{
			_baseMediator.startUp() ;
		}
	}
}