package com.starling.battle.view
{
	import com.core.loader.LoadInfo;
	import com.core.loader.LoaderManager;
	import com.core.loader.UnitLoader;
	import com.core.vo.fraction.FractionVO;
	import com.core.xmlHelper.XmlCreateManager;
	import com.module.loading.LoadingPanel;
	import com.module.map.BattleScene;
	import com.sanguo.manager.BattleManager;
	import com.starling.battle.ai.BattleField;
	import com.starling.battle.ai.UnitCreator;
	import com.starling.battle.view.unit.view.UnitView;
	
	import flash.events.ProgressEvent;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class GameRoot extends Sprite
	{
		/**
		 *背景层 
		 */		
		public static const BG_INDEX:int = 0 ;
		
		/**
		 *建筑层 
		 */		
		public static const BUILDING_INDEX:int = 1 ;
		
		/**
		 *界面层 
		 */		
		public static const VIEW_BACK_INDEX:int = 2 ;
		
		/**
		 *移动特效层 
		 */		
		public static const MOVINGEFFECT_INDEX:int = 3 ;
		
		/**
		 *头像层 
		 */		
		public static const BAR_INDEX:int = 4 ;
		
		/**
		 *基本特效层 
		 */		
		public static const BASEEFFECT_INDEX:int = 5;
		
		/**
		 *子弹层 
		 */		
		public static const AMMO_INDEX:int = 6 ;
		
		
		/**
		 *特效层 
		 */		
		public static const EFFECT_INDEX:int = 7 ;
		
		
		public static const VIEW_INDEX:int = 8 ;
		
		
		private var moveEffectBackLayer:Sprite = new Sprite();
		
		private var viewLayer_back:Sprite = new Sprite();
		
		private var buildingBackLayer:Sprite = new Sprite();
		
		private var viewLayer:Sprite  = new Sprite();
		
		private var buildLayer:Sprite = new Sprite();
		
		private var baseEffectLayer:Sprite = new Sprite();
		
		private var ammoLayer:Sprite = new Sprite();
		
		private var effectLayer:Sprite = new Sprite();
		
		private var bgLayer:Sprite = new Sprite();
		
		private var barLayer:Sprite = new Sprite();
		
		/**
		 *地图 
		 */		
		private var bgImg:Image ;
		
		
		private var mask:Image = new Image(Texture.fromColor(128,128));
		
		
		
		
		
		private var unit:UnitView;
		
		private var textures:TextureAtlas ;
		
		private var _battleScene:BattleScene ;
		public function GameRoot()
		{
			super();
			this.addChild(bgLayer);
			
			this.addChild(buildingBackLayer);
			
			this.addChild(viewLayer_back);
			
			this.addChild(moveEffectBackLayer);
			
			this.addChild(buildLayer);
			buildLayer.touchable  = false;
			
			this.addChild(viewLayer);
			viewLayer.touchable = false;
			
			this.addChild(barLayer);
			barLayer.touchable = false;
			
			this.addChild(baseEffectLayer);
			baseEffectLayer.touchable = false;
			
			this.addChild(ammoLayer);
			ammoLayer.touchable = false;
			
			this.addChild(effectLayer);
			effectLayer.touchable = false;
			
			LoadingPanel.instance.show();
			_battleScene = new BattleScene();
			bgLayer.addChild(_battleScene);
//			LoaderManager.instance.LoadUnit("b1",onComplete1,process);
//			LoaderManager.instance.LoadUnit("b2",onComplete1,process);
			LoaderManager.instance.load("fractionConfig/baseFraction.xml",onLoadFormationComplete);
			LoaderManager.instance.LoadUnit("13",onComplete1,process);
			LoaderManager.instance.load("map/1002.jpg",onMapLoadComplete,process);
			
		}
		
		private function onLoadFormationComplete($data:Object):void
		{
			var xml:XML = XML(($data as LoadInfo).data);
			var formation:FractionVO = XmlCreateManager.getInstance().getFormationByID(0,xml);
			BattleManager.instance.setFormation(formation.fractionID,formation);
		}		
		
		private var mapDic:Dictionary = new Dictionary();
		
		
		private function onMapLoadComplete(data:LoadInfo):void
		{
			mapDic[data.url] = data.data ;
			var texture:Texture = Texture.fromBitmapData(data.data);
			_battleScene.setBmp(texture);
			bgLayer.flatten();
		}
		
		private function process(e:ProgressEvent):void
		{
			LoadingPanel.instance.onProcess(e.bytesLoaded/e.bytesTotal* 100);
			
		}		
		
		protected function onComplete1(event:Object):void
		{
			LoadingPanel.instance.hide();
//			var bitmapData:BitmapData = (event as UnitLoader).bitmapData;
			var byteArray:ByteArray = (event as UnitLoader).utfByteArray;
			var texture:Texture = Texture.fromAtfData(byteArray);
			var config:XML = (event as UnitLoader).config;
			textures = new TextureAtlas(texture,config);
			UnitCreator.instance.addAtlasByKey((event as UnitLoader).loadInfo.url,textures);
			unit = new UnitView("13");
			unit.textureAtlas = textures;
			
//			addChild(unit);
			
			setInterval(changeMovie,2000);
			setTimeout(function ():void
			{
				BattleField.instance.createDefaultTeam();
			},3000);
		}
		
		
		protected function onComplete(event:Object):void
		{
//			LoadingPanel.instance.hide();
		}
		
		
		private var i:int = 1 ;
		private function changeMovie():void
		{
			if(i > 8)
			{
				i = 1 ;
			}
			unit.direction = i ;
			unit.action = 2 ;
			i ++ ;
		
		}
		
		
		/**
		 * 添加 
		 * @param view
		 * @param index
		 * 
		 */		
		public function addViewAt(view:DisplayObject,index:int):void
		{
			if(index == VIEW_BACK_INDEX)
			{
				viewLayer_back.addChild(view);
			}
			if(index == VIEW_INDEX)
			{
				viewLayer.addChild(view);
			}
		
		
		}
		
		
	}
}