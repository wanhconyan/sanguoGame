package cn.sevencool.sangocraft.web.ui.upgrade.mediator
{
	import cn.sevencool.sangocraft.data.manager.upgrade.mediator.BaseUpgradeMediator;
	import cn.sevencool.sangocraft.data.manager.upgrade.mediator.IUIOperatableUpgradeMediator;
	import cn.sevencool.sangocraft.data.vo.ItemOperationVO;
	import cn.sevencool.sangocraft.data.vo.TransMigration;
	import cn.sevencool.sangocraft.web.manager.UIMananger;
	import cn.sevencool.sangocraft.web.ui.upgrade.view.UpGradePanel;
	
	/**
	 * project: sangocraft_Web
	 * @class: UpGradeMediator
	 * @author: zhoujingye
	 * @usage: 兵营UImediator管理器
	 * @since: 2013-8-23
	 * @modified: 2013-8-23
	 * @modifier: zhoujingye 
	 */
	public class UpGradeMediator extends BaseUpgradeMediator implements IUIOperatableUpgradeMediator
	{
		/**
		 * 升星面板
		 * */
		private var _upGradePanel:UpGradePanel = null ;
		/**
		 * 显示管理器
		 * */
		private var _uiManager:UIMananger=null;
		public function UpGradeMediator()
		{
			super();
		}
		/**
		 * mediator 初始化 
		 * 
		 */		
		override public function startup():void
		{
			_uiManager=UIMananger.getInstance();
			_upGradePanel = _uiManager.getUIObj(UpGradePanel) as UpGradePanel ;
			_upGradePanel.mediatorUI = this ;
		}
		
		/**
		 * 取得升星信息
		 * */
		public function getUpgradeInfo($item:ItemOperationVO):TransMigration
		{
			return super.upgradeInfo($item);
		}
		
		public function getItems():Array
		{
			return super.getBagItems();
		}
		/**
		 * 升星
		 * @param $i64Dest 升星主体唯一ID
		 * @param $i64Material 材料将领
		 */	
		public function upLvl($i64Dest:Number):void
		{
			super.upLevel($i64Dest);
		}
		
		/**
		 * 获取玩家银币
		 * */
		private function getSilverUIM():int
		{
			return super.getSilver();
		}
		
		
	}
}