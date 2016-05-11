package cn.sevencool.sangocraft.web.ui.socialRelative.mediator
{
	import cn.sevencool.sangocraft.data.manager.screen.mediator.IUIOperateBaseInfoMadiator;
	import cn.sevencool.sangocraft.data.manager.socalRelative.mediator.BaseSocalRelativeMediator;
	import cn.sevencool.sangocraft.data.manager.socalRelative.mediator.IUIOperatableMilitarySocalMediator;
	import cn.sevencool.sangocraft.data.manager.utils.MediatorUtil;
	import cn.sevencool.sangocraft.data.model.FriendVO;
	import cn.sevencool.sangocraft.data.model.IntVO;
	import cn.sevencool.sangocraft.data.model.ItemVO;
	import cn.sevencool.sangocraft.data.model.RChiefInfoVO;
	import cn.sevencool.sangocraft.data.model.RDelFriendVO;
	import cn.sevencool.sangocraft.data.model.RGetFriendListVO;
	import cn.sevencool.sangocraft.data.model.RGetLookAtFriendInfoVO;
	import cn.sevencool.sangocraft.data.model.RGetMailInfoVO;
	import cn.sevencool.sangocraft.data.model.SUpLevel;
	import cn.sevencool.sangocraft.data.symbols.CommonData;
	import cn.sevencool.sangocraft.data.symbols.ItemManager;
	import cn.sevencool.sangocraft.data.symbols.ItemsManager;
	import cn.sevencool.sangocraft.data.vo.EMailVO;
	import cn.sevencool.sangocraft.data.vo.FriendDisplayVO;
	import cn.sevencool.sangocraft.data.vo.ItemDescription;
	import cn.sevencool.sangocraft.data.vo.ItemOperationVO;
	import cn.sevencool.sangocraft.data.vo.MonsterExpVO;
	import cn.sevencool.sangocraft.web.manager.UIMananger;
	import cn.sevencool.sangocraft.web.symbols.PagingArray;
	import cn.sevencool.sangocraft.web.ui.barracks.view.GeneralDetailsPanel;
	import cn.sevencool.sangocraft.web.ui.mainPanel.mediator.BasicInforMediator;
	import cn.sevencool.sangocraft.web.ui.socialRelative.view.EmailPanel;
	import cn.sevencool.sangocraft.web.ui.socialRelative.view.RecieveEmailPanel;
	import cn.sevencool.sangocraft.web.ui.socialRelative.view.ShowEmailPanel;
	import cn.sevencool.sangocraft.web.ui.socialRelative.view.SocialRelativePanel;
	import cn.sevencool.sangocraft.web.ui.socialRelative.view.WriteEmailPanel;
	
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.events.FlexEvent;
	import mx.utils.StringUtil;
	
	import org.oswxf.rpc.util.Datamation;
	
	/**
	 * project: sangocraft_Web
	 * @class: SocialRelativeMediator
	 * @author: wangtaofeng
	 * @usage: 社交UImediator管理器
	 * @since: 2013-8-22
	 * @modified: 2013-8-22
	 * @modifier: wangtaofeng
	 */
	
	public class SocialRelativeMediator extends BaseSocalRelativeMediator implements IUIOperatableMilitarySocalMediator
	{
		/**{0}/{1}*/
		private static const util:String = '{0}/{1}' ;
		/**
		 * 好友列表0
		 * */
		private static const FRIENDLIST:uint = 0;
		
		/**
		 * 添加好友1
		 * */
		private static const ADDFRIEND:uint = 1;
		
		/**
		 * 删除好友2
		 * */
		private static const DELEFRIEND:uint = 2;
		
		/**
		 * 查找好友3
		 * */
		private static const FINDFRIEND:uint = 3;
		
		/**
		 * 获取主将信息
		 * */
		private static const GETCHIEFINFO:uint = 4;
		
		/**
		 * 战前配置
		 * */
		private static const PREBATTLE:uint = 5;
		
		/**
		 * 好友面板id
		 * */
		private static const FRIENDID:int = 0;
		
		/**
		 * 申请好友面板id
		 * */
		private static const APPLYID:int = 1;
		
		/**
		 * 邮件面板id
		 * */
		private static const EMAILID:int = 2;
		
		/**
		 * 读取邮件面板id
		 * */
		private static const READMAIL:int = 3;
		
		/**
		 * 收件人
		 * */
		[Bindable]
		public var recieveName:String = '';
		
		/**
		 * 邮件主题
		 * */
		[Bindable]
		public var emailTheme:String = "" ;
		
		private var _friendColl :ArrayCollection = null;
		
		
		private var _applyColl:ArrayCollection = null;
		
		private var _emailList:ArrayCollection = null;
		
		private var _applyList:Array = [];
		
		private var _friendList:Array = [];
		
		private var _mailArr:Array  = [];
		/**数据保存*/
		private var _arrpagition:PagingArray = null;
		
		/**
		 * 当前页
		 * */
		private var _nowPageDic:Dictionary= new Dictionary();
		
		/**
		 * 好友列表返回
		 * */
		private var _rgetFriendList:RGetFriendListVO = null;
		
		
		/**
		 * 邮件面板
		 * */
		private var _emailPanel:ShowEmailPanel = null;
		
		/**
		 * 邮件主面板
		 * */
		private var _emPanel:EmailPanel = null;
		
		/**
		 * 社交面板
		 * */
		private var _socialPanel:SocialRelativePanel = null;
		
		/**
		 * 接受邮件面板
		 * */
		private var _recievePanel:RecieveEmailPanel = null;
		
		/**
		 * 写邮件面板
		 * */
		private var _writeMailPanel:WriteEmailPanel = null;
		
		private var _baseinfo:BasicInforMediator = null;
		
		private var _emailSelectIndex:int = -1;
		
		private var _uiManage:UIMananger = null;
		
		/**
		 * 读取邮件的信息
		 * */
		private var _email:EMailVO = null;
		
		private var isEmailHave:Boolean = false;
		public function SocialRelativeMediator()
		{
			super();
		}
		
		
		/**
		 * mediator 初始化  
		 */		
		override public function startup():void
		{
			_uiManage = UIMananger.getInstance();
			_socialPanel = _uiManage.getUIObj(SocialRelativePanel) as SocialRelativePanel ;
			_socialPanel.mediatorUI = this ;
			_socialPanel.addEventListener(FlexEvent.CREATION_COMPLETE,socialPanelCreationComplete);
			_baseinfo = MediatorUtil.getMediatorByInterface(IUIOperateBaseInfoMadiator) as BasicInforMediator;
			_applyColl = new ArrayCollection();
			_friendColl = new ArrayCollection();
			_emailList = new ArrayCollection();
		}
		
		
		/**好友排序
		 * @param $type 排序类型 0兵种排序、1兵量排序、2攻击排序、3防御排序
		 * @好友数组 $array
		 * */
		public function sortFriendbyType($index:int,$type:int):void
		{
			switch($type)
			{
				case 0://排序好友数组
					friendList = super.sortFriendByType($index,friendList);
					
					break;
				case 1:
					applyList = super.sortFriendByType($index,applyList);
					break;
				default:
					throw new Error("$type"+$type)
			}
		}
		
		
		/**
		 * 搜索好友
		 * @param $dwID
		 * */
		public function btn_lookOutFriend($dwID:int):void
		{
			super.lookOutFriend($dwID);
		}
		
		
		/**
		 * 请求好友数据
		 * @param $type:请求好友数组类型 0:好友列表，1:申请好友列表
		 * */
		public function sendSGetFriendListVO($type:int):void
		{
			switch($type)
			{
				case 0:
					super.operateToFriend(0,0,0);
					break;
				case 1:
					
					super.operateToFriend(0,0,1);
					break;
				default:
				{
					throw new Error("$type"+$type);
				}
			}	
		}
		
		
		/**
		 * 打开邮件面板
		 * */
		public function openEmailPanel():void
		{
			super.askForMailList();
		}
		
		
		/**
		 * 邮件读取
		 * */
		override protected function readEmailInfo($email:EMailVO):void
		{
			_socialPanel.email.currentState = "readEmail";
			
			_socialPanel.email.email_recieve.emailArr = mailArr;;
			_socialPanel.email.email_recieve.rGetMailInfoVO = $email;
			
			var email:EMailVO = null ;
//			var index:int  = mailArr.indexOf($email);
//			emailSelectIndex = index + 1 ; 
			for(var i:int = 0;i<mailArr.length;i++)
			{
				email = mailArr[i] as EMailVO ;
				if(email.dwMailID == $email.dwMailID)
				{
					emailSelectIndex = i+1;
					break;
				}
			}
		} 
		
		
		/**
		 * 好友数组显示
		 * */
		override protected function set maintainArr(value:Array):void
		{
			friendList = value;
		}
		
		
		/**
		 * 申请好友数据
		 * */
		override protected function set applyMaintainArr(value:Array):void
		{
			applyList = value
		}
		
		
		/**
		 * 邮件列表
		 * */
		override protected function set eMailVOList(value:Array):void
		{
			super.eMailVOList = value;
			this.mailArr = value
		}
		
		
		/**
		 * 删除所有选择邮件
		 * */
		public function delAllSelectEmail():void
		{
			
			var arr:Array = [];
			var email:EMailVO = null;
			for(var i:int = 0;i<mailArr.length;i++)
			{
				email = mailArr[i] as EMailVO;
				if(email.isCheck)
				{
					var id:int =email.dwMailID;
					var intvo:IntVO = new IntVO();
					intvo.nValue = id;
					arr.push(intvo);
				}
			}
			if(arr.length>0)
			{
				super.deleSelectEmail(arr);			
			}
		}
		
		
		/**
		 * 删除当前邮件
		 * @param $emailID:int
		 * */
		public function delNowEmail($emailid:int):void
		{
			var arr:Array = [];
			var email:EMailVO = null;
			var intvo:IntVO = new IntVO();
			intvo.nValue = $emailid;
			arr.push(intvo);
			_socialPanel.email.currentState = "emailList";
			super.deleSelectEmail(arr);	
		}
		
		
		/**
		 * 发送邮件
		 * @param $name:Stirng
		 * */
		public function sendEMailTO($name:String = ''):void
		{
			_socialPanel.currentState = "email";
			_socialPanel.email.currentState= "writeEmail";
			if($name!='')
			{
				_socialPanel.email.email_write.sendName = $name;
				
			}
		}
		
		public  function sendEmail($name:String = '',$theme:String=""):void
		{
			_socialPanel.currentState = "email";
			_socialPanel.email.currentState= "writeEmail";
			_socialPanel.email.email_write.theme = $theme;
			_socialPanel.email.email_write.isReply = true;
			_socialPanel.email.email_write.sendName = $name;
		}
		
		
		/**
		 * 读取邮件
		 * @param $emailID:邮件id
		 * @param $itemIndex:int 当前邮件的索引
		 * */
		public function readEmail($emailID:int,$itemIndex:int):void
		{
			super.askForMail($emailID);
		}
		
		/**
		 * 读取前一封邮件
		 * */
		public function readEmailBefore($nowPage:int):void
		{
			var email:EMailVO = mailArr[$nowPage-1] as EMailVO;
			if(email)
			{
				super.askForMail(email.dwMailID);
			}	
		}
		
		
		/**
		 * 点击人物头像选择操作类型
		 * @param $index:int
		 * @param $friendIndex:int
		 * */
		public function menuItemClick($index:int,$friend:FriendDisplayVO,name:String = ''):void
		{
			switch($index)
			{
				case 0://将领详情
					//					super.operateToFriend(GETCHIEFINFO,$dwid);
					var general:GeneralDetailsPanel =	_uiManage.getUIObj(GeneralDetailsPanel) as GeneralDetailsPanel;
					var itemOP:ItemOperationVO = new ItemOperationVO();
					itemOP.item = new ItemVO();
					itemOP.item.dwBaseID = $friend.dwCommanderID;
					var arr:Array = [$friend.nAttack,$friend.nDefense,$friend.nSoldierNumber,$friend.btCommanderLevel]
					general.arr = arr;
					general.item = itemOP;
					general.showType = 3;
					_uiManage.showOrHide(GeneralDetailsPanel) ;
					break;
				case 1://发送邮件
					recieveName = name;
					_socialPanel.currentState = "email";
					_socialPanel.tb_Menu.selectedIndex = 3;
					_socialPanel.email.currentState= "writeEmail";
					if(_socialPanel.email.email_write)
					{
						sendEMailTO(name);
					}
					break;
				case 2://删除好友
					
					delFriend($friend.dwOnlyID);
					break;
				default:
					
					throw new Error("$index"+$index)
			}
		}
		
		
		/**
		 * 对好友进行排序
		 * @param $type :int数据类型 1为好友列表 2为申请好友列表
		 * @param $state :int 排序方式
		 * */
		public function sortFriendList($type:int,$state:int):void
		{
			switch($type)
			{
				case 1:
					
					friendList = super.sortFriendByType($state,friendList);
					break;
				case 2:
					applyList = super.sortFriendByType($state,applyList);
					
					break;
				default:
					throw new Error("$type"+$type)
			}
			
		}
		
		
		/**
		 * 显示玩家信息
		 * */
		override public function showPlayInfo($RChiefInfoVO:RChiefInfoVO):void
		{
			
			var general:GeneralDetailsPanel =	_uiManage.getUIObj(GeneralDetailsPanel) as GeneralDetailsPanel;
			var itemOP:ItemOperationVO = new ItemOperationVO();
			itemOP.item = new ItemVO();
			itemOP.item.dwBaseID = $RChiefInfoVO.dwBaseId;
			var arr:Array = [$RChiefInfoVO.nAttack,$RChiefInfoVO.nDefense,$RChiefInfoVO.nSoldierNum]
			general.arr = arr;
			general.item = itemOP;
			general.showType = 4;
			_uiManage.showOrHide(GeneralDetailsPanel) ;
		}
		
		
		/**
		 * 发送玩家信息
		 * */
		public function sendPlayerInfo($dwid:int,$type:int):void
		{
			super.onSendPlayerInfo($dwid,$type);
			
		}
		
		/**
		 * 通过唯一id添加好友
		 * */
		public function addFriend($dwID:int):void
		{
			super.operateToFriend(1,$dwID,0);
		}
		
		/**
		 * 通过等级和主将名称查看主将信息
		 * @param $onlyID:int
		 * */
		public function lookChiefInfo(baseid:Number):void
		{
		}
		
		
		/**
		 * 通过onlyID删除好友
		 * */
		public function delFriend($onlyId:int):void
		{
			
			super.operateToFriend(2,$onlyId,0);
			
		}
		
		/**
		 * 数组分页
		 * @param $page 当前页
		 * @param $type 数据源类型 0好友列表 1申请好友列表 2 邮件列表
		 * 
		 * */
		public function refreshPage($page:int,$type:int):void
		{
			_nowPageDic[$type] = $page;
			switch($type)
			{
				case 0:
					_socialPanel.refreshNum(getApplyNum(),getEmailNum());
					_socialPanel.lbl_total.text = getFriendNum();
					if(!_socialPanel.friendSource)
					{
						return;
					}
					_arrpagition = new PagingArray(friendList,6);
					_arrpagition.nowPage = $page;
					_friendColl.source = _arrpagition.source();
					
					_socialPanel.setFriendTipVisible(!Boolean(friendList.length));
					_socialPanel.friendSource.dataProvider = _friendColl;
					
					_socialPanel.paga_group.totalPage = _arrpagition.totalPage;
					_socialPanel.paga_group.nowPage = _arrpagition.nowPage;
					break;
				case 1:
					if(!_socialPanel.applyFriendSource)
					{
						return;
					}
					_arrpagition = new PagingArray(applyList,6);
					_arrpagition.nowPage = $page;
					_applyColl.source = _arrpagition.source();
					_socialPanel.setFriendApplyTipVisible(Boolean(!applyList.length));
					_socialPanel.applyFriendSource.dataProvider = _applyColl;
					_socialPanel.refreshNum(applyList.length,getEmailNum());
					_socialPanel.paga_group.nowPage = _arrpagition.nowPage;
					_socialPanel.paga_group.totalPage = _arrpagition.totalPage;
					
					break;
				case 2:
					_socialPanel.refreshNum(getApplyNum(),getEmailNum());
					if(!_socialPanel.email && !_socialPanel.email.email_emaiList)
					{
						return;
					}
					_arrpagition = new PagingArray(mailArr,7);
					_arrpagition.nowPage = $page;					
					_emailList.source= _arrpagition.source();
					
					_emailPanel.setEmailTipVisible(!Boolean(mailArr.length));
					
					_socialPanel.email.pageChange.nowPage = $page;
					_socialPanel.email.pageChange.totalPage = _arrpagition.totalPage;
					_socialPanel.email.email_emaiList.list_email.dataProvider = _emailList;
					break;
				case 3:
					if(!_socialPanel.email && !_socialPanel.email.email_recieve)
					{
						return;
					}
					_arrpagition = new PagingArray(mailArr,1);
					_arrpagition.nowPage = $page;			
					_socialPanel.email.email_recieve.page.totalPage = _arrpagition.totalPage;
					_socialPanel.email.email_recieve.page.nowPage = $page
					break;
				default:
					throw new Error("$type"+$type)
			}
		}
		
		
		
		/**
		 * 选择当前页所有邮件
		 * */
		public function selectAll():void
		{
			var nowPage:int = _nowPageDic[EMAILID];
			super.selectAllReadMail(7,nowPage);
		}
		
		/**
		 * 取消选择当前页的所有邮件
		 * */
		public function disSelectAll():void
		{
			var nowPage:int = _nowPageDic[EMAILID];
			super.disSelectAllReadMail(7,nowPage);
			
		}
		
		
		/**
		 * 设置邮件面板状态
		 * */
		public function setEmailState($state:String):void
		{
			_socialPanel.email.currentState = $state
		}
		
		
		/**
		 * 邮件个数
		 * */
		public function getEmailNum():int
		{
			_baseinfo = MediatorUtil.getMediatorByInterface(IUIOperateBaseInfoMadiator) as BasicInforMediator;
			return _baseinfo.getNoReadEmailNum();
		}
		
		
		/**
		 * 删除当前页选择邮件
		 * */
		public function deleteNowSelect():void
		{
			var nowPage:int = _nowPageDic[EMAILID];
			super.deleAllReadMail(7,nowPage);
			
		} 
		
		/**
		 * 获取申请好友数量
		 * */
		public function getApplyNum():int
		{
			_baseinfo = MediatorUtil.getMediatorByInterface(IUIOperateBaseInfoMadiator) as BasicInforMediator;
			return _baseinfo.getApplyFriendNum();
		}
		
		/**
		 * 发送邮件个数包
		 * */
		public function sendEmailNumVO():void
		{
			_baseinfo = MediatorUtil.getMediatorByInterface(IUIOperateBaseInfoMadiator) as BasicInforMediator;
			_baseinfo.questEmailNum();
		}
		
		/**
		 * 发送好友个数包
		 * */
		public function sendApplyNum():void
		{
			_baseinfo = MediatorUtil.getMediatorByInterface(IUIOperateBaseInfoMadiator) as BasicInforMediator;
			_baseinfo.questFriendNum();
			
		}
		
		
		/**
		 * 获取查询好友信息
		 * */
		override public function getRGetLookAtFriendInfo($getInfo:RGetLookAtFriendInfoVO):void
		{
			
			
		}
		
		/**
		 * 获取好友数组
		 * */
		public function getTranslationInfo():void
		{
			super.goodFriendList();
		}
		
		/**
		 * 获取申请好友数组
		 * */
		public function getApplyTranslation():void
		{
			super.applyFriendList();
		}
		
	
		/**
		 * 获取当前好友数量显示
		 * */
		public function getFriendNum():String
		{
			_baseinfo = MediatorUtil.getMediatorByInterface(IUIOperateBaseInfoMadiator) as BasicInforMediator;
			var lvl:int = _baseinfo.roleLvl ;
			var monsterExpVO:MonsterExpVO = ItemManager.getInstance().expDic[lvl];
			var maxNum:int = monsterExpVO.friendNum;
			var str:String = StringUtil.substitute(util,friendList.length,maxNum);
			return str;
		}
	
		
		private function writeMailPanelCreationComplete(e:FlexEvent):void
		{
			_writeMailPanel.removeEventListener(FlexEvent.CREATION_COMPLETE,writeMailPanelCreationComplete);
			_writeMailPanel.mediatorUI = this;
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */		
		private function emPanelCreationComplete(e:FlexEvent):void
		{
			_emPanel.mediatorUI = this;
			_emPanel.removeEventListener(FlexEvent.CREATION_COMPLETE,emPanelCreationComplete);
		}
		
		/**
		 *邮件面板创建完成 
		 * @param e
		 * 
		 */		
		private function emailPanelCreationComplete(e:FlexEvent):void
		{
			_emailPanel.removeEventListener(FlexEvent.CREATION_COMPLETE,emailPanelCreationComplete);
			_emPanel = _emailPanel.email_emaiList;
			_emPanel.addEventListener(FlexEvent.CREATION_COMPLETE,emPanelCreationComplete);
			_writeMailPanel = _emailPanel.email_write;
			_writeMailPanel.addEventListener(FlexEvent.CREATION_COMPLETE,writeMailPanelCreationComplete);
		}
		
		
		/**
		 *社交面板创建完成 
		 * @param e
		 * 
		 */		
		private function socialPanelCreationComplete(e:FlexEvent):void
		{
			_socialPanel.removeEventListener(FlexEvent.CREATION_COMPLETE,socialPanelCreationComplete);
			_emailPanel = _socialPanel.email;
			_emailPanel.addEventListener(FlexEvent.CREATION_COMPLETE,emailPanelCreationComplete);
			_emailPanel.mediatorUI = this;
		}
		
		public function get applyList():Array
		{
			return _applyList;
		}
		
		public function set applyList(value:Array):void
		{
			_baseinfo = MediatorUtil.getMediatorByInterface(IUIOperateBaseInfoMadiator) as BasicInforMediator;
			_applyList = value;
			_baseinfo.questFriendNum();
			
			if(!_nowPageDic[APPLYID])
			{
				_nowPageDic[APPLYID] = 1;
			}
			refreshPage(_nowPageDic[APPLYID],APPLYID);
		}
		
		
		/**
		 * 申请好友数组
		 * */
		public function get friendList():Array
		{
			return _friendList;
			
		}
		
		/**
		 * @private
		 */
		public function set friendList(value:Array):void
		{
			_friendList = value;
			if(!_nowPageDic[FRIENDID])
			{
				_nowPageDic[FRIENDID] = 1;
			}
			refreshPage(_nowPageDic[FRIENDID],FRIENDID);
		}
		
		public function get mailArr():Array
		{
			return _mailArr;
		}
		
		public function set mailArr(value:Array):void
		{
			_mailArr = value;
			if(_socialPanel.email.currentState =="emailList")
			{
				if(!_nowPageDic[EMAILID])
				{
					_nowPageDic[EMAILID] = 1;
				}
				refreshPage(_nowPageDic[EMAILID],EMAILID);
			}else if(_socialPanel.email.currentState == "readEmail")
			{
				refreshPage(emailSelectIndex,READMAIL);
			}
		}
		
		/**
		 * 记录当前的邮件index
		 * */
		public function get emailSelectIndex():int
		{
			return _emailSelectIndex;
		}
		
		/**
		 * @private
		 */
		public function set emailSelectIndex(value:int):void
		{
			_emailSelectIndex = value;
			refreshPage(emailSelectIndex,READMAIL);
		}
	}
	
}