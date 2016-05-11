package  com.view.unitControl.battle
{ 
	import com.core.starling.battle.ai.BattleField;
	import com.core.view.BaseMediator;
	import com.view.unitControl.App;
	import com.view.unitControl.battle.Battle;
	
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import starling.core.Starling;

	public class BattleMediator extends BaseMediator
	{
		
		private var _starling:Starling ;
		
		private var _viewPortRect:Rectangle ;
		
		private var battleRoot:Battle;
		public function BattleMediator()
		{
			
		}
		
		public function startUp():void
		{
			
		}
		
		protected function addLinstener():void
		{
			App.ins.stage.addEventListener(Event.RESIZE,onResize);
		}
		
		protected function onResize(event:Event):void
		{
			if(!_starling.isStarted)
			{
				_starling.viewPort.width = App.ins.stage.stageWidth ;
				_starling.viewPort.height = App.ins.stage.stageHeight ;
			}
			
		}		
		
		protected function removeLinstener():void
		{
		
		
		}
		
		
		public function start():void
		{
			if(!_starling)
			{
		
			_viewPortRect = new Rectangle(0, 0, App.ins.stage.stageWidth, App.ins.stage.stageHeight);
			Starling.handleLostContext = true; 
			_starling = new Starling(Battle,App.ins.stage,_viewPortRect);
			_starling.addEventListener("rootCreated",onRootCreate);
			_starling.antiAliasing =1;
			_starling.showStats=true;
			_starling.simulateMultitouch = true;
			_starling.enableErrorChecking = false; //将错误检测关闭
			
			}
			_starling.start();
			BattleField.instance.start();
		}
		
		private function onRootCreate():void
		{
			battleRoot = _starling.root as Battle ;
		}		
		
		public function end():void
		{
			_starling.stop();
			BattleField.instance.dispose();
//			_starling.dispose();
		}
	}
}