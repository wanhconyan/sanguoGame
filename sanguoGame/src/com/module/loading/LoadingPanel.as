package com.module.loading
{
	import com.core.view.BaseFrame;
	import com.sanguo.manager.App;
	
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	
	public class LoadingPanel extends BaseFrame
	{
		private static var _instance:LoadingPanel ;
		
		private var _process:TextField ;
		
		private var _loadMC:loadMC ;
		public function LoadingPanel()
		{
			super();
			_process = new TextField();
			var textFormat:TextFormat = _process.defaultTextFormat ;
			if(!textFormat)
			{
				textFormat = new TextFormat();
				
			}
			textFormat.align = TextFormatAlign.CENTER ; 
			textFormat.size = 18; 
			textFormat.color = "0xffffff";
			_process.width  = 400 ;
			_process.defaultTextFormat = textFormat ;
			_process.text = "游戏加载中..."
			this.addChild(_process);
			_loadMC = new loadMC();
			this.addChild(_loadMC);
			onResize();
			App.ins.stage.addEventListener(Event.RESIZE,onResize);
		}
		
		
		public static function get instance():LoadingPanel
		{
			if(!_instance)
			{
				_instance = new LoadingPanel();
			}
			return _instance;
		}
		
		
		/**
		 * 打开面板
		 * 
		 */	
		public override function show():void
		{
			App.ins.layer.mainLayer.addChild(this);
			
		}
		
		/**
		 * 关闭面板
		 * 
		 */		 
		public override function hide():void
		{
			if(this && this.parent)
			{
				this.parent.removeChild(this);
			}
		
		}
		
		protected function onResize(event:Event = null):void
		{
			this.graphics.clear();
			this.graphics.beginFill(0);
			this.graphics.drawRect(0,0,App.ins.stage.stageWidth,App.ins.stage.stageHeight);
			this.graphics.endFill() ;
			_process.x = App.ins.stage.stageWidth - _process.width >> 1 ;
			_loadMC.x = App.ins.stage.stageWidth - _loadMC.width >> 1 ;
			_loadMC.y = App.ins.stage.stageHeight - _loadMC.height >> 1 ;
			_process.y = _loadMC.y  + _loadMC.height + 20 ;
		}		
		
		
		
		/**
		 * 加载进度 
		 * @param $percent
		 */		
		public function onProcess($percent:Number):void
		{
			_process.text = "加载进度为"+$percent.toFixed(2)+"%"
		}
	}
}