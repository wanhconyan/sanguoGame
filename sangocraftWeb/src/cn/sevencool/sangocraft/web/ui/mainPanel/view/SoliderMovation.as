package cn.sevencool.sangocraft.web.ui.mainPanel.view
{
	import cn.sevencool.sangocraft.data.symbols.ItemsManager;
	import cn.sevencool.sangocraft.data.symbols.material.MaterialKeys;
	import cn.sevencool.sangocraft.data.symbols.material.MaterialManager;
	import cn.sevencool.sangocraft.data.symbols.material.factory.ImageFactory;
	import cn.sevencool.sangocraft.data.vo.ItemDescription;
	import cn.sevencool.sangocraft.web.manager.UIMananger;
	import cn.sevencool.sangocraft.web.ui.screen.mediator.ScreenMediator;
	import cn.sevencool.sangocraft.web.ui.screen.view.ScreenPanel;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	public class SoliderMovation extends Sprite
	{
		private var _id:int
		
		private var _campID:int;
		
		private var _isDie:Boolean ;
		
		private var _isGeneral:Boolean;
		
		private const SCALE:Number = 2880/232;
		
		private var _icon:Bitmap = null;	
		
		private var _mater:MaterialManager=MaterialManager.getInstance();
		
		private var _isChange:Boolean = false;
		
		private const key:String = MaterialKeys.LOAD_MAP;
		
		private var _translationCamp:int = 0;
		
		private var _leaderID:int = 0;
		
		private var _isViewFocus:Boolean = false;
		
		private var _isBattle:Boolean = false;
		
		private var timer:Timer = new Timer(200);
		
		private var _screenMediator:ScreenMediator = null;
		
		private var _generalName:String = '';
		
		private var screenPanel:ScreenPanel = null;
		
		private var _glintIcon:Bitmap = null;
		
		private var bitmapDic:Dictionary = null;
		
		private var iconUrl:String = '';
		
		private var glintIconUrl:String = '';
		
		private var iconBmp:BitmapData;
		
		private var glintBmp:BitmapData;
		
		public function SoliderMovation()
		{
			super();
			bitmapDic = new Dictionary(); 
			
			screenPanel = UIMananger.getInstance().getUIObj(ScreenPanel) as ScreenPanel;
			addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
			timer.addEventListener(TimerEvent.TIMER,onTimer);
			_icon = new Bitmap();
			_glintIcon = new Bitmap();
			_icon.addEventListener(Event.COMPLETE,onIconComplete);
			_glintIcon.addEventListener(Event.COMPLETE,onGlintComplete);
			this.addChild(_glintIcon);
			this.addChild(_icon);
		}
		
		
		/**
		 * 刷新显示
		 * */
		private function refreshDisplay():void
		{
			var url:String = '';
			switch(campID)
			{
				case 2:
					if(leaderID == 777 || leaderID == 888)
					{
						url = "redFlag";
						this.width = this.height = 18;
						
					}else if(leaderID == 999)
					{
						url = "redBase";
						this.width = this.height = 18;
					}else
					{
						url = "red"
						this.width = this.height = 8;
					}
					break;
				case 1:
					if(leaderID == 777 || leaderID == 888)
					{
						url = "blueFlag";
						this.width = this.height = 18;
						
					}else if(leaderID == 999)
					{
						url = "blueBase";
						this.width = this.height = 18;
					}else
					{
						url = "blue"
						this.width = this.height = 8;
					}
					break;
				default:
					
					throw new Error("阵营错误"+campID);
			}
			
			iconUrl = _mater.getURL(key,url);
			glintIconUrl = _mater.getURL(key,url+"2");
			if(bitmapDic[iconUrl])
			{
				_icon.bitmapData = bitmapDic[iconUrl]
				
			}else
			{
				ImageFactory.getBitmap(iconUrl,_icon);
			}	
			
			if(bitmapDic[glintIconUrl])
			{
				_glintIcon.bitmapData =  bitmapDic[glintIconUrl]
			}else
			{
				ImageFactory.getBitmap(glintIconUrl,_glintIcon);
			}
			
			_icon.visible = true;
			_glintIcon.visible = false;	
		}
		
		/**
		 * 监听鼠标点击
		 * */
		private function onClick(e:MouseEvent):void
		{
			screenMediator.battleRoot.moveViewPort(x*SCALE,y*SCALE);
			
			screenPanel.home.small_map.generalID = id;
		}
		
		private function onMouseOver(e:MouseEvent):void
		{
			
			screenPanel.home.small_map.overShow = true;
			screenPanel.home.small_map.overGeneral = id;
			
		}
		
		private function onMouseOut(e:MouseEvent):void
		{
			screenPanel.home.small_map.overShow = false;
			
		}
		
		private function onTimer(e:TimerEvent):void
		{
			if(timer.currentCount%2 == 1)
			{
				setShow(false);
				
			}else
			{
				setShow(true);
			}
		}
		
		/**
		 * @param $show (true 浅蓝可见, false 深蓝可见) 
		 * */
		private function setShow($show:Boolean):void
		{
			if(_icon&&_glintIcon)
			{
				_icon.visible = $show;
				_glintIcon.visible = !$show;
			}
		}
		
		/**
		 * 是否是武将
		 * */
		public function get isGeneral():Boolean
		{
			return _isGeneral;
		}
		
		/**
		 * @private
		 */
		public function set isGeneral(value:Boolean):void
		{
			_isGeneral = value;
		}
		
		/**
		 * 死亡
		 * */
		public function get isDie():Boolean
		{
			return _isDie;
		}
		
		/**
		 * @private
		 */
		public function set isDie(value:Boolean):void
		{
			_isDie = value;
			if(isDie)
			{
				dispose();
			}else
			{
				_icon.visible =  true ;
			}
		}
		
		/**
		 * 阵营id 
		 * */
		public function get campID():int
		{
			return _campID;
		}
		
		/**
		 * @private
		 */
		
		private var oldCamp:int = -1;
		public function set campID(value:int):void
		{
			_campID = value;
			
			//			if(oldCamp!=campID)
			//			{
			//				oldCamp = campID;
			refreshDisplay();
			//			}
		}
		
		/**
		 * 编队类型
		 * */
		public function get id():int
		{
			return _id;
		}
		
		/**
		 * @private
		 */
		public function set id(value:int):void
		{
			_id = value;
		}
		
		
		private function dispose():void
		{
			_icon.visible = _glintIcon.visible = false ;
			if(this.parent)
			{
				this.parent.removeChild(this);
			}
		}
		
		public function get leaderID():int
		{
			return _leaderID;
		}
		
		private var oldLeader:int = -1;
		public function set leaderID(value:int):void
		{
			_leaderID = value;
			
			if(leaderID != 777&& leaderID !=888 && leaderID != 999 )
			{
				isGeneral = true;
			}else
			{
				isGeneral = false;
			}
			
			if(oldLeader != leaderID)
			{
				refreshDisplay();
				oldLeader =  leaderID;
			}
			
			var items:ItemDescription = ItemsManager.getInstance().ItemInfo[leaderID];
			if(items)
			{
				generalName = items.szName;
				
				if(generalName == '城门')
				{
					this.visible = false;
				}
			}
		}
		
		
		private function onIconComplete(e:Event):void
		{
			if(!bitmapDic[iconUrl])
			{
				iconBmp = _icon.bitmapData.clone();
				bitmapDic[iconUrl] = iconBmp ;
			}
			
		}
		
		private function onGlintComplete(e:Event):void
		{
			if(!bitmapDic[glintIconUrl])
			{
				glintBmp = _glintIcon.bitmapData.clone();
				bitmapDic[glintIconUrl] = glintBmp;
			}
			
		}
		
		public function get isBattle():Boolean
		{
			return _isBattle;
		}
		
		public function set isBattle(value:Boolean):void
		{
			_isBattle = value;
			if(isBattle)
			{
				timer.start();
				
			}else
			{
				timer.stop();
				setShow(true);
			}
		}
		
		public function disposeChild():void
		{
			
			
		}
		
		public function get isViewFocus():Boolean
		{
			return _isViewFocus;
		}
		
		public function set isViewFocus(value:Boolean):void
		{
			_isViewFocus = value;
		}
		
		public function get generalName():String
		{
			return _generalName;
		}
		
		public function set generalName(value:String):void
		{
			_generalName = value;
		}
		
		public function get screenMediator():ScreenMediator
		{
			return _screenMediator;
		}
		
		public function set screenMediator(value:ScreenMediator):void
		{
			_screenMediator = value;
		}
	}
}