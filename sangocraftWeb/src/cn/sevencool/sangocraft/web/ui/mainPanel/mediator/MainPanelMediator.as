package cn.sevencool.sangocraft.web.ui.mainPanel.mediator
{
	import cn.sevencool.sangocraft.data.manager.login.mediator.IUIOperatableLoginMediator;
	import cn.sevencool.sangocraft.data.manager.mainPanel.handlerKey.ChatHandlerKey;
	import cn.sevencool.sangocraft.data.manager.mainPanel.mediator.BaseMainPanelMediator;
	import cn.sevencool.sangocraft.data.manager.mainPanel.mediator.IUIOperateMainPanel;
	import cn.sevencool.sangocraft.data.manager.screen.mediator.IUIOperateBaseInfoMadiator;
	import cn.sevencool.sangocraft.data.manager.socalRelative.mediator.IUIOperatableMilitarySocalMediator;
	import cn.sevencool.sangocraft.data.manager.utils.MediatorUtil;
	import cn.sevencool.sangocraft.data.model.RSWhisperInfo;
	import cn.sevencool.sangocraft.data.symbols.CommonData;
	import cn.sevencool.sangocraft.data.vo.FightDataVo;
	import cn.sevencool.sangocraft.web.battle.ai.FightLogical;
	import cn.sevencool.sangocraft.web.manager.UIMananger;
	import cn.sevencool.sangocraft.web.ui.barracks.view.BarracksPanel;
	import cn.sevencool.sangocraft.web.ui.battleField.view.ExpeditionPanel;
	import cn.sevencool.sangocraft.web.ui.grandCouncil.view.GrandCouncilPanel;
	import cn.sevencool.sangocraft.web.ui.login.mediator.LoginMediator;
	import cn.sevencool.sangocraft.web.ui.mainPanel.view.Announcement;
	import cn.sevencool.sangocraft.web.ui.mainPanel.view.ChatPanel;
	import cn.sevencool.sangocraft.web.ui.militaryOffice.view.MilitaryOfficePanel;
	import cn.sevencool.sangocraft.web.ui.screen.mediator.ScreenMediator;
	import cn.sevencool.sangocraft.web.ui.screen.view.ScreenPanel;
	import cn.sevencool.sangocraft.web.ui.socialRelative.mediator.SocialRelativeMediator;
	import cn.sevencool.sangocraft.web.ui.socialRelative.view.SocialRelativePanel;
	
	import com.sevencool.rtslogic.Battlefield;
	
	import flash.events.Event;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;

	/**
	 * project: sangocraft_Web
	 * @class: MainPanelMediator
	 * @author: zhouyan
	 * @usage: 主面板mediatorUI管理器
	 * @since: 2013-8-15
	 * @modified: 2013-8-15
	 * @modifier: zhouyan 
	 */
	public class MainPanelMediator extends BaseMainPanelMediator implements IUIOperateMainPanel
	{
		private var _screen:ScreenPanel = null ;
		private var _announcement:Announcement = null ;
		/**
		 * 登录Mediator
		 * */
		private var _loginM:LoginMediator=null;
		private var _isClick:Boolean = false;
		
		private var _basicInfo:BasicInforMediator =null;
		
		private var _social:SocialRelativeMediator = null;
		public function MainPanelMediator(){}
		
		override public function startup():void
		{
			Battlefield.getActivityBattlefield().addEventListener(Event.COMPLETE,battleCompleteHandle);
			var screenM:ScreenMediator =MediatorUtil.getMediatorByInterface(ScreenMediator) as ScreenMediator;
			_screen = screenM.screenPanel ;
			_screen.gp_functionBtn.mediatorUI =this;
			_screen.combatInfo.mediatorUI =this;
			_screen.BattleUI_self.mediatorUI =this;
			_screen.BattleUI_enemy.mediatorUI =this;
			_screen.combatInfo.timerControl.mediatorUI = this;
			_screen.home.mediatorUI =this;
			if(!_screen.chat)
				_screen.chat = UIMananger.getInstance().getUIObj(ChatPanel) as ChatPanel ;
			_screen.chat.mediatorUI =this;
		}
		
		
		/**
		 * 显示 功能面板
		 * @param $type 显示的面板类型
		 * 
		 */		
		public function showFunctionPanel($type:int):void
		{
			switch($type)
			{
				case 1://战场
				{
					UIMananger.getInstance().showOrHide(ExpeditionPanel);
					break;
				}
				case 2://兵营
				{
					UIMananger.getInstance().showOrHide(BarracksPanel);
					break;
				}
				case 3://求将
				{
					UIMananger.getInstance().showOrHide(MilitaryOfficePanel);
					break;
				}
				case 4://军机
				{
					UIMananger.getInstance().showOrHide(GrandCouncilPanel);
					break;
				}
				case 5://社交
				{
					_basicInfo = MediatorUtil.getMediatorByInterface(IUIOperateBaseInfoMadiator) as BasicInforMediator;
					_basicInfo.questEmailNum();
					_basicInfo.questFriendNum();
					UIMananger.getInstance().showOrHide(SocialRelativePanel);
					break;
				}
				case 6://其他
				{
//					UIMananger.getInstance().show();
					break;
				}
				default:
				{
					throw new Error('showFunctionPanel' + $type );
				}
			}
		}
		


		/**
		 * 点击按钮'回家'
		 * */
		public function btnclick_home($type:int = 2 ):void
		{
			var str:ByteArray = FightLogical.GetFightOperateData(CommonData.dwOnlyID);
			super.askForHome($type,str);//暂时写定值
		}
		
		
		/**
		 * 点击按钮‘全军出击’ 
		 */		
		public function btnClick_armyAttack($frameIndex:int):void
		{
			super.askForArmyAttack($frameIndex);
		}
		
		
		/**
		 * 武将单个使用技能
		 * @param $frameIndex 当前回合数
		 * @param $skillID 技能ID
		 * @param $useID 使用者战斗编号
		 * 
		 */		
		public function btn_useSkill($frameIndex:int,$skillID:int,$useID:int):void
		{
			super.askForUseSkill($frameIndex,$skillID,$useID);
		}
		
		
		/**
		 * 战斗实时显示数据 
		 * @param $array 显示数组
		 */		
		 public function fightDataInfo($array:Array,$myPower:int,$aramyPower:int):void
		{
			_screen.BattleUI_self.addData = $array;
			_screen.BattleUI_enemy.addData = $array;
//			
			_screen.BattleUI_self.myPower = $myPower;
			_screen.BattleUI_enemy.myPower = $aramyPower;
			
			var mytotal:int = 0;
			for(var i:int =0;i<$array[0].length;i++)
			{
				var fightDataVo:FightDataVo = $array[0][i];
				if(!fightDataVo)
				{
					break;
				}
				mytotal +=fightDataVo.nNowHp;
			}
			
			var aramyTotal:int = 0
			for(var j:int = 0; j<$array[1].length ; j++)
			{
				var fightData:FightDataVo =$array[1][j];
				if(!fightData)
				{
					break;
				}
				aramyTotal += fightData.nNowHp;
			}
			
			var aramyStay:int = $array[2];
			
			var myStay:int = $array[3];
			
			_screen.combatInfo.aramyTotal = aramyTotal;
			_screen.combatInfo.myTotal = mytotal;
			_screen.combatInfo.stayAramyNum = aramyStay;
			_screen.combatInfo.stayNum = myStay;
			
		}
		
		 /**
		  * 点击按钮‘发送’
		  * 发送聊天信息 
		  * @param $str 聊天内容
		  * 
		  */		
		 public function clickChat($str:String,$type:int,$id:int):void
		 {
			 super.askForChatInfo($str,$type,$id);
		 }
		 
		 /**
		  * 显示私聊内容 
		  * 
		  */		 
		 public function showWhisperChat():void{
			 chartChangeType();
		 }
		 
		 /**
		  * 社交个数显示
		  * */
		 public function socialNum():int
		 {
			 _basicInfo = MediatorUtil.getMediatorByInterface(IUIOperateBaseInfoMadiator) as BasicInforMediator;
			 return _basicInfo.getMainSocialNum()
		 }
		 
		 
		 /**
		  * 招贤府显示个数
		  * */
		 public function getFameNum():int
		 {
			 _basicInfo = MediatorUtil.getMediatorByInterface(IUIOperateBaseInfoMadiator) as BasicInforMediator;
			 return  _basicInfo.getMainShowNum();
		 }
		 
	
		/**
		 * 聊天数据字典 
		 */		
		private var _chartDic:Dictionary = null;
		
		/**
		 * 聊天切换类型刷新显示数据 
		 */		
		public function chartChangeType():void
		{
			var chatStr:String = '';
			var chatType:int = int(_screen.chat.chartType.selectedValue) ;
			var chat_arr:Array = [];
			if(chatType == ChatHandlerKey.CHAT_GM)
			{
				chat_arr = totalChart;
			}else{
				chat_arr = _chartDic[chatType] ;
			}
			if(chat_arr && chat_arr.length != 0)
			{
				for(var i:int = 0 ; i < chat_arr.length ; i++ )
				{
					var message:String = chat_arr[i];
					chatStr += message ;
				}
			}
				_screen.chat.setData = chatStr;
				
		}
		
		/**
		 * 接收到新的私聊 
		 * 
		 */		
		override protected function showWhisperComing():void
		{
			_screen.chat.showUnreadMessage(1);
		}
		
		
		
		/**
		 * 接到 聊天包显示
		 * @param $dic 显示数据
		 */		
		override protected function setChatData($dic:Dictionary):void
		{
			_chartDic = $dic;
			chartChangeType();
		}
		
		
		/**
		 * 公告显示数据 
		 * @param $dic
		 */		
		override protected function setAnnouncementData($str:String):void
		{
			_loginM=MediatorUtil.getMediatorByInterface(IUIOperatableLoginMediator) as LoginMediator;
			_announcement = _loginM.announcement;
			_announcement.txt.alpha = 1;
			_announcement.setData = $str;
			setTimeout(fade_out_effect,3000);
		}
		
		/**
		 * 上线接受到私聊消息
		 * 如果有未读的的通知面板闪烁 
		 * @param $rs
		 * 
		 */	
		override protected function toChatMessage($rs:RSWhisperInfo):int
		{
			var num:int = super.toChatMessage($rs);
			if(num>0){
				//通知面板提示
				_screen.chat.showUnreadMessage(num);
			}
			return num;
		}
		
		
		
		/**
		 * 1秒钟
		 * 淡出效果 
		 * 清空显示
		 */		
		private function fade_out_effect():void
		{
			_announcement.txt.alpha = 0;
			_announcement.setData = '';
		}
		
		
		/**
		 * swf播放完毕
		 * 点击按钮 ‘回家’ 
		 * @param $evt
		 */		
		private function battleCompleteHandle($evt:Event):void
		{
			btnclick_home(1);
		}

		private function get isFirstQuest():Boolean
		{
			return _isClick;
		}

		private function set isFirstQuest(value:Boolean):void
		{
			_isClick = value;
		}
		
	}
}