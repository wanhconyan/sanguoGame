package cn.sevencool.sangocraft.web.symbols
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.text.TextField;
	
	import mx.events.FlexEvent;
	import mx.preloaders.IPreloaderDisplay;
	
	public class PurePreloader extends Sprite implements IPreloaderDisplay
	{
		private var msg:TextField = null;
		public function PurePreloader()
		{
			msg = new TextField();
			msg.x=200;  
			msg.y=200;  
			addChild(msg);
		}
		
		public function get backgroundAlpha():Number
		{
			return 0;
		}
		
		public function set backgroundAlpha(value:Number):void
		{
		}
		
		public function get backgroundColor():uint
		{
			return 0;
		}
		
		public function set backgroundColor(value:uint):void
		{
		}
		
		public function get backgroundImage():Object
		{
			return null;
		}
		
		public function set backgroundImage(value:Object):void
		{
		}
		
		public function get backgroundSize():String
		{
			return null;
		}
		
		public function set backgroundSize(value:String):void
		{
		}
		
		public function set preloader(obj:Sprite):void
		{
			obj.addEventListener(ProgressEvent.PROGRESS,inProgress);  
			obj.addEventListener(Event.COMPLETE,complete);  
			obj.addEventListener(FlexEvent.INIT_COMPLETE,initComplete);  
			obj.addEventListener(FlexEvent.INIT_PROGRESS,initProgress);  
		}
		
		protected function initProgress(event:Event):void
		{
			// TODO Auto-generated method stub
			msg.text="初始化...";

		}
		
		protected function complete(event:Event):void
		{
			msg.text="下载完毕";  
		}
		
		protected function initComplete(event:Event):void
		{
			msg.text="初始化完毕" 
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		protected function inProgress(event:ProgressEvent):void
		{
			var percent:int  = event.bytesLoaded/event.bytesTotal*100;  
			msg.text=percent.toString()+ " %";  
		}
		
		private var _stageHeight:Number;
		public function get stageHeight():Number
		{
			return _stageHeight;
		}
		
		public function set stageHeight(value:Number):void
		{
			_stageHeight = value;
		}
		
		private var _stageWidth:Number ; 
		public function get stageWidth():Number
		{
			return _stageWidth;
		}
		
		public function set stageWidth(value:Number):void
		{
			_stageWidth = value;
		}
		
		public function initialize():void
		{
		}
	}
}