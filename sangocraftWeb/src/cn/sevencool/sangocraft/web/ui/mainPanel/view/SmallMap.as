package cn.sevencool.sangocraft.web.ui.mainPanel.view
{
	import cn.sevencool.sangocraft.data.symbols.SystemModelLocator;
	import cn.sevencool.sangocraft.data.symbols.material.MaterialKeys;
	import cn.sevencool.sangocraft.data.symbols.material.MaterialManager;
	import cn.sevencool.sangocraft.data.symbols.material.factory.ImageFactory;
	import cn.sevencool.sangocraft.web.manager.UIMananger;
	import cn.sevencool.sangocraft.web.symbols.SolderType;
	import cn.sevencool.sangocraft.web.ui.screen.mediator.ScreenMediator;
	
	import com.sevencool.rtslogic.Battlefield;
	import com.sevencool.rtslogic.team.Team;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import flashx.textLayout.formats.TextAlign;
	
	import mx.controls.ToolTip;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	public class SmallMap extends UIComponent
	{
		private const key:String = MaterialKeys.LOAD_MAP;
		private static const SCALE:Number = 2880/232;
		public var imgDic:Dictionary = null;
		private var _bit:Bitmap ;
		private var _smallMapSp:Sprite;
		
		private var _url:String = '';
		
		private var _moveStage:Sprite = new Sprite();
		
		private var _mater:MaterialManager=MaterialManager.getInstance();
		
		private var _battle:Battlefield = null;
		
		
		private var isGeneral:Boolean = false;
		
		/**
		 * 点击的是否是武将
		 * */
		private var _isGeneral:Boolean = false ;
		
		private var _isStart:Boolean = false;
		
		private var _isLockView:Boolean = false;
		
		private var _isSelect:int = -1;
		
		private var _sprite:Sprite = null;
		
		private var _screenMediator:ScreenMediator = null;
		
		private var _text:TextField =null;
		
		private var _generalID:int = -1;
		
		
		private var _overGeneral:int = -1;
		
		private var _overShow:Boolean  = false;
		
		private var _nowPos:Point = new Point(0,0);
		
		private var _screenX:Number = -1;
		private var _screenY:Number = -1;
		
		private var _rect:Point = null;
		
		private var _timer:Timer = null;
		
		private var _tool:ToolTip = null ;
		
		private var _redBack:Bitmap = null;
		
		private var _blueBack:Bitmap = null;
		
		private var _soliderPool:SoliderPool = null;
		
		private var _blackMap:Bitmap = null;
		
		private var _bitmapData:BitmapData = null;
		
		private var _backBmp:Bitmap = null;
		
		public function SmallMap()
		{
			super();
			
			_screenX = UIMananger.getInstance().container.width;
			_screenY = UIMananger.getInstance().container.height;
			addSprite();
			_smallMapSp = new Sprite();
			_timer = new Timer(500)
			_blackMap = new Bitmap();
			_backBmp = new Bitmap();
			_soliderPool = SoliderPool.getPool();
			_smallMapSp.addEventListener(MouseEvent.CLICK,mouseClick);
			addEventListener(FlexEvent.CREATION_COMPLETE,onCreateComplete);
			//addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			SystemModelLocator.getInstance().addEventListener(Event.RESIZE,onReize);
			_backBmp.addEventListener(Event.COMPLETE,onBackComplete);
			this.addChildAt(_smallMapSp,0);
//			_smallMapSp.addChild(_blackMap);
		}
		
		
		private function addSprite():void
		{
			
			if(_sprite)
			{
				_sprite.graphics.clear();
				if(this.contains(_sprite))
				{
					this.removeChild(_sprite);
				}
				_sprite = null;
				
			}
			_sprite = new Sprite(); 
			_sprite.graphics.lineStyle(2,0xb2f267);
			_sprite.graphics.drawRect(0,0,_screenX/SCALE,_screenY/SCALE);
			_sprite.graphics.endFill();
			this.addChild(_sprite);
			_sprite.x = _nowPos.x;
			_sprite.y = _nowPos.y;
			
		}
		
		private function onCreateComplete(e:FlexEvent):void
		{
			_battle = Battlefield.getActivityBattlefield();
			_text = new TextField();
			_text.width = 39 ;
			_text.height = 16;
			
			var textFormat:TextFormat = new TextFormat();
			textFormat.color = 0xffffff;
			textFormat.align = TextAlign.CENTER;
			textFormat.size = 12 ;
			_text.defaultTextFormat = textFormat;
			this.addChildAt(_text,1);
			
			_redBack = MaterialManager.getInstance().getIcon(MaterialKeys.OTHER,"redBack",new Bitmap());
			_blueBack = MaterialManager.getInstance().getIcon(MaterialKeys.OTHER,"blueBack",new Bitmap());
			
			this.addChildAt(_redBack,1);
			
			this.addChildAt(_blueBack,1);
			
			_redBack.visible = _blueBack.visible = false;
		}
		
		
		/**
		 * 监听舞台大小变更
		 * */
		private function onReize(e:Event):void
		{
			
			_screenX =  UIMananger.getInstance().container.width ;
			_screenY =  UIMananger.getInstance().container.height ;
			addSprite();
			
		}
		
		
		private function onBackComplete(e:Event):void
		{
			var bitmapData:BitmapData = null;
			_bitmapData = _backBmp.bitmapData.clone() ;
			while(_smallMapSp.numChildren)
			{
				_smallMapSp.removeChildAt(0);
			}
			_smallMapSp.addChild(_backBmp);
			_backBmp.bitmapData = _bitmapData;
			bitmapData = new BitmapData(_bitmapData.width,_bitmapData.height,false,0xff0000);
			
			var seed:Number = Math.floor(Math.random() * 100);
			var channels:uint = BitmapDataChannel.GREEN | BitmapDataChannel.BLUE;
			bitmapData.perlinNoise(100,100,16,seed,false,true,channels,false,null)
			_blackMap.bitmapData = bitmapData; 
//			_smallMapSp.addChild(_blackMap);
		
		}
		
		//鼠标点击
		private function mouseClick(e:MouseEvent):void
		{
			
			if(isLockView)
			{
				return ;
			}
			e.stopPropagation();
			var point:Point =_smallMapSp.globalToLocal(new Point(e.stageX,e.stageY));
			
			var posPoint:Point = new Point(point.x,point.y);
			
			isGeneral = false;
			
			screenMediator.battleRoot.moveViewPort(posPoint.x*SCALE,posPoint.y*SCALE);
			
			
			_sprite.x = posPoint.x -_sprite.width/2;
			_sprite.y = posPoint.y - _sprite.height/2;
			
			if(_sprite.x<0)
			{
				_sprite.x = 0;
			}
			if(_sprite.y < 0)
			{
				_sprite.y  = 0;
			}
			if(_sprite.x> 232 - _sprite.width)
			{
				_sprite.x =  232 - _sprite.width
			}			
			if(_sprite.y > 145 - _sprite.height)
			{
				_sprite.y = 145 - _sprite.height;
			}
			
		}
		
		private function onMouseOver(e:MouseEvent):void
		{
		
//			screenMediator.battleRoot.onDrag = false;
		}
		
		
		private function onMouseOut(e:MouseEvent):void
		{
//			screenMediator.battleRoot.onDrag = true;
		}
		
		private function onMouseMove(e:MouseEvent):void
		{
			e.stopPropagation()
				
		}
		
		/**
		 * 每帧更新视角
		 * 777 据点怪物
		 * 888 城门
		 * 999 本营
		 * */
		private function onTimer(e:TimerEvent):void
		{
			var solider:SoliderMovation = null;
			if(_battle&&_battle.teams)
			{
				if(screenMediator.battleRoot)
				{
					_nowPos = new Point((screenMediator.battleRoot.viewPortX - _screenX/2)/SCALE,(screenMediator.battleRoot.viewPortY - _screenY/2)/SCALE)
					_sprite.x = _nowPos.x;
					_sprite.y = _nowPos.y;
				}
				for each(var team:Team in _battle.teams)
				{
					if(!imgDic[team.id])
					{
						solider = _soliderPool.getSolider()
						solider.id = team.id;
						solider.campID  = team.campID;
						solider.leaderID = team.leaderID;
						solider.isDie = !team.currentUnit;
						solider.screenMediator = screenMediator;
						if(solider.isGeneral)
						{
							solider.x = team.x/SCALE;
							solider.y = team.y/SCALE;
							this.addChildAt(solider,2);
						}else
						{
							solider.x = team.x/SCALE - solider.width/2;
							solider.y = team.y/SCALE - solider.height/2;
							if(solider.leaderID !=888)
							{
								this.addChildAt(solider,1);
							}
						}
						solider.x = team.x/SCALE;
						solider.y = team.y/SCALE;
						solider.isBattle = Boolean(team.target);
						imgDic[team.id] = solider;
						
					}else
					{
						solider = imgDic[team.id] ;
						solider.campID  = team.campID;
						solider.isDie = !team.currentUnit;
						solider.leaderID = team.leaderID;
						solider.isBattle = Boolean(team.target);
						if(solider.isGeneral)
						{
							solider.x = team.x/SCALE;
							solider.y = team.y/SCALE;
						}else
						{
							solider.x = team.x/SCALE - solider.width/2;
							solider.y = team.y/SCALE - solider.height/2;
						}
						if(solider.isDie)
						{
							if(this.contains(solider))
							{
								this.removeChild(solider);
								solider = null;
							}
						}
					}
				}
				
				if(isLockView)
				{
					solider = imgDic[generalID] 
					if(solider)
					{
						screenMediator.battleRoot.moveViewPort(solider.x*SCALE,solider.y*SCALE);
						_sprite.x = _nowPos.x;
						_sprite.y = _nowPos.y;
					}	
				}
				if(screenMediator)
				{
					if(overShow && imgDic)
					{
						solider = imgDic[overGeneral] 
						if(!solider)
						{
							return ;
						}
						_text.text = solider.generalName;
						trace(_text.width)
						if(solider.campID == 1)
						{
							_blueBack.visible = true;
							
							_blueBack.x = solider.x  ;
							_blueBack.y = solider.y - 25	;
						}else
						{
							_redBack.visible = true;
							_redBack.x = solider.x  ;
							_redBack.y = solider.y - 25	;
						}
						
						_text.x = solider.x;
						_text.y = solider.y -25 ;
						
						_text.visible = true;
					}else
					{
						_text.visible = false;
						_redBack.visible = _blueBack.visible = false;
					}
				}
			}
			
		}
		
		/**
		 * @param $pos:移动点坐标
		 * */
		private function refreshViewPort($pos:Point):void
		{
			screenMediator.battleRoot.moveViewPort($pos.x*SCALE,$pos.y*SCALE);
		}
		
		
		public function get isStart():Boolean
		{
			return _isStart;
		}
		
		public function set isStart(value:Boolean):void
		{
			_isStart = value;
			if(isStart)
			{
				_timer.addEventListener(TimerEvent.TIMER,onTimer);		
				_timer.reset();
				_timer.start();
			}else
			{
				_timer.stop();
				
				for each(var solider:SoliderMovation in imgDic)
				{
					if(this.contains(solider))
					{
						this.removeChild(solider);
					}
				}
								
				imgDic = null;
				if(this.hasEventListener(TimerEvent.TIMER))
				{
					this.removeEventListener(TimerEvent.TIMER,onTimer);
				}
			}
		}
		
		/**
		 * 当前选中战斗id
		 * */
		public function get isSelect():int
		{
			return _isSelect;
		}
		
		/**
		 * @private
		 */
		public function set isSelect(value:int):void
		{
			_isSelect = value;
		}
		
		/**
		 * 是否锁定视角
		 * */
		public function get isLockView():Boolean
		{
			return _isLockView;
		}
		
		/**
		 * @private
		 */
		public function set isLockView(value:Boolean):void
		{
			_isLockView = value;
		}
		
		public function get screenMediator():ScreenMediator
		{
			return _screenMediator;
		}
		
		public function set screenMediator(value:ScreenMediator):void
		{
			_screenMediator = value;
		}
		
		/**
		 * 选中跟随武将id
		 * */
		public function get generalID():int
		{
			return _generalID;
		}
		
		/**
		 * @private
		 */
		public function set generalID(value:int):void
		{
			_generalID = value;
		}
		
		/**
		 * 悬浮显示武将
		 * */
		public function get overGeneral():int
		{
			return _overGeneral;
		}
		
		/**
		 * @private
		 */
		public function set overGeneral(value:int):void
		{
			_overGeneral = value;
		}
		
		/**
		 * 悬浮显示
		 * */
		public function get overShow():Boolean
		{
			return _overShow;
		}
		
		/**
		 * @private
		 */
		public function set overShow(value:Boolean):void
		{
			_overShow = value;
		}

		public function get rect():Point
		{
			return _rect;
		}

		public function set rect(value:Point):void
		{
			_rect = value;
		}
		
		public function get url():String
		{
			return _url;
		}
		
		public function set url(value:String):void
		{
			var backUrl:String= ''
			_soliderPool.recycleSolider();
			imgDic = new Dictionary();
			
			_url = value.substr(0,3)
			//			_backBmp = MaterialManager.getInstance().getIcon(MaterialKeys.LOAD_MAP,url);
			backUrl = MaterialManager.getInstance().getURL(MaterialKeys.LOAD_MAP,url);
			trace(backUrl)
			ImageFactory.getBitmap(backUrl,_backBmp);
			this.isStart = true;
		}
		
	}
}