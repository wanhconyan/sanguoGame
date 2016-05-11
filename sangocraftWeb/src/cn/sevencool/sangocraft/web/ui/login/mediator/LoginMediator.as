package cn.sevencool.sangocraft.web.ui.login.mediator
{
	import cn.sevencool.sangocraft.data.manager.login.mediator.BaseLoginMediator;
	import cn.sevencool.sangocraft.data.manager.login.mediator.IUIOperatableLoginMediator;
	import cn.sevencool.sangocraft.data.model.RCreateCharacterVO;
	import cn.sevencool.sangocraft.data.model.RLoginNewly;
	import cn.sevencool.sangocraft.data.model.SelectPlayerVO;
	import cn.sevencool.sangocraft.data.model.UserAuthDecoder;
	import cn.sevencool.sangocraft.data.symbols.CommonData;
	import cn.sevencool.sangocraft.data.symbols.JSUtil;
	import cn.sevencool.sangocraft.data.symbols.material.MaterialManager;
	import cn.sevencool.sangocraft.data.symbols.material.factory.ImageFactory;
	import cn.sevencool.sangocraft.web.manager.ManagerOperator;
	import cn.sevencool.sangocraft.web.manager.UIMananger;
	import cn.sevencool.sangocraft.web.symbols.AlertPanel;
	import cn.sevencool.sangocraft.web.symbols.IUIView;
	import cn.sevencool.sangocraft.web.ui.login.view.LoginPanel;
	import cn.sevencool.sangocraft.web.ui.mainPanel.view.Announcement;
	import cn.sevencool.sangocraft.web.ui.screen.view.CreatingRole;
	import cn.sevencool.sangocraft.web.ui.screen.view.LoadingPanel;
	import cn.sevencool.sangocraft.web.ui.screen.view.ScreenPanel;
	import cn.sevencool.sangocraft.web.ui.screen.view.TrailerPreload;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;
	
	import mx.core.FlexGlobals;

	/**
	 * project: sangocraft_Web
	 * @class: LoginMediator
	 * @author: zhoujingye
	 * @usage: 登录UImediator管理器
	 * @since: 2013-10-25
	 * @modified: 2013-10-25
	 * @modifier: zhoujingye 
	 */
	public class LoginMediator extends BaseLoginMediator  implements IUIOperatableLoginMediator
	{
		public function LoginMediator()
		{
			super();
		}
		/**
		 * 登录面板
		 * */
		private var _loginPanel:LoginPanel = null ;
		
		/**
		 * 创建角色面板
		 * */
		private var _creatingRole:CreatingRole =null ;
		
		/**
		 * 预加载页
		 */		
		private var _UIpreloader:IUIView = null ;
		
		/**
		 * 公告显示 
		 */		
		public var announcement:Announcement =null ;
		
		/**
		 *播放等待swf 
		 */		
		private var _loading:LoadingPanel = null;
		/**
		 * 创建角色返回
		 */		
		private var errDic:Dictionary =null;
		/**
		 * 显示管理器
		 * */
		private var _uiManager:UIMananger=null;
		/**
		 * mediator 初始化 
		 * 
		 */		
		override public function startup():void
		{
			errDic=new Dictionary();
			setErrorCode();
			_uiManager=UIMananger.getInstance();
			_loginPanel = _uiManager.getUIObj(LoginPanel) as LoginPanel ;
			_loginPanel.mediatorUI = this ;
		}
		
		/**
		 * 存放errorCode
		 * */
		private function setErrorCode():void
		{
			errDic[0]='注册成功';
			errDic[-10]='有非法字符';
			errDic[-11]='角色超过规定数量';
			errDic[-12]='正在游戏';
			errDic[-13]='其他区还有角色';
			errDic[-14]='角色名检查没通过';
			errDic[-21]='角色名检查服务器没有开启';
			errDic[-31]='数据库连接失败';
			errDic[-32]='插入失败';
			errDic[-33]='角色名检查服务器没有开启';
			errDic[-70]='角色名重复';
		}
		/**
		 * 内网账号登陆
		 * @param $IP
		 * @param $Port
		 * @param $Account
		 * @param $Password
		 * 
		 */		
		public function askForLogin($IP:String,$Port:String,$Account:String,$Password:String=''):void
		{
			super.askForAccountlogin($IP,$Port,$Account,$Password);
		}
		
		
		/**
		 * 重写登录返回 
		 * @param $user 0104包
		 * @param $account 账号
		 * */
		override public function  loginBack($user:UserAuthDecoder,$account:String):void
		{
			
			if(!$user)
			{
				AlertPanel.show('后端未返回数据为NULL');
				return;
			}
			
			if($user.nErrorCode != 0)
			{
				AlertPanel.show('Error：' + $user.nErrorCode.toString()+'账号：'+$account);
				return;
			}
			
			_uiManager.hide(_loginPanel);
			CommonData.szAccount = $account ;
			
			if($user.nErrorCode == 0&&$user.players.length != 0)//账号登陆成功
			{
				var selectPlayerVO :SelectPlayerVO = $user.players[0] ;
				CommonData.dwOnlyID = selectPlayerVO.dwUserOnlyId ;
				CommonData.szPlayerName = selectPlayerVO.szName ;
				preload();
				return;
			}
			
			if($user.nErrorCode == 0&&$user.players.length == 0)
			{
				_creatingRole = _uiManager.show(CreatingRole) as CreatingRole;
				return;
			}
		}
		
		
		/**
		 * 资源
		 * 预加载 
		 */
		private function preload():void
		{
			_UIpreloader = _uiManager.show(TrailerPreload) as IUIView;
			(_UIpreloader as EventDispatcher).addEventListener(Event.COMPLETE , preloaderCompleteHandler) ;
		}
		
		
		/**
		 * 资源预加载完毕 
		 * @param evt
		 */		
		private function preloaderCompleteHandler(evt:Event):void
		{
			(evt.currentTarget as EventDispatcher).removeEventListener(Event.COMPLETE , preloaderCompleteHandler) ;
			var _manager:ManagerOperator = new ManagerOperator() ;
			_manager.startup() ;
			_uiManager.hide(_UIpreloader) ;
			loginGameServer();
		}
		
		
		/**
		 * 创建角色返回
		 * @param $createCharacterVO 012d包
		 * */
		override public function  createCharacterBack($createCharacterVO:RCreateCharacterVO):void
		{
			
			CommonData.dwOnlyID = $createCharacterVO.dwUserOnlyId ; 
			CommonData.szPlayerName = $createCharacterVO.szPlayerName ; 
			if($createCharacterVO.errorcode==0)
			{
				_uiManager.hide(_creatingRole);
				preload();
				return;
			}
			
			if($createCharacterVO.errorcode!=0)
			{
				var err:int=$createCharacterVO.errorcode;
				var str:String=errDic[err];
				AlertPanel.show('Error：' + str);
				return;
			}
		}
		
		
		/**
		 * 登录服务器返回
		 * @param $loginNewly 0106包
		 * */
		override public function  loginGameServerBack($loginNewly:RLoginNewly):void
		{
			if($loginNewly.nErrorCode==0)
			{
				_uiManager.show(ScreenPanel);
				askForInitializationData();
				announcement = _uiManager.show(Announcement) as Announcement;
				return;
			}
			
			if($loginNewly.nErrorCode!=0)
			{
				AlertPanel.show('Error：' + $loginNewly.nErrorCode.toString());
				return;
			}
		}
		
		
		/**
		 *死后端强烈要求延迟1秒发 
		 * （后端理由：角色没有拿到数据）
		 */		
		private function askForInitializationData():void
		{
			_loading = _uiManager.show(LoadingPanel) as LoadingPanel;
			super.askForInitializationDataLater();
		}

		
		/**
		 * 请求进入游戏服务器
		 * 
		 */		
		private function loginGameServer():void
		{
			super.askForLoginGameServer();
		}
		
		
		/**
		 * 账号登陆
		 */		
		public function loginLanded():void
		{
			JSUtil.stage = FlexGlobals.topLevelApplication;
			MaterialManager.getInstance();
			var isPlat:Boolean=JSUtil.isplatform;
			if(!isPlat){
				_loginPanel = _uiManager.show(LoginPanel) as LoginPanel;
				return;
			}
			
			CommonData.platformInfo = JSUtil.getloginfo() ;
			MaterialManager.getInstance().version = "dhh" + CommonData.platformInfo["version"];
			ImageFactory.version = "dhh" + CommonData.platformInfo["version"];
			
			if(isPlat&&CommonData.platformInfo && CommonData.platformInfo['u'])
			{
				askForLogin(CommonData.platformInfo['host'] ,
					CommonData.platformInfo['port'],CommonData.platformInfo['u'] , '') ;
				MaterialManager.getInstance().refresh195();
				return;
			}
			
			if(isPlat&&!(CommonData.platformInfo && CommonData.platformInfo['u']))
			{
				AlertPanel.show('登录参数未符合.') ;
				return;
			}
			
		}
		
		
		/**
		 * 拿到一个随机的姓名
		 * */	
		public function getARandomName():String
		{
			return super.getRandomName();
		}
		
		
		/**
		 * 请求 创建角色 
		 * @param $role 角色名
		 * @param $weapon 1刘备，2孙权，3曹操
		 * 
		 */		
		public function askForCreatARole($role:String, $faceId:int = 1):void
		{
			super.askForCreatRole($role,$faceId);
		}
	}
}