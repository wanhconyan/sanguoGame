package com.sanguo.manager
{
	import flash.display.Sprite;
	
	public class LayerManager extends Sprite
	{
		/**
		 *Message Layer 
		 */		
		public var msgLayer:Sprite ;
		
		/**
		 *主界面 
		 */		
		public var mainLayer:Sprite ;
		
		/**
		 *模块界面 
		 */		
		public var moduleLayer:Sprite ;
		
		/**
		 *战斗层 
		 */		
		public var battleLayer:Sprite ;
		
		/**
		 *场景层 
		 */		
		public var sceneLayer:Sprite ;
		
		
		/**
		 *新手引导层 
		 */		
		public var newGuildLayer:Sprite ;
	
		
		/**
		 *对话层 
		 */		
		public var dialogLayer:Sprite ;
		
		
		private static var initCount:int = 0 ;
		
		private var _content:Sprite ;
		public function LayerManager()
		{
			super();
			initCount ++ ;
			if(initCount >= 2)
			{
				throw new Error("can't initlize class twice!");
			}
			start();
		}
		
		
		
		/**
		 *初始化层级 
		 */		
		private function start():void
		{
			sceneLayer = new Sprite();
			sceneLayer.tabChildren = false;
			sceneLayer.tabEnabled = false;
			sceneLayer.mouseEnabled = false;
			sceneLayer.mouseChildren = true ;
			
			battleLayer = new Sprite();
			battleLayer.tabChildren = false;
			battleLayer.tabEnabled = false;
			battleLayer.mouseEnabled = false;
			battleLayer.mouseChildren = true ;
			
			mainLayer = new Sprite();
			mainLayer.tabChildren = false;
			mainLayer.tabEnabled = false;
			mainLayer.mouseEnabled = false;
			mainLayer.mouseChildren = true ;
			
			moduleLayer = new Sprite();
			moduleLayer.tabChildren = false;
			moduleLayer.tabEnabled = false;
			moduleLayer.mouseEnabled = false;
			moduleLayer.mouseChildren = true ;
			
			dialogLayer = new Sprite();
			dialogLayer.tabChildren = false;
			dialogLayer.tabEnabled = false;
			dialogLayer.mouseEnabled = false;
			dialogLayer.mouseChildren = true ;
			
			
			newGuildLayer = new Sprite();
			newGuildLayer.tabChildren = false;
			newGuildLayer.tabEnabled = false;
			newGuildLayer.mouseEnabled = false;
			newGuildLayer.mouseChildren = true ;
			
		}
		
		/**
		 * 初始化显示层 
		 * @param $container
		 * 
		 */		
		public function init($container:Sprite):void
		{
			_content = $container ;
			_content.addChild(battleLayer);
			_content.addChild(sceneLayer);
			_content.addChild(mainLayer);
			_content.addChild(moduleLayer);
			_content.addChild(dialogLayer);
			_content.addChild(newGuildLayer);
			
		
		}
		
	}
}