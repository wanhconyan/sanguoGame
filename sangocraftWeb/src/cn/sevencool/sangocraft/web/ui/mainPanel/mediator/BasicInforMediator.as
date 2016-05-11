package cn.sevencool.sangocraft.web.ui.mainPanel.mediator
{
	import cn.sevencool.sangocraft.data.manager.screen.mediator.BaseBasicInforMediator;
	import cn.sevencool.sangocraft.data.manager.screen.mediator.IUIOperateBaseInfoMadiator;
	import cn.sevencool.sangocraft.data.manager.utils.MediatorUtil;
	import cn.sevencool.sangocraft.data.model.RExperienceUpdate;
	import cn.sevencool.sangocraft.data.model.RFriendNumVO;
	import cn.sevencool.sangocraft.data.model.RGetCurrency;
	import cn.sevencool.sangocraft.data.model.RLeaderVO;
	import cn.sevencool.sangocraft.data.model.RReinforcementPointsVO;
	import cn.sevencool.sangocraft.data.model.RVigorUpdate;
	import cn.sevencool.sangocraft.data.model.SActionPower;
	import cn.sevencool.sangocraft.data.model.SRGetMailNumVO;
	import cn.sevencool.sangocraft.data.symbols.CommonData;
	import cn.sevencool.sangocraft.data.symbols.SystemModelLocator;
	import cn.sevencool.sangocraft.data.symbols.material.MaterialKeys;
	import cn.sevencool.sangocraft.data.symbols.material.MaterialManager;
	import cn.sevencool.sangocraft.data.symbols.material.factory.ImageFactory;
	import cn.sevencool.sangocraft.web.events.BundlerEvent;
	import cn.sevencool.sangocraft.web.manager.BundleResManager;
	import cn.sevencool.sangocraft.web.manager.ResLoaderManager;
	import cn.sevencool.sangocraft.web.manager.UIMananger;
	import cn.sevencool.sangocraft.web.symbols.AlertPanel;
	import cn.sevencool.sangocraft.web.ui.barracks.view.BarracksPanel;
	import cn.sevencool.sangocraft.web.ui.grandCouncil.view.GrandCouncilPanel;
	import cn.sevencool.sangocraft.web.ui.militaryOffice.view.MilitaryOfficePanel;
	import cn.sevencool.sangocraft.web.ui.screen.mediator.ScreenMediator;
	import cn.sevencool.sangocraft.web.ui.screen.view.ScreenPanel;
	
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	
	public class BasicInforMediator extends BaseBasicInforMediator implements IUIOperateBaseInfoMadiator
	{
		/**
		 * 行动力按钮可用
		 * 刷新时间
		 * */
		private var _mobilityBtnTimer:Timer = null;
		
		/**
		 * 被点击的按钮
		 * */
		private var _targetBtn:SimpleButton = null;
		
		private var _screen:ScreenPanel = null ;
		
		private var _goldNum:int = 0;
		
		private var _reinPoint:int = 0;
		
		private var _fameNum:int = 0;
		
		private var _mailNum:int = 0;
		
		private var _friendNum:int = 0;
		
		private var _leader:int = 0; 
		
		private var _roleLvl:int = 0;
		
		private var _nowNeedExp:int = 0;		
		
		private var picDic:Dictionary = null;;

		private var _buyCount:int ;
		
		private var _needGold:int ;
		
		private var _nowAct:int ;
		
		private var _maxAct:int ;
		public function BasicInforMediator()
		{
		}
		
		/**
		 * 初始化 mediator
		 */		
		override public function startup():void
		{
			var screenM:ScreenMediator =MediatorUtil.getMediatorByInterface(ScreenMediator) as ScreenMediator;
			_screen = screenM.screenPanel ;
			_screen.playerInfo.mediatorUI = this;
			_screen.playerInfo.addEventListener(FlexEvent.CREATION_COMPLETE,playerInfoCreatCompleteHAndler);
			_mobilityBtnTimer = new Timer(1000);
			_mobilityBtnTimer.addEventListener(TimerEvent.TIMER_COMPLETE , mobilityBtnTimerComplete);
			SystemModelLocator.getInstance().addEventListener(Event.RESIZE , setBackground);
			picDic = new Dictionary();
		}
		
		/**
		 * 点击按钮‘申请添加行动力’
		 */		
		public function click_MobilityValues():void
		{
			var str:String = "今天第"+buyCount.toString()+"次补充行动力，需花费"+needGold.toString()+"元宝";
			AlertPanel.show(str,"",Alert.OK|Alert.CANCEL,onCloseHandle);
		}

		
		/**
		 * 请求未读邮件数量
		 * */
		public function questEmailNum():void
		{
			super.questNoEmailNum();
		}
		
		
		/**
		 *  请求申请好友数量
		 * */
		public function questFriendNum():void
		{
			super.questApFriendNum();
		}
		
		
		/**
		 * 行动值发生变化 
		 * @param $expUpdate 变化的行动值
		 */		
		override public function mobilityValuesChange($expUpdate:RVigorUpdate):void
		{
			if($expUpdate.nSp != $expUpdate.nMaxSp)
			{
				var currentTimer:int = Math.ceil(($expUpdate.i64NextTime - CommonData.serverTime)/1000);
			}
			if(currentTimer != 0 && $expUpdate.nSp != $expUpdate.nMaxSp)
			{
				_mobilityBtnTimer.reset();
				_mobilityBtnTimer.start();
				_mobilityBtnTimer.repeatCount = currentTimer;
				
			}
			_screen.playerInfo.figure_now.figureHandler($expUpdate.nSp.toString(),MaterialKeys.EXP_SMALL,10) ; 
			_screen.playerInfo.figure_total.figureHandler($expUpdate.nMaxSp.toString(),MaterialKeys.EXP_SMALL,10) ; 
			nowAct = $expUpdate.nSp;
			maxAct = $expUpdate.nMaxSp;
			var scalex:Number = nowAct/maxAct>1 ? 1:nowAct/maxAct;
			_screen.playerInfo.btn_addValue.enabled = nowAct >= maxAct ? false :true ;
			_screen.playerInfo.img_mobility.scaleX =scalex;
		}
		
		
		/**
		 * 申请行动力
		 * 按钮是否可用
		 * @param $evt
		 */		
		protected function mobilityBtnTimerComplete($evt:TimerEvent):void
		{
			_screen.playerInfo.btn_addValue.enabled = nowAct >= maxAct ? false :true ;
			super.applicationMobilityValues();
			
		}
		
		
		/**
		 * 刷新钱币显示数 
		 * @param $getCurrency 当前的钱币信息
		 */		
		override public function currencyChange($getCurrency:RGetCurrency):void
		{
			_screen.playerInfo.gold.txtCount = $getCurrency.zhuGold.toString();
			_screen.playerInfo.sliver.txtCount = $getCurrency.gold.toString();
			goldNum = $getCurrency.zhuGold
		}

		
		/**
		 * 经验发生变化
		 * @param $expUpdate 经验发生变化
		 */		
		override public function experienceChange($experienceUpdate:RExperienceUpdate):void
		{
			_screen.playerInfo.figure_lv.figureHandler($experienceUpdate.dwLevel.toString(),MaterialKeys.LVLSUPERSMALL,10);
			var scales:Number = 	$experienceUpdate.i64NowExp/$experienceUpdate.i64MaxExp >1 ? 1:$experienceUpdate.i64NowExp/$experienceUpdate.i64MaxExp;
			_screen.playerInfo.img_LV.scaleX =  scales ;
			_screen.playerInfo.img_expSpot.x = 35 + (scales)*186 ;
			roleLvl = $experienceUpdate.dwLevel;
			nowExp = $experienceUpdate.i64MaxExp;
			var pic:int = -1 ;
			if($experienceUpdate.dwLevel < 20)
			{
				pic =1;
			}
			if($experienceUpdate.dwLevel > 19 && $experienceUpdate.dwLevel <50)
			{
				pic =2;
			}
			if($experienceUpdate.dwLevel >49)
			{
				pic =3;
			}
			refreshBackground(pic.toString());
		}
		
		
		/**
		 * 行动力购买信息发生变化
		 * */
		override public function actionPowerInfo($sAction:SActionPower):void
		{
			buyCount = $sAction.nTodayReplenishSpCount;
			needGold = $sAction.nSpeedZhuGold;
			_screen.playerInfo.btn_addValue.enabled = $sAction.boIsReplenishSpTodayAllow;
			_screen.playerInfo.btn_addValue.enabled = nowAct >= maxAct ? false :true ;
		}
		private var _backSp:Sprite=null;
		private function refreshBackground($pic:String):void
		{
			_pic = $pic ;
			if(!picDic[$pic])
			{
				picDic[$pic] = $pic;
				ResLoaderManager.getInstance().addEventListener(Event.COMPLETE,resLoadingHandler);
				var urlArr:Array = [] ;
				urlArr.push(MaterialManager.getInstance().versionCheckURL(MaterialKeys.CITY_BACK,$pic));
				var event:BundlerEvent = new BundlerEvent(BundlerEvent.MISS,urlArr);
//				BundleResManager.DEFAULT_DOWNLOADER_EVENTDISPATCHER.dispatchEvent(event);
				getBackgroundSprite(_pic);
			}
		}
		
		private var _pic:String = '' ;
		protected function resLoadingHandler($evt:Event):void
		{
			ResLoaderManager.getInstance().removeEventListener(Event.COMPLETE,resLoadingHandler);
			if(!_screen.playerInfo.initialized)
			{
				_playerInfoInitialized = false ;
				return;
			}
			getBackgroundSprite(_pic);
		}
		

		private var _playerInfoInitialized:Boolean = true ;

		protected function playerInfoCreatCompleteHAndler($evt:FlexEvent):void
		{
			if(!_playerInfoInitialized)
			{
				getBackgroundSprite(_pic);
			}
		}
		
		/**
		 * main screen background Sprite used to display 
		 */
		private var _backgroundSp:Sprite = null;
		private function getBackgroundSprite($pic:String):void
		{
			var loadUrl:String = MaterialManager.getInstance().getURL(MaterialKeys.CITY_BACK,$pic) ;
			var sp:Sprite = ImageFactory.getImage(loadUrl , _backSp);
			if(sp.numChildren >0)
			{
				_backgroundSp = sp;
				setBackground();
			}else
			{
				sp.addEventListener(Event.COMPLETE, onBackgroundSpCompleted);
			}
		}
		
		protected function onBackgroundSpCompleted(event:Event):void
		{
			var sp:Sprite = event.currentTarget as Sprite;
			sp.removeEventListener(Event.COMPLETE, onBackgroundSpCompleted);
			_backgroundSp = sp;
			setBackground();
			
		}
		
		private function setBackground($event:Event = null ):void
		{
			if(!_backgroundSp)
				return ;
			TweenLite.to(_screen.playerInfo.small_city,1,{alpha:0,visible:false,onComplete:spriteBackGroudComplete});
			_backgroundSp.width  = UIMananger.getInstance().container.width+100;
			_backgroundSp.height = UIMananger.getInstance().container.height;
			_screen.playerInfo.back_city.addChild(_backgroundSp);
		}
		
		
		protected function spriteBackGroudComplete():void
		{
			_screen.playerInfo.small_city.visible = false ;
		}
		
		/**
		 * 援军点数发生变化
		 * */
		override public function reinPointChange($rr:RReinforcementPointsVO):void
		{
			reinPoint = $rr.dwReinforcement;
		}
		
		/**
		 * 邮件个数发生变化
		 * */
		override public function emailNumChange($srEmail:SRGetMailNumVO):void
		{
			mailNum = $srEmail.nCount;
		}
		
		
		/**
		 * 好友个数发生变化
		 * */
		override public function friendNumChange($rfriend:RFriendNumVO):void
		{
			friendNum = $rfriend.btCount;
		}
		
		/**
		 * 统率力变化
		 * */
		override public function leaderChange($leader:RLeaderVO):void
		{
			leader = $leader.nCommander
		}
		
		/**
		 *  点击建筑 
		 * 
		 */		
		public function clickBuilding(evt:MouseEvent):void
		{
			if(evt && (evt.target is SimpleButton ) && !_targetBtn)
			{
				_targetBtn = evt.target as SimpleButton;
				switch(_targetBtn.name)
				{
					case 'militaryOffice'://军机处
						UIMananger.getInstance().showOrHide(GrandCouncilPanel);
						break ;
					case 'barrack'://兵营
						UIMananger.getInstance().showOrHide(BarracksPanel);
						break ;
					case 'recruitTalent'://招贤府
						UIMananger.getInstance().showOrHide(MilitaryOfficePanel);
						break ;
					case 'undeveloped'://未开发
						AlertPanel.show('对不起，此功能未开放！');
						break ;
					default:
						throw new Error( 'clihandler' + _targetBtn) ;
				}
				_targetBtn = null;
			}
		}
		
		
		 		/**
		* 取到当前元宝数目
		* */	
		public function getGodIngot():int
		{
			return goldNum;
		}
		
		/**
		 * 当前援军点数
		 * */
		public 	function getReinPoint():int
		{
			return reinPoint;
		}

		/**
		 * 当前抽奖次数
		 * */
		public function getMainShowNum():int
		{
			
			return int(reinPoint/200)+int(goldNum/30);
		
		}
		
		/**
		 * 当前社交显示个数
		 * */
		public function getMainSocialNum():int
		{
			
			return mailNum + friendNum; 
		
		}
		
		/**
		 * 未读邮件个数
		 * */
		public function getNoReadEmailNum():int
		{
		
			return _mailNum
		
		}
		
		/**
		 * 玩家统率力
		 * */
		public function getLeader():int
		{
			return leader;
		}
		
		/**
		 * 申请好友个数
		 * */
		public function getApplyFriendNum():int
		{
		
			return _friendNum
		
		}
		
		/**
		 * 获取人物等级信息
		 * */
		public function getLvl():int
		{
			return roleLvl;
		}
		
		
		/**
		 * 人物当前经验
		 * */
		public 	function roleNowExp():int
		{
			return nowExp;
		}
		
		/**
		 * 购买行动力弹出面板关闭函数
		 * */
		private function onCloseHandle(e:CloseEvent):void
		{
			if(e.detail == Alert.OK)
			{
				super.buyActionPower();
			}
		
		}
		
		/**
		 * 保存援军点数
		 * */
		public function get reinPoint():int
		{
			return _reinPoint;
		}

		/**
		 * @private
		 */
		public function set reinPoint(value:int):void
		{
			_reinPoint = value;
		}

		/**
		 * 保存当前金币数
		 * */
		public function get goldNum():int
		{
			return _goldNum;
		}

		/**
		 * @private
		 */
		public function set goldNum(value:int):void
		{
			_goldNum = value;
		}

		/**
		 * 当前招贤府抽奖次数
		 * */
		public function get fameNum():int
		{
			return _fameNum;
		}

		/**
		 * @private
		 */
		public function set fameNum(value:int):void
		{
			_fameNum = value;
		}

		/**
		 * 邮件个数
		 * */
		public function get mailNum():int
		{
			return _mailNum;
		}

		/**
		 * @private
		 */
		public function set mailNum(value:int):void
		{
			_mailNum = value;
		}

		/**
		 * 好友个数
		 * */
		public function get friendNum():int
		{
			return _friendNum;
		}

		/**
		 * @private
		 */
		public function set friendNum(value:int):void
		{
			_friendNum = value;
		}

		/**
		 * 统率力
		 * */
		public function get leader():int
		{
			return _leader;
		}

		/**
		 * @private
		 */
		public function set leader(value:int):void
		{
			_leader = value;
			CommonData.nCommander = leader;
		}

		/**
		 * 人物等级信息
		 * */
		public function get roleLvl():int
		{
			return _roleLvl;
		}

		/**
		 * @private
		 */
		public function set roleLvl(value:int):void
		{
			_roleLvl = value;
		}

		/**
		 * 人物当前经验值
		 * */
		public function get nowExp():int
		{
			return _nowNeedExp;
		}

		/**
		 * @private
		 */
		public function set nowExp(value:int):void
		{
			_nowNeedExp = value;
		}

		/**
		 * 
		 * 今天第几次购买*/
		public function get buyCount():int
		{
			return _buyCount;
		}

		/**
		 * @private
		 */
		public function set buyCount(value:int):void
		{
			_buyCount = value;
		}

		/**
		 * 消耗的金币
		 * */
		public function get needGold():int
		{
			return _needGold;
		}

		/**
		 * @private
		 */
		public function set needGold(value:int):void
		{
			_needGold = value;
		}

		private function get nowAct():int
		{
			return _nowAct;
		}

		private function set nowAct(value:int):void
		{
			_nowAct = value;
		}

		private function get maxAct():int
		{
			return _maxAct;
		}

		private function set maxAct(value:int):void
		{
			_maxAct = value;
		}
		
		
	}
}