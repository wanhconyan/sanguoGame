package cn.sevencool.sangocraft.web.ui.sell.mediator
{
	import cn.sevencool.sangocraft.data.manager.barracks.control.BarracksManager;
	import cn.sevencool.sangocraft.data.manager.barracks.mediator.IUIOperatableBarracksMediator;
	import cn.sevencool.sangocraft.data.manager.sell.mediator.BaseSellMediator;
	import cn.sevencool.sangocraft.data.manager.sell.mediator.IUIOperatableSellMediator;
	import cn.sevencool.sangocraft.data.manager.utils.MediatorUtil;
	import cn.sevencool.sangocraft.data.manager.utils.ModuleManager;
	import cn.sevencool.sangocraft.data.symbols.ItemManager;
	import cn.sevencool.sangocraft.data.vo.ItemDescription;
	import cn.sevencool.sangocraft.data.vo.ItemOperationVO;
	import cn.sevencool.sangocraft.data.vo.SellInfoVO;
	import cn.sevencool.sangocraft.web.manager.UIMananger;
	import cn.sevencool.sangocraft.web.ui.barracks.mediator.BarracksMediator;
	import cn.sevencool.sangocraft.web.ui.sell.view.ChoosePanel;
	
	/**
	 * project: sangocraft_Web
	 * @class: SellMediator
	 * @author: zhoujingye
	 * @usage: 兵营出售UImediator管理器
	 * @since: 2013-8-27
	 * @modified: 2013-8-27
	 * @modifier: zhoujingye 
	 */
	public class SellMediator extends BaseSellMediator  implements IUIOperatableSellMediator
	{
		public function SellMediator()
		{
			super();
		}
		/**
		 * 出售面板
		 * */
		private var _choosePanel:ChoosePanel = null ;
		
		private var _barrM:BarracksManager=ModuleManager.getInstance().getInstanceBy(BarracksManager);
		/**
		 * mediator 初始化 
		 * 
		 */		
		override public function startup():void
		{
			_choosePanel = UIMananger.getInstance().getUIObj(ChoosePanel) as ChoosePanel ;
			_choosePanel.mediatorUI = this ;
		}
		
		public function showSellItemValue($arr:ItemOperationVO,$refreshType:int):SellInfoVO
		{
			return super.sellInfo($arr,$refreshType);
		}
		
		
		/**
		 * 出售物品后刷新
		 * */
		public function afterSellItems():SellInfoVO
		{
			return super.afterSellItem();
		}
		
		
		/**
		 * 获取物品
		 * */
		public function getBagItems():Array
		{
			return super.getItems();
		}
		
		
		/**
		 * 选中物品，处理物品状态
		 * */
		public function chooseItemForSell(item:ItemOperationVO):void
		{
			var itemDes:ItemDescription = ItemManager.getInstance().ItemInfo[item.item.dwBaseID] as ItemDescription;
			if(!item.selectSell && item.item.General.nLocationIndex !=1&&!item.isGray)
			{
				item.selectSell = true;
				_barrM.sellGetMoney += itemDes.nSellPrice;
			} else if(item.item.General.nLocationIndex !=1&&item.selectSell){
				item.selectSell = false;
				_barrM.sellGetMoney -= itemDes.nSellPrice;
			}
		}
		
		
		/**
		 * 出售物品
		 * @param $i64id 物品唯一ID数组
		 */
		public function  sellItem($itemOperate:ItemOperationVO=null,isAll:Boolean=true):void
		{
			super.sellItems($itemOperate,isAll);
		}
		
		
		/**
		 * 出售刷新
		 * */
		public override function refreshBarrasPanel():void
		{
			var barr:BarracksMediator = MediatorUtil.getMediatorByInterface(IUIOperatableBarracksMediator) as BarracksMediator;
			barr.showItems(0);
			_choosePanel.sellBack();
		}
	}
}