package cn.sevencool.sangocraft.web.ui.reinforce.mediator
{
	import cn.sevencool.sangocraft.data.manager.battleField.mediator.IUIOperatableBattleMediator;
	import cn.sevencool.sangocraft.data.manager.reinForce.mediator.BaseReinforceMediator;
	import cn.sevencool.sangocraft.data.manager.reinForce.mediator.IUIOperatableReinforceMediator;
	import cn.sevencool.sangocraft.data.manager.utils.MediatorUtil;
	import cn.sevencool.sangocraft.data.model.ItemVO;
	import cn.sevencool.sangocraft.data.model.RReinforcementsListInfo;
	import cn.sevencool.sangocraft.data.model.ReinforcementsVO;
	import cn.sevencool.sangocraft.data.symbols.ItemsManager;
	import cn.sevencool.sangocraft.data.vo.ItemDescription;
	import cn.sevencool.sangocraft.data.vo.ItemOperationVO;
	import cn.sevencool.sangocraft.data.vo.MonsterInfo;
	import cn.sevencool.sangocraft.data.vo.ReinDisplayVO;
	import cn.sevencool.sangocraft.web.manager.UIMananger;
	import cn.sevencool.sangocraft.web.symbols.PagingArray;
	import cn.sevencool.sangocraft.web.ui.barracks.view.GeneralDetailsPanel;
	import cn.sevencool.sangocraft.web.ui.battleField.mediator.BattleFieldMediator;
	import cn.sevencool.sangocraft.web.ui.reinforce.view.ReinforceInfo;
	import cn.sevencool.sangocraft.web.ui.reinforce.view.ReinforcePanel;
	
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	
		/**
		 * 
		 * @author Administrator
		 * 
		 */	
		public class ReinforceMediator extends BaseReinforceMediator implements IUIOperatableReinforceMediator
		{		
			
			/**
			 * 援军列表0
			 * 
			 * */		
			private static const REINFORCELIST:uint = 0;
			
			/**
			 * 获取主将信息
			 * */
			private static const GETCHIEFINFO:uint = 1;	

			/**
			 * 将领详细面板
			 * 
			 * */
			private var  _gen:GeneralDetailsPanel = null;
			
			/** 
			 * 数据保存 分页 as 
			 * */
			private var _arrpagition:PagingArray = null;			
			
			/**
			 * 援军面板
			 * */
			private var _reinPanel:ReinforcePanel = null;			
			
			/**
			 * 援军列表
			 * */
			private var _reinforceList:Array = [];
			
			/**
			 * 刷新数组 
			 */		
			public var refreshIndex:int = -1;
			
			/**
			 * 首次打开的排序方式
			 * */
			private var refreshType:int = 1;
			
			private var nowPage:int= 1;
			public function ReinforceMediator()
			{
				super();
			}
			
			
			/**
			 * mediator 初始化  
			 */		
			override public function startup():void
			{
				_reinPanel = UIMananger.getInstance().getUIObj(ReinforcePanel) as ReinforcePanel ;     //取得面板
				_reinPanel.mediatorUI = this ;             //可以使面板抓到 mediator
			}
			
		
			/**
			 * 援军数组
			 * */
		public function get reinforceList():Array
		{
			return _reinforceList;
		}

		
		public function set reinforceList(value:Array):void
		{
			_reinforceList = value;
			refreshPage(nowPage);
		}
		
		override public function set maintainArr(value:Array):void
		{
		
			reinforceList = super.sortReinforceByType(1,value.concat(),true);	
		
		}
		
		/**
		 * 站前配置
		 * 
		 * */
		override public function getStationCon($station:ReinforcementsVO):void
		{
			if($station)
			{
				var itemDes:ItemDescription = ItemsManager.getInstance().ItemInfo[$station.nCommanderId]
				var monster:MonsterInfo = new MonsterInfo();
				monster.onlyID = $station.nCommanderId;
				monster.picID = itemDes.nHeadId;
				monster.level = $station.btCommanderLevel;
				monster.monsterName = $station.szName;
				monster.theType = itemDes.nArmType;
				monster.monsterSkillID = itemDes.nPassiveSkillID;
				openPreBattle(monster);
			}
		}
		
		
		/**
		 * 显示战前配置
		 * */
		public function openPreBattle($monster:MonsterInfo = null):void
		{
			var battle:BattleFieldMediator = MediatorUtil.getMediatorByInterface(IUIOperatableBattleMediator) as BattleFieldMediator;
			battle.showPrewarConfigurationOnClose($monster);
		}
		
		/**
		 * 数组分页
		 * @param $page 当前页
		 * @param $type 数据源类型 0援军列表 
		 * */
		public function refreshPage($page:int):void
		{
			nowPage = $page;
			_arrpagition = new PagingArray(reinforceList,6);
			_arrpagition.nowPage = $page;
			_reinPanel.reinForceInfo.source = _arrpagition.source();
			_reinPanel.reinForce.dataProvider = _reinPanel.reinForceInfo;
			_reinPanel.paga_group.totalPage = _arrpagition.totalPage;
		}
		
		
		/**
		 * 点击人物头像选择操作类型
		 * @param $index:int
		 * @param rein:援軍信息
		 * */
		public function menuItemClick($index:int,$rein:ReinDisplayVO):void
		{
			switch($index)
			{
				case 0:   //选择		
					super.choose($rein.dwOnlyID);
					break;
				case 1:  //将领详情 
					UIMananger.getInstance().showOrHide(GeneralDetailsPanel) ;
					_gen = UIMananger.getInstance().getUIObj( GeneralDetailsPanel) as GeneralDetailsPanel; 
					var itemOp:ItemOperationVO = new ItemOperationVO();
					itemOp.item = new ItemVO();
					itemOp.item.dwBaseID =  $rein.nCommanderId;
					_gen.item = itemOp;
					_gen.showType = 2 ;
					_gen.arr =[$rein.nAttack,$rein.nDefense,$rein.nSoldierNumber,$rein.btCommanderLevel]
					break;		
				default:					
					throw new Error("$index"+$index)
			}
		}

		
		/**排序
		 * @param $index 排序类型 0兵种排序、1兵量排序、2攻击排序、3防御排序
		 * 
		 * */
		public function sortReinforcebyType($index:int,$isSend:Boolean = true):void
		{			
			refreshType= refreshIndex = $index ;
			reinforceList = super.sortReinforceByType($index,reinforceList.concat(),$isSend );	
		}
		
		
		/**
		 * 请求援军数据
		 *
		 * */
		public function sendSGetReinListVO():void
		{		
			super.operateToRein();				
		}					
	}
}