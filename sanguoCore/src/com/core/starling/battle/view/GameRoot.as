package  com.core.starling.battle.view
{
	import com.core.loader.LoadInfo;
	import com.core.loader.LoaderManager;
	import com.core.loader.UnitLoader;
	import com.core.starling.battle.ai.BattleField;
	import com.core.starling.battle.ai.UnitCreator;
	import com.core.starling.battle.view.unit.view.UnitView;
	import com.core.vo.fraction.FractionVO;
	import com.core.xmlHelper.XmlCreateManager;
	
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
			
			LoaderManager.instance.load("map/1002.jpg",onMapLoadComplete);
			
		}
		
		private function onLoadFormationComplete($data:Object):void
		{
			var xml:XML = XML(($data as LoadInfo).data);
			var formation:FractionVO = XmlCreateManager.getInstance().getFormationByID(0,xml);
		}		
		
		private var mapDic:Dictionary = new Dictionary();
		
		
		private function onMapLoadComplete(data:LoadInfo):void
		{
			mapDic[data.url] = data.data ;
			var texture:Texture = Texture.fromBitmapData(data.data);
			var image:Image = new Image(texture);
			barLayer.addChild(image);
			bgLayer.flatten();
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