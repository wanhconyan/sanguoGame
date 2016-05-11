package cn.sevencool.sangocraft.web.ui.battleField.mediator
{
	import cn.sevencool.sangocraft.data.events.BeginnersGuideEvent;
	import cn.sevencool.sangocraft.data.manager.battleField.mediator.BasebattleFieldMediator;
	import cn.sevencool.sangocraft.data.manager.battleField.mediator.IUIOperatableBattleMediator;
	import cn.sevencool.sangocraft.data.manager.formation.mediator.IUIOperatableFormationMediator;
	import cn.sevencool.sangocraft.data.manager.socalRelative.mediator.IUIOperatableMilitarySocalMediator;
	import cn.sevencool.sangocraft.data.manager.utils.MediatorUtil;
	import cn.sevencool.sangocraft.data.model.DataByteVO;
	import cn.sevencool.sangocraft.data.model.SRBattleEndInfoVO;
	import cn.sevencool.sangocraft.data.symbols.ItemsManager;
	import cn.sevencool.sangocraft.data.vo.ChapterParam;
	import cn.sevencool.sangocraft.data.vo.FightScene;
	import cn.sevencool.sangocraft.data.vo.FormationArrVO;
	import cn.sevencool.sangocraft.data.vo.MonsterInfo;
	import cn.sevencool.sangocraft.web.manager.UIMananger;
	import cn.sevencool.sangocraft.web.symbols.PagingArray;
	import cn.sevencool.sangocraft.web.ui.battleField.view.BattleEndPanel;
	import cn.sevencool.sangocraft.web.ui.battleField.view.EndPanel;
	import cn.sevencool.sangocraft.web.ui.battleField.view.ExpeditionInfoPanel;
	import cn.sevencool.sangocraft.web.ui.battleField.view.ExpeditionPanel;
	import cn.sevencool.sangocraft.web.ui.battleField.view.PreBattlePanel;
	import cn.sevencool.sangocraft.web.ui.beginnersGuide.mediator.BeginnersGuideMediator;
	import cn.sevencool.sangocraft.web.ui.formation.mediator.FormationMediator;
	import cn.sevencool.sangocraft.web.ui.militaryOffice.view.BarracksSpace;
	import cn.sevencool.sangocraft.web.ui.reinforce.view.ReinforcePanel;
	import cn.sevencool.sangocraft.web.ui.screen.view.ScreenPanel;
	import cn.sevencool.sangocraft.web.ui.socialRelative.mediator.SocialRelativeMediator;
	
	import com.sevencool.iamsanguo.core.decode.AnaysisByte;
	import com.sevencool.iamsanguo.core.vo.map.BaseMapVO;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	/**
	 * project: sangocraft_Web
	 * @class: BattleFieldMediator
	 * @author: wangcongyan
	 * @usage: 战斗UImediator管理器
	 * @since: 2013-8-27
	 * @modified: 2013-8-27
	 * @modifier: wangcongyan  
	 */
	public class BattleFieldMediator extends BasebattleFieldMediator implements IUIOperatableBattleMediator
	{
		public function BattleFieldMediator()
		{
			super();
		}
		
		private var  _preBattlePanel:PreBattlePanel = null ;
		private var  _expeditionPanel:ExpeditionPanel = null ;
		private var  _expeditionInfoPanel:ExpeditionInfoPanel = null ;
		
		/**
		 * 编队数组
		 * */
		private var formationArr:Array = [];
		
		/**章节数据保存*/
		private var arrpagition:PagingArray = null;
		
		/**
		 * 当前页数显示
		 * */
		private var nowPage:int = 1;
		
		/**
		 * 地图信息
		 * */
		private var mapVO:BaseMapVO = null;
		
		/**
		 * 章节描述dic
		 * */
		private var chapterDic:Dictionary = null;
		
		/**
		 * 进攻路线
		 * */
		private var attackRoadArr:Array = [];
		
		/**
		 * 选择编队号
		 * */
		private var formationID:int = -1; 
		
		private var  _battleEndPanel:BattleEndPanel = null ;
		
		/**
		 * 章节id
		 * */
		public var battleID:int = -1;
		/**
		 * 路线数组
		 * */
		private var lineDic:Dictionary = new Dictionary();
		
		/**
		 * 使用其他mediator的方法
		 * */
		private var formationUI:FormationMediator;
		
		private var _fightScene:FightScene = null;
		
		private var _uiManager:UIMananger = null;
		
		/**
		 * 进攻地图id
		 * */
		public var fightMapID:int = 0;
		
		/**
		 * 地图二进制
		 * */
		public var baseMapByteArray:ByteArray = null;
		
		/**
		 * 地图vo
		 * */
		public var baseMapvo:BaseMapVO = null;
		
		/**
		 * 记录当前章节是否通关
		 * */
		public var isPass:Boolean = false;
		
		/**
		 * 战斗结束/切换到内城
		 * */
		public var isBattleEnd:Boolean = false;
		override public function startup():void
		{
			_uiManager = UIMananger.getInstance();
			_preBattlePanel = _uiManager.getUIObj(PreBattlePanel) as PreBattlePanel;
			_expeditionPanel = _uiManager.getUIObj(ExpeditionPanel) as ExpeditionPanel;
			_expeditionInfoPanel = _uiManager.getUIObj(ExpeditionInfoPanel) as ExpeditionInfoPanel;
			_battleEndPanel = _uiManager.getUIObj(BattleEndPanel) as BattleEndPanel;
			
			
			_preBattlePanel.mediatorUI = this ;
			_expeditionPanel.mediatorUI = this;
			_expeditionInfoPanel.mediatorUI = this ;
			_battleEndPanel.mediatorUI = this ;
		}
		
		/**
		 * 点击战斗章节选择 面板 
		 * @param $type
		 */		
		public function fightingChapterListInfo($type:int):void
		{
			super.fightingChapterList($type);
			var beginnersGuideMediator:BeginnersGuideMediator = MediatorUtil.getMediatorByInterface(BeginnersGuideMediator);
			beginnersGuideMediator.BEGINNERSGUIDEEVENTDISPATCHER.dispatchEvent(new BeginnersGuideEvent(BeginnersGuideEvent.NEXTGUIDE));
		}
		
		/**
		 * 战场列表请求
		 * @param $chapterID 章节信息
		 * @param $type:
		 * $param pass ：int完成度
		 */		
		public function chapterLevelInfo($chapterID:int,$type:int = 0,$isPass:Boolean = false):void
		{
			/**
			 * 判断背包中物品格子数量是否大于物品数量 如果不则弹出面板
			 * */
			if(ItemsManager.getInstance().getItems().length > ItemsManager.getInstance().packageCount)
			{
				var barr:BarracksSpace = _uiManager.getUIObj(BarracksSpace) as BarracksSpace;
				_uiManager.showOrHide(BarracksSpace);
				barr.isBattle = true;
				return ;
			}else if(!$type)
			{
				_uiManager.showOrHide(ExpeditionInfoPanel);
			}
			
			super.levelInfo($chapterID);
			isPass = $isPass;
		}
		
		
		/**
		 *点击按钮 ‘进军’ 
		 * 
		 */
		public function btnClickFighting($nFightSceneId:int,$btSelectId:int,$btFightLine:Array):void
		{
			if(!isSetRoad)
			{
				if(!lineDic[formationID])
				{
					var arr:Array = new Array();
					for(var i:int = 0;i< 6 ; i++)
					{
						var dataByte:DataByteVO = new DataByteVO();
						dataByte.btByte = 1;
						arr.push(dataByte);
					}
					lineDic[formationID] = arr;
				}
				attackRoadArr = lineDic[formationID];
			}
			
			if($btFightLine.length != 0)
			{
				attackRoadArr = $btFightLine;
			}
			_uiManager.hide(_preBattlePanel);
			
			super.askforAdvance($nFightSceneId,formationID,attackRoadArr);
			
			//发送小地图地址
			var screenPanel:ScreenPanel = _uiManager.getUIObj(ScreenPanel) as ScreenPanel;
			screenPanel.home.small_map.url = $nFightSceneId.toString();
			screenPanel.home.isEnd = false; //战斗场景
			
			var beginnersGuideMediator:BeginnersGuideMediator = MediatorUtil.getMediatorByInterface(BeginnersGuideMediator);
			beginnersGuideMediator.BEGINNERSGUIDEEVENTDISPATCHER.dispatchEvent(new BeginnersGuideEvent(BeginnersGuideEvent.NEXTGUIDE));
		}
		
		
		/**
		 * 显示战前配置面板 
		 * @param $fight:FightScene
		 * @param $index:int
		 */		
		public function showPrewarConfiguration($fight:FightScene):void 
		{
			var rein:ReinforcePanel = _uiManager.getUIObj(ReinforcePanel) as ReinforcePanel;
			rein.isSend = true;
			_uiManager.showOrHide(ReinforcePanel);
			var beginnersGuideMediator:BeginnersGuideMediator = MediatorUtil.getMediatorByInterface(BeginnersGuideMediator);
			beginnersGuideMediator.BEGINNERSGUIDEEVENTDISPATCHER.dispatchEvent(new BeginnersGuideEvent(BeginnersGuideEvent.NEXTGUIDE));
			fightScene = $fight
		}
		
		
		/**
		 * 援军面板打开战前配置面板
		 * */
		public  function showPrewarConfigurationOnClose($monster:MonsterInfo):void 
		{
			super.askMapInfo(fightScene.nFightMapID);
			fightMapID = fightScene.nFightMapID
			
			if(!chapterDic)
			{
				chapterDic = new Dictionary();
				chapterDic = super.askFightDes();
			}
			_preBattlePanel.baseMap = mapVO;
			
			battleID  = fightScene.nFightID
			
			_preBattlePanel.fightScene = chapterDic[fightScene.nChapterID] as ChapterParam;
			_preBattlePanel.nowFightName = fightScene.szFightName ;
			if($monster)
			{
				_preBattlePanel.refineMonster = $monster;
			}
			_uiManager.showOrHide(PreBattlePanel);
		}
		
		
		/**
		 * 章节介绍信息
		 * */
		
		override protected function refreshChapterInfoArr($chapterInfoArr:Array):void
		{
			arrpagition = new PagingArray($chapterInfoArr,8);
			refreshData();
		}
		
		/**
		 * 发送编队信息
		 * */
		public function sendFormation():void
		{
			formationUI  = MediatorUtil.getMediatorByInterface(IUIOperatableFormationMediator) as FormationMediator;
			//			formationUI.formationInfoSend();
			var beginnersGuideMediator:BeginnersGuideMediator = MediatorUtil.getMediatorByInterface(BeginnersGuideMediator);
			beginnersGuideMediator.BEGINNERSGUIDEEVENTDISPATCHER.dispatchEvent(new BeginnersGuideEvent(BeginnersGuideEvent.NEXTGUIDE));
		}
		
		/**
		 * 刷新编队信息
		 * */
		public function refreshFormation($index:int=0):void
		{
			formationUI  = MediatorUtil.getMediatorByInterface(IUIOperatableFormationMediator) as FormationMediator;
			formationID = $index;
			
			var formationArrVO:FormationArrVO = formationUI.showFormationArray($index);
			
			_preBattlePanel.formationCollSet = formationArrVO.formationInfo.concat();
		}
		
		
		/**
		 * 判断是否初始化
		 * */
		private var isSetRoad:Boolean = false;
		private var array:Array = []; 
		/**
		 * 设置编队进攻路线
		 * @param $index 将领索引 
		 * @type:路线索引
		 * */ 
		public function setAttackRoad($index:int,$type:int):void
		{
			isSetRoad = true;
			if(!lineDic[formationID])
			{
				var arr:Array = new Array();
				for(var i:int = 0;i< 6 ; i++)
				{
					var dataByte:DataByteVO = new DataByteVO();
					dataByte.btByte = 1;
					arr.push(dataByte);
				}
				lineDic[formationID] = arr;
				array = lineDic[formationID];
				var data:DataByteVO = array[$index] as DataByteVO;
				data.btByte = $type
			}else
			{
				array = lineDic[formationID];
				var data1:DataByteVO = array[$index] as DataByteVO;
				data1.btByte = $type
			}
			
			attackRoadArr = lineDic[formationID];
		}
		
		/**
		 * 战场所有信息
		 * */
		override protected function refreshSceneInfo($arr:Array):void
		{
			_expeditionInfoPanel.sceneInfoColl=  $arr;	
			_expeditionInfoPanel.isPass =isPass ;
		}
		
		/**
		 * 数组分页
		 * */
		public function refreshPage($page:int):void
		{
			nowPage = $page
			refreshData();
		}
		
		/**
		 * 添加好友
		 * @param $dwid 援军
		 * */
		public function addApplyFriend($dwid:int):void
		{
			var social:SocialRelativeMediator = MediatorUtil.getMediatorByInterface(IUIOperatableMilitarySocalMediator) as SocialRelativeMediator;
			social.addFriend($dwid);
			
		}
		
		/**
		 * 
		 * 战斗结束  成功信息
		 * */
		override public function getEndInfo($endInfo:SRBattleEndInfoVO):void
		{
			_uiManager.show(EndPanel) ;
			var endPanel:EndPanel = _uiManager.getUIObj(EndPanel) as EndPanel;
			endPanel.types = $endInfo.btResult;
			if($endInfo.btResult == 1)
			{
				endPanel.isUp = Boolean($endInfo.btIsUpgrade -2);
				var battle:BattleEndPanel = _uiManager.getUIObj(BattleEndPanel) as BattleEndPanel;
				battle.battleEndInfoVO = $endInfo;
			}
			isBattleEnd = true;
		}
		
		/**
		 * 地图信息
		 * */
		override public function putDownMapInfo($byte:ByteArray):void
		{
			baseMapByteArray = $byte;
			var analy:AnaysisByte = new AnaysisByte();
			baseMapvo = analy.analyzeData(baseMapByteArray);
		}
		
		
		/**
		 * 章节信息
		 * */
		override protected function refreshChaptersDic($dic:Dictionary):void
		{
			_expeditionInfoPanel.dic = $dic;
		}
		
		/**
		 * 数据刷新
		 * */	
		private function refreshData():void
		{
			
			_expeditionPanel.page_grop.nowPage =arrpagition.nowPage = nowPage;
			_expeditionPanel.page_grop.totalPage = arrpagition.totalPage;
			_expeditionPanel.chapterColl.source = arrpagition.source();
			_expeditionPanel.dataGroup1.dataProvider = _expeditionPanel.chapterColl;
			
			if(nowPage == 2)
			{
				arrpagition.nowPage = 1;
				_expeditionPanel.preOrNextColl.source = arrpagition.source();
				_expeditionPanel.dataGroup.dataProvider = _expeditionPanel.preOrNextColl;
			}else
			{
				arrpagition.nowPage = 2;
				_expeditionPanel.preOrNextColl.source = arrpagition.source();
				_expeditionPanel.dataGroup.dataProvider = _expeditionPanel.preOrNextColl;
			}
			
		}
		
		/**
		 * 保存战场信息
		 * */
		public function get fightScene():FightScene
		{
			return _fightScene;
		}
		
		/**
		 * @private
		 */
		public function set fightScene(value:FightScene):void
		{
			_fightScene = value;
		}
	}
}