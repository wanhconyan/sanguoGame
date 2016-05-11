package com.sanguo.manager
{
	import flash.display.Sprite;
	import flash.display.Stage;

	public class App
	{
		public var layer:LayerManager ;
		
		public var sound:SoundManager;
		
		public var loop:LoopManager ;
		
		public var stage:Stage ;
		
		private var container:Sprite ;
		
		private static var _app:App ;
		
		/**
		 * 获取对象单利 
		 * @return 
		 * 
		 */		
		public static function get ins():App
		{
			if(!_app)
			{
				_app = new App();
			}
			return _app ;
		}
		
		
		
		
		public function App()
		{
		}
		
		
		public function init($stage:Stage):void
		{
			stage = $stage ;
			start();
		}
		
		
		private function start():void
		{
			layer = new LayerManager();
			container = new Sprite();
			stage.addChild(container);
			layer.init(container);
		}
	}
}