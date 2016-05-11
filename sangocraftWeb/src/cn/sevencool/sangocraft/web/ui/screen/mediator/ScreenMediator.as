package cn.sevencool.sangocraft.web.ui.screen.mediator
{
	import cn.sevencool.sangocraft.data.manager.battleField.mediator.IUIOperatableBattleMediator;
	import cn.sevencool.sangocraft.data.manager.mainPanel.mediator.IUIOperateMainPanel;
	import cn.sevencool.sangocraft.data.manager.screen.mediator.BaseScreenMediator;
	import cn.sevencool.sangocraft.data.manager.screen.mediator.IUIOperatableScreenMadiator;
	import cn.sevencool.sangocraft.data.manager.screen.mediator.IUIOperateBaseInfoMadiator;
	import cn.sevencool.sangocraft.data.manager.utils.MediatorUtil;
	import cn.sevencool.sangocraft.data.model.RBattleDetailedInfo;
	import cn.sevencool.sangocraft.data.model.RCombatReadinessData;
	import cn.sevencool.sangocraft.data.symbols.CommonData;
	import cn.sevencool.sangocraft.data.symbols.ItemsManager;
	import cn.sevencool.sangocraft.data.symbols.SoundManager;
	import cn.sevencool.sangocraft.data.symbols.SystemModelLocator;
	import cn.sevencool.sangocraft.data.symbols.material.MaterialKeys;
	import cn.sevencool.sangocraft.data.symbols.material.MaterialManager;
	import cn.sevencool.sangocraft.data.vo.FightDataVo;
	import cn.sevencool.sangocraft.data.vo.FightScene;
	import cn.sevencool.sangocraft.data.vo.ItemDescription;
	import cn.sevencool.sangocraft.data.vo.SkillInfo;
	import cn.sevencool.sangocraft.web.battle.Game;
	import cn.sevencool.sangocraft.web.battle.ai.FightLogical;
	import cn.sevencool.sangocraft.web.events.BundlerEvent;
	import cn.sevencool.sangocraft.web.manager.BundleResManager;
	import cn.sevencool.sangocraft.web.manager.ResLoaderManager;
	import cn.sevencool.sangocraft.web.manager.UIMananger;
	import cn.sevencool.sangocraft.web.net.WXFLoaderEvent;
	import cn.sevencool.sangocraft.web.net.WXFLoaderQueue;
	import cn.sevencool.sangocraft.web.ui.battleField.mediator.BattleFieldMediator;
	import cn.sevencool.sangocraft.web.ui.loading.view.LoadingProgressBar;
	import cn.sevencool.sangocraft.web.ui.mainPanel.mediator.BasicInforMediator;
	import cn.sevencool.sangocraft.web.ui.mainPanel.mediator.MainPanelMediator;
	import cn.sevencool.sangocraft.web.ui.screen.view.BattleInfo;
	import cn.sevencool.sangocraft.web.ui.screen.view.ScreenPanel;
	
	import com.sevencool.iamsanguo.core.battle.BattleContainer;
	import com.sevencool.iamsanguo.core.battle.Resource;
	import com.sevencool.iamsanguo.core.battle.UnitBar;
	import com.sevencool.iamsanguo.core.battle.UnitCreater;
	import com.sevencool.iamsanguo.core.battle.view.BuildingView;
	import com.sevencool.iamsanguo.core.battle.view.EffectView;
	import com.sevencool.iamsanguo.core.loader.StataicTexureAtlasLoader;
	import com.sevencool.iamsanguo.core.loader.TextureAtlaLoader;
	import com.sevencool.rtslogic.Battlefield;
	import com.sevencool.rtslogic.team.Team;
	import com.sevencool.rtslogic.vo.BattleFrameVO;
	import com.sevencool.rtslogic.vo.BattleInitVO;
	import com.sevencool.rtslogic.vo.BattleTeamVO;
	import com.sevencool.rtslogic.vo.BattleVO;
	import com.sevencool.rtslogic.vo.UnitInitVO;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;
	
	import mx.events.FlexEvent;
	
	import starling.core.Starling;
	import starling.events.EventDispatcher;
	
	/**
	 * project: sangocraft_Web
	 * @class: ScreenMediator
	 * @author: zhouyan
	 * @usage: 游戏登陆UImediator管理器
	 * @since: 2013-8-15
	 * @modified: 2013-8-15
	 * @modifier: zhouyan 
	 */
	public class ScreenMediator extends BaseScreenMediator implements IUIOperatableScreenMadiator
	{
		public function ScreenMediator()
		{
		}
		
		private var unitXML:XML;
		
		/**
		 * 技能图标
		 * */
		public var skillArray:Array = [];
		/**
		 * 主面板
		 * */
		public var screenPanel:ScreenPanel =null ;
		
		public var battleRoot:Game = null ;
		/**
		 * 是否在战场内 
		 */		
		private var _isBattle:Boolean = false ;
		
		/**
		 * 战斗swf容器 
		 */		
		private var _starling:Starling = null;
		private var _mapLoader:Loader = null;
		private var _unitCreater:UnitCreater = new UnitCreater();
		private var _battleInitByte:ByteArray = null;	
		private var _fightDataDic_self:Dictionary = null;
		private var _fightDataDic_emeny:Dictionary = null;
		/**
		 * 战斗描述 情况
		 */		
		private var _battleDetailedInfo:RBattleDetailedInfo = null ;
		
		/**
		 * 指挥点数
		 * */
		private var _myPower:int = 0;
		/**
		 * 敌军指挥点数
		 * */
		private var _aramyPower:int = 0;
		private var _battleVo:BattleVO = null;
		private var _totalArr:Array = [] ;
		private var _arr_self:Array = [];
		private var _arr_enemy:Array = [];
		private var _battleMediator:BattleFieldMediator = null;
		private var _picDic:Dictionary = new Dictionary();
		
		private var _viewPortRect:Rectangle;
		
		private var _buildingLoader:StataicTexureAtlasLoader = null ;
		private var _rolePictureLoader:StataicTexureAtlasLoader = null ;
		private var _effectLoader:StataicTexureAtlasLoader = null ;
		
		/**
		 * 加载队列
		 * */
		private var _fightDataLaoder:WXFLoaderQueue = null;
		
		/**
		 * 本地加载 ByteArray-->swc
		 */		
		private var _fightSwcLoader:Loader = null;
		
		/**
		 * loading加载条
		 * */
		private var _loadingProgress:LoadingProgressBar = null ;
		
		private var _battleInfoXML:String = '';
		
		/**
		 * 资源管理器
		 */		
		private var _materialM:MaterialManager = null;
		
		private var _basic:BasicInforMediator = null;
		
		override public function startup():void
		{
			
			_materialM = MaterialManager.getInstance();
			Resource.resURL = _materialM.getURL(MaterialKeys.NET);
			_fightDataLaoder = new WXFLoaderQueue();
			_fightDataDic_emeny = new Dictionary();
			_fightDataDic_self = new Dictionary();
			screenPanel = UIMananger.getInstance().getUIObj(ScreenPanel) as ScreenPanel ;
			screenPanel.mediatorUI = this ;
			_battleMediator = MediatorUtil.getMediatorByInterface(IUIOperatableBattleMediator) as BattleFieldMediator;
			_fightDataLaoder.addEventListener(WXFLoaderEvent.WXFLOADER_TASK_COMPLETE, onTaskCompleteHandler);
			_fightDataLaoder.addEventListener(WXFLoaderEvent.WXFLOADER_TASKLIST_COMPLETE,onListCompleteHandler);
			_fightDataLaoder.addEventListener(Event.CHANGE,loadProgressHandler);
			screenPanel.addEventListener(FlexEvent.CREATION_COMPLETE , screenPanelCreationCompleteHandler);
			SystemModelLocator.getInstance().addEventListener(Event.RESIZE , screenPanelCreationCompleteHandler);
			SystemModelLocator.getInstance().addRemoteEventListener(RCombatReadinessData,combatReadinessHandler);
		}
		
		
		
		/**
		 * 切换屏幕至内城界面 
		 */		
		public function showCity($isfast:Boolean = false):void
		{
			screenPanel.currentState = 'city';
			SoundManager.getInstance().musicid = 'city';
			if(!$isfast)
			{
				battleSWF_AddedStage(false);
			}
			_isBattle = false ;
			//			screenPanel.home.small_map.isStart = false;//战斗场景
		}
		
		/**
		 * 接到0x0705战斗详细信息数据包返回
		 * 切换屏幕至战斗场景 
		 * @param $battleDetailedInfo 
		 */		
		override public function battleScene($battleDetailedInfo:RBattleDetailedInfo):void
		{
			if($battleDetailedInfo.nErrorCode_tip == 0 && !_isBattle)
			{
				battleInit();
			}
		}
		
		/**
		 * 第一次请求好友数量
		 * */
		public function requestFriendNum():void
		{
			_basic = MediatorUtil.getMediatorByInterface(IUIOperateBaseInfoMadiator) as BasicInforMediator;
			_basic.questFriendNum();
		}
		
		/**
		 * 第一次请求邮件数量
		 * */
		public function questEmailNum():void
		{
			_basic = MediatorUtil.getMediatorByInterface(IUIOperateBaseInfoMadiator) as BasicInforMediator;
			_basic.questEmailNum();
		}
		
		/**
		 * 战场战斗时间
		 * */
		public function getBattleFightTimer():int
		{
			var fight:FightScene = _battleMediator.fightScene;
			var timers:int = fight.nFightTime ;
			return timers ;
		}
		
		/**
		 * 人物等级
		 * */
		public function getRoleLevel():int
		{
			_basic = MediatorUtil.getMediatorByInterface(IUIOperateBaseInfoMadiator) as BasicInforMediator;
			return 	_basic.roleLvl ;
		}
		
		//*************************************************************************
		//protected handlers
		//*************************************************************************
		
		/**
		 * 0x070b返回 
		 * @param event
		 */		
		protected function combatReadinessHandler(event:Event):void
		{
			var rCombatReadinessData:RCombatReadinessData = SystemModelLocator.getInstance().getPropertyByVo(RCombatReadinessData) as RCombatReadinessData;
			_battleInitByte = rCombatReadinessData.dataList;
			_battleInitByte.position = 0;
			battleInit();
		}
		
		
		/**
		 * fight.swc加载完成 
		 * @param event
		 * 
		 */		
		protected function loaderFightSwcCompleteHandler(event:Event):void
		{				
			_viewPortRect = new Rectangle(0, 0, CommonData.stage.stageWidth, CommonData.stage.stageHeight);
			Starling.handleLostContext = true; 
			_starling = new Starling(Game,CommonData.stage,_viewPortRect);
			_starling.antiAliasing =1;
			_starling.showStats=true;
			_starling.showStatsAt("right","top");
			_starling.simulateMultitouch = true;
			_starling.enableErrorChecking = false; //将错误检测关闭
			_starling.start();
			CommonData.stage.addEventListener(Event.RESIZE, onResize);
			_starling.addEventListener("rootCreated",starlingRootCreatedHandler);
		}
		
		/**
		 * 加载队列加载完成 
		 * @param $evt
		 */		
		protected function onListCompleteHandler($evt:WXFLoaderEvent):void
		{
			_loadingProgress.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		
		/**
		 * 单个对象加载完成 
		 * @param $evt
		 * 
		 */		
		protected function onTaskCompleteHandler($evt:WXFLoaderEvent):void
		{
			var bytes:ByteArray = $evt.loadData;
			switch($evt.taskid)
			{
				case 'fightSwc':
				{
					doLoadFightSwfBytes(bytes);
					break;
				}
				case 'dhh_mydb_BaseMonster_tbl':
				case 'dhh_mydb_skill_tbl':
				case 'dhh_mydb_skillbuff_tbl':
				case 'mydb_Fight_Scene_Info_tbl':
				case 'mydb_mapinfo_tbl':
				case 'mydb_restrain_tbl':
				{
					FightLogical.ReadLoadData($evt.taskid,bytes);
					break;
				}
				case 'rolepicture':
				{
					_rolePictureLoader = new StataicTexureAtlasLoader();
					_rolePictureLoader.decodeData(bytes);
					_rolePictureLoader.addEventListener(Event.CHANGE ,rolePictureLoaderComplete);
					break;
				}
				case 'building':
				{
					_buildingLoader = new StataicTexureAtlasLoader();
					_buildingLoader.decodeData(bytes);
					_buildingLoader.addEventListener(Event.CHANGE ,buildingLoaderCompleteHandler);
					break;
				}
				case 'effect':
				{
					_effectLoader = new StataicTexureAtlasLoader();
					_effectLoader.decodeData(bytes);
					_effectLoader.addEventListener(Event.CHANGE ,effectLoaderCompleteHandler);
					break;
				}
				case 'map':
				{
					_mapLoader = new Loader();
					_mapLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,mapLoaderCompleteHandler);
					_mapLoader.loadBytes(bytes);
					break;
				}
				default:
				{
					throw new Error('onTaskComplete' + $evt.taskid);
					break;
				}
			}
		}
		
		
		/**
		 * 加载进度刷新 
		 * @param e
		 */		
		protected function loadProgressHandler(e:Event):void
		{
			_loadingProgress.refreshProgress('',_fightDataLaoder.percent,100,_fightDataLaoder.completeTask,_fightDataLaoder.totalTask);
		}
		
		
		/**
		 * starling准备完毕
		 * @param e
		 */		
		protected function starlingRootCreatedHandler(e:*):void
		{
			//			if(!EffectView.textures || !UnitBar.textureAtlas)
			//			{
			battleRoot = _starling.root as Game;
			loaderFighterMaterial(true);
			//			}
		}
		
		/**
		 * 战斗建筑资源加载完成 
		 * @param $evt
		 */		
		protected function buildingLoaderCompleteHandler($evt:Event):void
		{
			BuildingView.textures = _buildingLoader.result ;
		}
		
		/**
		 * 战斗特效资源加载完成 
		 * @param $evt
		 * 
		 */		
		protected function effectLoaderCompleteHandler($evt:Event):void
		{
			EffectView.textures = _effectLoader.result ;
		}
		
		/**
		 * 战斗人物头像资源加载完成 
		 * @param $evt
		 */		
		protected function rolePictureLoaderComplete($evt:Event):void
		{
			UnitBar.textureAtlas = _rolePictureLoader.result ;
		}
		
		
		/**
		 * 战斗地图资源加载完成 
		 * @param event
		 */		
		protected function mapLoaderCompleteHandler(event:Event):void
		{
			_battleMediator.baseMapvo.map = (_mapLoader.content as Bitmap).bitmapData;
			//为战场添加地图
			Battlefield.getActivityBattlefield().map = _battleMediator.baseMapvo;
			Battlefield.getActivityBattlefield().map.fill();
			
			FightLogical.ReadLoadFightMapData(_battleMediator.fightMapID,_battleMediator.baseMapByteArray);
			
			var battleStr:String = FightLogical.FightDataPrepare(_battleInitByte,true);
			
			unitXML = XML(battleStr);
			
			//初始化部队，并创建第一帧
			
			_battleInit.fill(unitXML);
			
			/**
			 * 初始化战斗队伍信息
			 * */
			initBattleData(_battleInit);
		}	
		
		//*************************************************************************************
		// private handlers
		//*************************************************************************************
		
		/**
		 * 切换至战场 
		 */		
		private function battleInit():void
		{
			battleSWF_AddedStage(true);
			_isBattle = true ;
		}
		
		
		/**
		 *加载队列 加载dummy.swf 
		 * 
		 */		
		private function init():void
		{
			_loadingProgress = UIMananger.getInstance().show(LoadingProgressBar) as LoadingProgressBar;
			_fightDataLaoder.setMaxThread(1);
			_fightDataLaoder.addTask('fightSwc',_materialM.versionCheckURL(MaterialKeys.COMBAT_DATA));
			_fightDataLaoder.start();
		}
		
		/**
		 * 加载战斗数据资源 
		 * @param $isFirstLoad 是否是第一次加载
		 */		
		private function loaderFighterMaterial($isFirstLoad:Boolean):void
		{
			_loadingProgress = UIMananger.getInstance().show(LoadingProgressBar) as LoadingProgressBar;
			_battleMediator = MediatorUtil.getMediatorByInterface(BattleFieldMediator) ;
			var urls:Array = _battleMediator.baseMapvo.backImgURL.split("/");
			_fightDataLaoder.setMaxThread(4);
			if($isFirstLoad)
			{
				_fightDataLaoder.addTask('dhh_mydb_BaseMonster_tbl',_materialM.versionCheckURL(MaterialKeys.COMBAT_DATA_SVRFILE,'dhh_mydb_BaseMonster_tbl'));
				_fightDataLaoder.addTask('dhh_mydb_skill_tbl',_materialM.versionCheckURL(MaterialKeys.COMBAT_DATA_SVRFILE,'dhh_mydb_skill_tbl'));
				_fightDataLaoder.addTask('dhh_mydb_skillbuff_tbl',_materialM.versionCheckURL(MaterialKeys.COMBAT_DATA_SVRFILE,'dhh_mydb_skillbuff_tbl'));
				_fightDataLaoder.addTask('mydb_Fight_Scene_Info_tbl',_materialM.versionCheckURL(MaterialKeys.COMBAT_DATA_SVRFILE,'mydb_Fight_Scene_Info_tbl'));
				_fightDataLaoder.addTask('mydb_mapinfo_tbl',_materialM.versionCheckURL(MaterialKeys.COMBAT_DATA_SVRFILE,'mydb_mapinfo_tbl'));
				_fightDataLaoder.addTask('mydb_restrain_tbl',_materialM.versionCheckURL(MaterialKeys.COMBAT_DATA_SVRFILE,'mydb_restrain_tbl'));
				_fightDataLaoder.addTask('rolepicture',_materialM.versionCheckURL(MaterialKeys.ROLEPICTURE_25));
				_fightDataLaoder.addTask('building',_materialM.versionCheckURL(MaterialKeys.BUILDING));
				_fightDataLaoder.addTask('effect',_materialM.versionCheckURL(MaterialKeys.EFFECT_1000));
			}
			_fightDataLaoder.addTask('map',_materialM.versionCheckURL(MaterialKeys.MAP,urls[urls.length - 1]));
			_fightDataLaoder.start();
		}
		
		/**
		 * 加载已经加载好的dummy.swf的 ByteArray
		 * @param bytes
		 * 
		 */		
		private function doLoadFightSwfBytes(bytes:ByteArray):void
		{
			_fightSwcLoader = new Loader();
			var context:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
			_fightSwcLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,loaderFightSwcCompleteHandler);
			_fightSwcLoader.loadBytes(bytes, context);
		}
		
		
		/**
		 * 战斗swf添加到舞台 
		 * @param $Off_NO 是否打开
		 * 
		 */		
		private function battleSWF_AddedStage($Off_NO:Boolean = true):void
		{
			if($Off_NO)
			{
				if(!_starling)
				{
					init();
				}else{
					loaderFighterMaterial(false);
					_starling.start();
				}
			}else
			{
				Battlefield.getActivityBattlefield().stop();
				_starling.stop();
			}
		}
		
		private function onResize(e:Event):void
		{
			_viewPortRect.width = CommonData.stage.stageWidth;
			_viewPortRect.height = CommonData.stage.stageHeight;
			_starling.stage.stageWidth = CommonData.stage.stageWidth;
			_starling.stage.stageHeight = CommonData.stage.stageHeight;
		}
		
		/**
		 * 设置帧频  一半速度 
		 * 
		 */		
		private function setFrameHalfSpeed():void
		{
			Battlefield.getActivityBattlefield().frameSpeed = 0.5;
		}
		
		/**
		 * 设置帧频  双倍速度 
		 * 
		 */		
		private function setFrameDoubleSpeed():void
		{
			Battlefield.getActivityBattlefield().frameSpeed = 2;
		}
		
		
		/**
		 * 调用C++ai 包 
		 * 
		 */		
		private function play():void
		{
			var battleStr:String = FightLogical.FightDataPrepare(_battleInitByte);
			var xml:XML = XML(battleStr);	
			var battleInfo:BattleInfo = UIMananger.getInstance().getUIObj(BattleInfo) as BattleInfo;
			_battleInfoXML = battleStr + _battleInfoXML;
			if(battleInfo.stage)
			{
				battleInfo.addInfo(_battleInfoXML);
			}
			trace(battleStr);
			if(int(xml.@frameIndex) != 0)
			{
				Battlefield.getActivityBattlefield().addXMLFrame(xml);
			}else
			{
				Battlefield.getActivityBattlefield().pause();
				Battlefield.getActivityBattlefield().dispatchEvent(new Event(Event.COMPLETE));
			}
		}		
		
		/**
		 * 战斗帧序列
		 * */
		private function battleFieldChange(e:Event):void
		{
			_battleVo = Battlefield.getActivityBattlefield().process;
			var round:int = Battlefield.getActivityBattlefield().round -1;
			var battleTeamVO:BattleFrameVO = _battleVo.battleFrames[round]; 
			if(!battleTeamVO)
			{
				return ;
			}
			var fight:FightDataVo = null;
			
			for each(var team:BattleTeamVO in battleTeamVO.battleTeams)
			{
				if(_fightDataDic_self[team.teamID])
				{
					fight = _fightDataDic_self[team.teamID]
					fight.power = battleTeamVO.commandPoint;
					fight.nFps = round + 2;
					
				}else if(_fightDataDic_emeny[team.teamID])
				{
					fight = _fightDataDic_emeny[team.teamID]	
					fight.power = battleTeamVO.enemyCommandPoint;
				}
				fight.nNowHp = team.total;
			}
			refreshBattleFieldInfo();
		}
		
		
		/**
		 * 主面板创建完成 
		 * @param $evt
		 * 
		 */		
		private function screenPanelCreationCompleteHandler($evt:Event):void
		{
			screenPanel.width = UIMananger.getInstance().container.width ;
			screenPanel.height = UIMananger.getInstance().container.height ;
		}
		
		
		
		/**
		 * 当前战斗回合数据
		 * @param $array:Array 武将信息
		 * @param $myPower:指挥点数
		 * @param $aramyPower:敌军指挥点数
		 * */
		private function fightDataInfo($array:Array,$myPower:int,$aramyPower:int):void
		{
			var mainPanel:MainPanelMediator = MediatorUtil.getMediatorByInterface(IUIOperateMainPanel) as MainPanelMediator;
			mainPanel.fightDataInfo($array,$myPower,$aramyPower);
		}
		
		
		/**
		 * 初始化战斗数据
		 * */
		private function initBattleData($battleInit:BattleInitVO):void
		{
			skillArray = [];
			if(!$battleInit.units)
			{
				return ;
			}
			for each(var gsFightDataInitVO:UnitInitVO in $battleInit.units)
			{
				switch(gsFightDataInitVO.playerID)//阵营id
				{
					case 1:
						
						if(!_fightDataDic_self[gsFightDataInitVO.id])
						{
							var fightData_self:FightDataVo = new FightDataVo();
							fightData_self.nArmsType = gsFightDataInitVO.type;
							fightData_self.nBaseID = gsFightDataInitVO.leader;
							fightData_self.nFactionID = gsFightDataInitVO.playerID;
							fightData_self.nNumberID = gsFightDataInitVO.id;
							fightData_self.nSkillID = gsFightDataInitVO.skillID;
							fightData_self.nSkillLvl = gsFightDataInitVO.skillLvl;
							fightData_self.power = _aramyPower;
							_fightDataDic_self[gsFightDataInitVO.id] = fightData_self ; 
						}
						break;
					case 2:
						if(!_fightDataDic_emeny[gsFightDataInitVO.id])
						{
							var fightData_emeny:FightDataVo = new FightDataVo();
							fightData_emeny.nArmsType = gsFightDataInitVO.type;
							fightData_emeny.nBaseID = gsFightDataInitVO.leader;
							fightData_emeny.nFactionID = gsFightDataInitVO.playerID;
							fightData_emeny.nNumberID = gsFightDataInitVO.id;
							fightData_emeny.nSkillID = gsFightDataInitVO.skillID;
							fightData_emeny.nSkillLvl = gsFightDataInitVO.skillLvl;
							fightData_emeny.power = _aramyPower;
							_fightDataDic_emeny[gsFightDataInitVO.id] = fightData_emeny;
						}
						
						
						break;
					default: 
						throw new Error("gsFightDataInitVO.nFactionID"+gsFightDataInitVO.id)
				}
			}
			resourceLoad();
		}
		
		private function preloadBattleUIResources($str:String,$isComplete:Boolean = false):void
		{
			if(!_picDic[$str])
			{
				_picDic[$str] = $str;
				skillArray.push($str);
			}
			if(!$isComplete)
			{
				return ;
			}
			if(skillArray.length == 0 )
			{
				fightUIMaterialLoadCompelteHandler();
				return ;
			}
			var bund:BundlerEvent = new BundlerEvent(BundlerEvent.MISS,skillArray);
			BundleResManager.DEFAULT_DOWNLOADER_EVENTDISPATCHER.dispatchEvent(bund);
			ResLoaderManager.getInstance().addEventListener(Event.COMPLETE,fightUIMaterialLoadCompelteHandler);
		}
		
		/**
		 * 战场数据加载结束
		 * */
		private function fightUIMaterialLoadCompelteHandler(e:Event=null):void
		{
			
			fightBeginData(_battleInit);
			refreshBattleFieldInfo();
			screenPanel.currentState = 'battleScenes';
			SoundManager.getInstance().musicid = 'battlefield';
			//			Battlefield.getActivityBattlefield().play();
			if(ResLoaderManager.getInstance().hasEventListener(Event.COMPLETE))
			{
				ResLoaderManager.getInstance().removeEventListener(Event.COMPLETE,fightUIMaterialLoadCompelteHandler);
			}
		}
		/**
		 * 战斗显示资源下载
		 * */
		private function resourceLoad():void
		{
			//初始化部队，并创建第一帧
			var battleInit:BattleInitVO = new BattleInitVO();
			battleInit.fill(unitXML);
			for each(var gsFightDataInitVOs:UnitInitVO in battleInit.units)
			{
				var skill:SkillInfo = ItemsManager.getInstance().skillDic[gsFightDataInitVOs.skillID];
				var itemsDes:ItemDescription = ItemsManager.getInstance().ItemInfo[gsFightDataInitVOs.leader]
				if(itemsDes)
				{
					preloadBattleUIResources(_materialM.getURL(MaterialKeys.GENERALS_BODY,itemsDes.nBodyId.toString()));		
				}
				if(!skill)
				{
					continue;
				}
				if(!gsFightDataInitVOs.skillID)
				{
					preloadBattleUIResources(_materialM.getURL(MaterialKeys.SKILLNAME,gsFightDataInitVOs.skillID.toString()));
					preloadBattleUIResources(_materialM.getURL(MaterialKeys.SKILLNAMEICON,gsFightDataInitVOs.skillID.toString()));
					preloadBattleUIResources(_materialM.getURL(MaterialKeys.SKILLNAMEICON,"s"+gsFightDataInitVOs.skillID.toString()));
					preloadBattleUIResources(_materialM.getURL(MaterialKeys.SKILLNAME,gsFightDataInitVOs.skillID.toString()));
				}
				
				preloadBattleUIResources(_materialM.getURL(MaterialKeys.SMALLER_HEAD,"1_"+itemsDes.nHeadId.toString()));
				preloadBattleUIResources(_materialM.getURL(MaterialKeys.SMALL_HEAD,itemsDes.nHeadId.toString()));
			}
			for(var i:int =1 ;i< 7; i++ )
			{
				preloadBattleUIResources(_materialM.getURL(MaterialKeys.SKILL_LEVEL,i.toString()));
			}
			preloadBattleUIResources(_materialM.getURL(MaterialKeys.OTHER,"leadPointBarPower"));
			preloadBattleUIResources(_materialM.getURL(MaterialKeys.OTHER,"combatArayBar"));
			preloadBattleUIResources(_materialM.getURL(MaterialKeys.OTHER,"power"));
			preloadBattleUIResources(_materialM.getURL(MaterialKeys.OTHER,"combatBar"));
			preloadBattleUIResources(_materialM.getURL(MaterialKeys.OTHER,"generalPos"));
			preloadBattleUIResources(_materialM.getURL(MaterialKeys.OTHER,"armBar"));
			preloadBattleUIResources(_materialM.getURL(MaterialKeys.OTHER,"emptyPos"));
			preloadBattleUIResources(_materialM.getURL(MaterialKeys.OTHER,"emptyGena"));
			preloadBattleUIResources(_materialM.getURL(MaterialKeys.OTHER,"generalBackBar"));
			preloadBattleUIResources(_materialM.getURL(MaterialKeys.OTHER,'success'));
			preloadBattleUIResources(_materialM.getURL(MaterialKeys.OTHER,'failure'));
			preloadBattleUIResources(_materialM.getURL(MaterialKeys.OTHER,"tipTitle"));
			preloadBattleUIResources(_materialM.getURL(MaterialKeys.OTHER,"qxgj"));
			preloadBattleUIResources(_materialM.getURL(MaterialKeys.OTHER,"kuijiWar"));
			preloadBattleUIResources(_materialM.getURL(MaterialKeys.OTHER,"endWarBar"));
			preloadBattleUIResources(_materialM.getURL(MaterialKeys.OTHER,"battleGet"));
			preloadBattleUIResources(_materialM.getURL(MaterialKeys.OTHER,"warEndGet"));
			preloadBattleUIResources(_materialM.getURL(MaterialKeys.OTHER,"conUpLvl"));
			preloadBattleUIResources(_materialM.getURL(MaterialKeys.OTHER,"bottomShort"));	
			preloadBattleUIResources(_materialM.getURL(MaterialKeys.OTHER,"battleRestraint"));	
			preloadBattleUIResources(_materialM.getURL(MaterialKeys.OTHER,"timerBar"));	
			preloadBattleUIResources(_materialM.getURL(MaterialKeys.SKILLEFFECTSMALLPNG,'redNameBottom'))	
			preloadBattleUIResources(_materialM.getURL(MaterialKeys.SKILLEFFECTSMALLPNG,"blueNameBottom"));	
			preloadBattleUIResources(_materialM.getURL(MaterialKeys.SKILLEFFECTSMALL,"1"));	
			preloadBattleUIResources(_materialM.getURL(MaterialKeys.SKILLEFFECTSMALL,"2"));	
			preloadBattleUIResources(_materialM.getURL(MaterialKeys.SKILLEFFECTSMALL,"3"));	
			preloadBattleUIResources(_materialM.getURL(MaterialKeys.SKILLEFFECTSMALL,"4"));	
			preloadBattleUIResources(_materialM.getURL(MaterialKeys.SKILLEFFECTSMALL,"5"));	
			preloadBattleUIResources(_materialM.getURL(MaterialKeys.SKILLEFFECTSMALL,"6"));	
			preloadBattleUIResources(_materialM.getURL(MaterialKeys.LOAD_MAP,"red"));	
			preloadBattleUIResources(_materialM.getURL(MaterialKeys.LOAD_MAP,"redBase"));	
			preloadBattleUIResources(_materialM.getURL(MaterialKeys.LOAD_MAP,"redFlag"));	
			preloadBattleUIResources(_materialM.getURL(MaterialKeys.LOAD_MAP,"red2"));	
			preloadBattleUIResources(_materialM.getURL(MaterialKeys.LOAD_MAP,"redBase2"));	
			preloadBattleUIResources(_materialM.getURL(MaterialKeys.LOAD_MAP,"redFlag2"));	
			preloadBattleUIResources(_materialM.getURL(MaterialKeys.LOAD_MAP,"blue"));	
			preloadBattleUIResources(_materialM.getURL(MaterialKeys.LOAD_MAP,"blueBase"));	
			preloadBattleUIResources(_materialM.getURL(MaterialKeys.LOAD_MAP,"blueFlag"));	
			preloadBattleUIResources(_materialM.getURL(MaterialKeys.LOAD_MAP,"blue2"));	
			preloadBattleUIResources(_materialM.getURL(MaterialKeys.LOAD_MAP,"blueBase2"));	
			preloadBattleUIResources(_materialM.getURL(MaterialKeys.LOAD_MAP,"blueFlag2"));	
			preloadBattleUIResources(_materialM.getURL(MaterialKeys.SKILL_SWF,"skillPinkLine"));	
			preloadBattleUIResources(_materialM.getURL(MaterialKeys.SKILL_SWF,"skillLightBlueLine"));	
			preloadBattleUIResources(_materialM.getURL(MaterialKeys.SKILL_SWF,"skillYellowLine"));	
			preloadBattleUIResources(_materialM.getURL(MaterialKeys.SKILL_SWF,"skillGoldenLine"));	
			preloadBattleUIResources(_materialM.getURL(MaterialKeys.SKILL_SWF,"skillLightPurpleLine"),true);	
		}
		
		
		/**
		 *刷新战斗数据 
		 */		
		private function refreshBattleFieldInfo():void
		{
			var aramyStay:int = 0;
			var myStay:int =0;
			_arr_enemy = [];
			_arr_self = [];
			_totalArr = [];
			for each(var fight_self:FightDataVo in _fightDataDic_self) 
			{
				if(fight_self.nBaseID==0)
				{
					continue;
				}
				if(fight_self.nBaseID == 999 )
				{
					myStay = fight_self.nNowHp;
				}else
				{
					_arr_self.push(fight_self);
				}
				_myPower = fight_self.power;
			}
			for each(var fight_enemy:FightDataVo in _fightDataDic_emeny) 
			{
				if(fight_enemy.nBaseID==0)
				{
					continue;
				}	
				if(fight_enemy.nBaseID==999||fight_enemy.nBaseID == 888||fight_enemy.nBaseID == 777)
				{
					if(fight_enemy.nBaseID == 999)
					{
						aramyStay += fight_enemy.nNowHp;
					}
				}else
				{
					_arr_enemy.push(fight_enemy);
				}
				_aramyPower = fight_enemy.power;
			}
			_totalArr.push(_arr_self,_arr_enemy,aramyStay,myStay);
			fightDataInfo(_totalArr,_myPower,_aramyPower);
			
		}
		
		
		
		/**
		 * 帧数据 
		 */		
		private var _battleInit:BattleInitVO = new BattleInitVO();
		
		/**
		 * 战斗开始
		 * @param $battleInit 战斗数据
		 * 
		 */		
		private function fightBeginData($battleInit:BattleInitVO):void
		{
			//主将设定
			Battlefield.getActivityBattlefield().chiefs[1] = 0;
			Battlefield.getActivityBattlefield().chiefs[2] = 0;
			
			var viewTeam:Team;
			
			for(var i:int=0;i<$battleInit.units.length;i++)
			{
				var camp:int = Battlefield.getActivityBattlefield().getCamp($battleInit.units[i].playerID);
				var team:Team = _unitCreater.creatUnit($battleInit.units[i].type,camp);
				team.playerID = $battleInit.units[i].playerID;
				team.leaderID = $battleInit.units[i].leader;
				team.id = $battleInit.units[i].id;
				Battlefield.getActivityBattlefield().addTeam(team);
				
				//第一位武将设为主将
				if(Battlefield.getActivityBattlefield().chiefs[camp] == 0)
				{
					Battlefield.getActivityBattlefield().chiefs[camp] = $battleInit.units[i].leader;
					if(camp == 1)
					{
						viewTeam = team;
					}
				}
				
				//创建 添加 血条
				
				var isBuilding:Boolean = false;
				if(team.type >= 20 )
				{
					isBuilding = true;
				}
				var unitBar:UnitBar = new UnitBar(team.id,team.campID,team.leaderID,team.iconID,isBuilding);
				
				Battlefield.getActivityBattlefield().battleContainer.addViewAt(unitBar,2);
			}
			
			UnitBar.startSort(Battlefield.getActivityBattlefield().battleContainer as EventDispatcher);
			
			Battlefield.getActivityBattlefield().processXML = unitXML;
			Battlefield.getActivityBattlefield().start();
			
			battleRoot.moveViewPort(viewTeam.currentPosition.x,viewTeam.currentPosition.y);
			
			setTimeout(play,Battlefield.getActivityBattlefield().roundTime * 2 / 3);
			
			Battlefield.getActivityBattlefield().addEventListener(Event.CHANGE,battleFieldChange);
			Battlefield.getActivityBattlefield().addEventListener(Event.CLEAR,needDataHandler);
		}
		
		private function needDataHandler(event:Event):void
		{
			play();
		}
	}
}