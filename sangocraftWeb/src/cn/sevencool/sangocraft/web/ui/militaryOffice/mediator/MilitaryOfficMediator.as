package cn.sevencool.sangocraft.web.ui.militaryOffice.mediator
{
	import cn.sevencool.sangocraft.data.manager.militaryOffice.Mediator.BaseMilitaryOfficeMediator;
	import cn.sevencool.sangocraft.data.manager.militaryOffice.Mediator.IUIOperatableMilitaryOfficeMediator;
	import cn.sevencool.sangocraft.data.manager.screen.mediator.IUIOperateBaseInfoMadiator;
	import cn.sevencool.sangocraft.data.manager.utils.MediatorUtil;
	import cn.sevencool.sangocraft.data.model.ItemVO;
	import cn.sevencool.sangocraft.data.symbols.ItemsManager;
	import cn.sevencool.sangocraft.data.vo.ItemOperationVO;
	import cn.sevencool.sangocraft.web.manager.UIMananger;
	import cn.sevencool.sangocraft.web.ui.barracks.view.BarracksPanel;
	import cn.sevencool.sangocraft.web.ui.barracks.view.GeneralDetailsPanel;
	import cn.sevencool.sangocraft.web.ui.mainPanel.mediator.BasicInforMediator;
	import cn.sevencool.sangocraft.web.ui.militaryOffice.view.BarracksSpace;
	import cn.sevencool.sangocraft.web.ui.militaryOffice.view.ExtractionResults;
	import cn.sevencool.sangocraft.web.ui.militaryOffice.view.MilitaryOfficePanel;
	
	import mx.collections.ArrayCollection;
	
	/**
	 * project: sangocraft_Web
	 * @class: MilitaryOfficMediator
	 * @author: zhouyan
	 * @usage: 招贤府UImediator管理器
	 * @since: 2013-8-15
	 * @modified: 2013-8-15
	 * @modifier: zhouyan 
	 */
	public class MilitaryOfficMediator extends BaseMilitaryOfficeMediator implements IUIOperatableMilitaryOfficeMediator
	{
		public function MilitaryOfficMediator()
		{
			super();
		}
		private var _militaryOfficrPanel:MilitaryOfficePanel = null ;
		private var _barracksSpacePanel:BarracksSpace = null ;
		private var _extractionResults:ExtractionResults = null ;
		private var  _gen:GeneralDetailsPanel = null;
		private var _monsterArr:Array = [];
		private var _arrColl:ArrayCollection = null;
		private var _homewill :ArrayCollection = null;
		
		/**
		 * mediator 初始化 
		 * 
		 */		
		override public function startup():void
		{
			_militaryOfficrPanel = UIMananger.getInstance().getUIObj(MilitaryOfficePanel) as MilitaryOfficePanel ;
			_extractionResults = UIMananger.getInstance().getUIObj(ExtractionResults ) as ExtractionResults  ;
			_barracksSpacePanel = UIMananger.getInstance().getUIObj(BarracksSpace) as BarracksSpace ;
			_militaryOfficrPanel.mediatorUI = this ;
			_extractionResults.mediatorUI = this ;
			_barracksSpacePanel.mediatorUI = this ;
			_homewill = new ArrayCollection();
			_arrColl = new ArrayCollection();
			
		}
		
		//调用实现的借口（供外部UI调用）
		public function addBagPanel():void
		{
			
		}
		
		
		/**
		 * 打开兵营面板
		 * */
		public function goCamp():void
		{
			UIMananger.getInstance().showOrHide(BarracksPanel) as BarracksPanel;
		}
		
		/**
		 * 点击求将按钮 
		 * @param $type
		 * 
		 */		
		public function findGeneralsBtnClick($type:int):void
		{
//			if($type == 3 ||$type==4)
//			{
//				UIMananger.getInstance().showOrHide(ExtractionResults) as ExtractionResults;
//			}
			super.findGenerals($type);
		}
		
		
		/**
		 * 招贤馆返回数据
		 * */
		/**
		 * 
		 * @param value
		 * 
		 */
		override public function set monster(value:Array):void
		{
			if(value.length >1)
			{
				_arrColl.source = value;
				homewill = _arrColl;
				UIMananger.getInstance().showOrHide(ExtractionResults) as ExtractionResults;
				
			}else
			{
					UIMananger.getInstance().showOrHide(GeneralDetailsPanel)
				_gen = UIMananger.getInstance().getUIObj(GeneralDetailsPanel)  as GeneralDetailsPanel; 	
				var itemOp:ItemOperationVO = new ItemOperationVO();
				itemOp=ItemsManager.getInstance().getItemById(value[0]);
				_gen.item = itemOp;
				_gen.showType = 1;
			}
		}
		
		/**
		 * 获取当前金币数目
		 * @return int 金币个数
		 * */
		public function getGoldNumAndRein():Array
		{
			var arr:Array=[];
			
			var baseInfoMediator:BasicInforMediator  = MediatorUtil.getMediatorByInterface(IUIOperateBaseInfoMadiator) as BasicInforMediator;
			arr.push(baseInfoMediator.getReinPoint(),baseInfoMediator.getGodIngot());
			return arr;
		}
		
		/**
		 * 打开兵营扩充面板
		 * */
		public function opEnlargePanel():void
		{
		
			UIMananger.getInstance().showOrHide(BarracksSpace);
		
		}
		
		
		public function get monsterArr():Array
		{
			return _monsterArr;
		}
		
		public function set monsterArr(value:Array):void
		{
			_monsterArr = value;
		}

		public function get homewill():ArrayCollection
		{
			return _homewill;
		}

		public function set homewill(value:ArrayCollection):void
		{
			_homewill = value;
		}

		
	}
}