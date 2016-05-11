package cn.sevencool.sangocraft.web.ui.strengthen.mediator
{
	import cn.sevencool.sangocraft.data.manager.strengthening.mediator.BaseStrengtheningMediator;
	import cn.sevencool.sangocraft.data.manager.strengthening.mediator.IUIOperatableStrengtheningMediator;
	import cn.sevencool.sangocraft.data.vo.EnForceVO;
	import cn.sevencool.sangocraft.data.vo.ItemOperationVO;
	import cn.sevencool.sangocraft.data.vo.SellInfoVO;
	import cn.sevencool.sangocraft.web.manager.UIMananger;
	import cn.sevencool.sangocraft.web.ui.strengthen.view.StrengthenPanel;
	
	/**
	 * project: sangocraft_Web
	 * @class: StrengthenMediator
	 * @author: zhoujingye
	 * @usage: 兵营将领强化UImediator管理器
	 * @since: 2013-8-27
	 * @modified: 2013-8-27
	 * @modifier: zhoujingye 
	 */
	public class StrengthenMediator extends BaseStrengtheningMediator implements IUIOperatableStrengtheningMediator
	{
		/**
		 * 强化面板
		 * */
		private var _strengthenPanel:StrengthenPanel = null ;
		/**
		 * 显示管理器
		 * */
		private var _uiMananger:UIMananger=null;
		public function StrengthenMediator()
		{
			super();
		}
		/**
		 * mediator 初始化 
		 * 
		 */		
		override public function startup():void
		{
			_uiMananger=UIMananger.getInstance();
			_strengthenPanel = _uiMananger.getUIObj(StrengthenPanel) as StrengthenPanel ;
			_strengthenPanel.mediatorUI = this ;
		}
		
		/**
		 * 将领强化
		 * @param $i64Dest 强化主体唯一ID
		 * @param $i64Material 材料将领
		 */	
		public function generalStrength($i64Dest:Number,$i64Material:Array):void
		{
			super.generalStrengthen($i64Dest,$i64Material);
		}
		
		/**
		 * 选择武将强化填充回调
		 * */
		public function showGeneralInfo($item:ItemOperationVO):EnForceVO
		{
			return super.strengtheningInfo($item);
		}
		
		/**
		 * 获取材料选择面板需要显示的物品
		 * */
		public function getChoosePanelBagItems():Array
		{
			return super.getChoosePanelItems();
		}
		
		/**
		 * 获取强化选择面板需要显示的物品
		 * */
		public function getStrengthChoosePanelBagItems():Array
		{
			return super.getStrengChoosePanelItems();
		}
		
		/**
		 * 获取玩家银币
		 * */
		public function getPlayerSilver():int
		{
			return super.getPlayerSil();
		}
		
		
		/**
		 * 选择材料后，选择面板显示
		 * */
		public function showChoosePanelMaterialInfo($item:ItemOperationVO,$refreshType:int):SellInfoVO
		{
			return super.materialGenerals($item,$refreshType);
		}
		
		/**
		 * 无强化关闭面板
		 * */
		public function closeStrengthenPanelItems():void
		{
			 super.closeStrengthenPanel();
		}
		
		/**
		 * 强化后回调
		 * */
		public function strengtheningBack():EnForceVO
		{
			return super.enforceInfo;
		}
		
		
		/**
		 * 填入材料
		 * */
		public function addMaterial(operate:ItemOperationVO,arr:Array):EnForceVO
		{
			return super.ok_materialGenerals(operate,arr);
		}
	}
}