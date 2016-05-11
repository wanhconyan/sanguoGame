package cn.sevencool.sangocraft.web.ui.barracks.mediator
{
	import cn.sevencool.sangocraft.data.manager.barracks.mediator.BaseBarracksMediator;
	import cn.sevencool.sangocraft.data.manager.barracks.mediator.IUIOperatableBarracksMediator;
	import cn.sevencool.sangocraft.data.symbols.CommonData;
	import cn.sevencool.sangocraft.data.symbols.ItemManager;
	import cn.sevencool.sangocraft.data.vo.BagVO;
	import cn.sevencool.sangocraft.data.vo.ItemOperationVO;
	import cn.sevencool.sangocraft.data.vo.MonsterDescription;
	import cn.sevencool.sangocraft.web.manager.UIMananger;
	import cn.sevencool.sangocraft.web.ui.barracks.view.BarracksPanel;
	import cn.sevencool.sangocraft.web.ui.barracks.view.GeneralDetailsPanel;
	import cn.sevencool.sangocraft.web.ui.militaryOffice.view.MilitaryOfficePanel;
	import cn.sevencool.sangocraft.web.ui.reinforce.view.ReinforcePanel;
	import cn.sevencool.sangocraft.web.ui.socialRelative.view.SocialRelativePanel;
	
	import flash.utils.Dictionary;
	
	/**
	 * project: sangocraft_Web
	 * @class: BarracksMediator
	 * @author: zhoujingye
	 * @usage: 兵营UImediator管理器
	 * @since: 2013-8-23
	 * @modified: 2013-8-23
	 * @modifier: zhoujingye 
	 */
	public class BarracksMediator extends BaseBarracksMediator  implements IUIOperatableBarracksMediator
	{
		/**
		 * 将领类型
		 * */
		public var generalTypeArr:Array=['勇兵悍将','磐石之毅','攻守兼备','运筹帷幄','神将无双','转生道具','强化合成'];
		/**
		 * 兵营面板
		 * */
		private var _barracksPanel:BarracksPanel = null ;
		/**
		 * 将领详情面板
		 * */
		private var _generalPanel:GeneralDetailsPanel = null;
		/**
		 * 物品管理器
		 * */
		private var _itemManager:ItemManager = null;
		public function BarracksMediator()
		{
			super();
		}
		
		/**
		 * mediator 初始化 
		 * 
		 */		
		override public function startup():void
		{
			_itemManager=ItemManager.getInstance();
			_barracksPanel = UIMananger.getInstance().getUIObj(BarracksPanel) as BarracksPanel ;
			_barracksPanel.mediatorUI = this ;
			_generalPanel = UIMananger.getInstance().getUIObj(GeneralDetailsPanel) as GeneralDetailsPanel;
			_generalPanel.mediatorUI = this;
		}
		
		
		/**
		 * 设置commdData中的数据
		 * */
		public function setPanelType($panelType:int):void
		{
			CommonData.packageType=$panelType.toString();
		}
		
		
		/**
		 * 获取背包行数
		 * */
		public function getBagRow($total:int):int
		{
			var  allCell:int=$total;
			var row:int=0;
			if(allCell%6==0)
			{
				row=Math.ceil(allCell/6)+1;
			}
			if(allCell%6!=0)
			{
				row=Math.ceil(allCell/6);
			}
			return row;
		}
		
		
		/**
		 * 显示包裹内容
		 * @param $type 整理类型
		 */	
		public function showItems($type:int):BagVO
		{
			return super.showBag($type);
		}
		
		
		/**
		 * 显示包裹物品详细信息
		 * @param $itemVO 物品
		 * @param $arr 物品数组
		 */	
		public function showItemsInfo($itemVO:ItemOperationVO,$arr:Array=null):MonsterDescription
		{
			return super.viewItemInfo($itemVO,$arr);
		}
		
		
		/**
		 * 扩建格子
		 */	
		public function extensionPackages():void
		{
			super.extensionPackage();
		}
		
		/**
		 * 请求人物全身像坐标
		 */	
		public function getRoleLoc(id:int):Array
		{
			return super.getRoleLo(id);
		}

		
		/**
		 * 打开/关闭将领详细面板
		 * 回弹上级菜单 
		 */		
		public function closeGeneralDetails($type:int):void
		{
			clearItemsStateInterface();
			switch($type)
			{
				case 0:
				{
					UIMananger.getInstance().showOrHide(BarracksPanel);
					break;
				}
				case 1:
				{
					UIMananger.getInstance().showOrHide(MilitaryOfficePanel);
					break;
				}
				case 2:
				{
					UIMananger.getInstance().showOrHide(ReinforcePanel);
					break;
				}
				case 3:
				{
					UIMananger.getInstance().showOrHide(SocialRelativePanel);
					break;
				}
				default:
				{
					throw new Error('closeGeneralDetails' + $type);
				}
			}
			
		}
		
		/**
		 * 查找某个物品是否在包裹中
		 * */
		public function itemIsInBag($item:ItemOperationVO):Boolean
		{
			return super.itemIsIn($item);
		}
		
		/**
		 * 根据物品唯一id
		 * 查找物品
		 * */
		public function getItemByIdInBag($itemid:Number):ItemOperationVO
		{
			return super.getItemById($itemid);
		}
		
		/**
		 * 根据物品基本id
		 * 查找物品是否在包裹里
		 * */
		public function itemIsInBagByBaseId($baseId:int):Boolean
		{
			return super.itemIsInByBaseId($baseId);
		}
		
		/**
		 * 根据物品基本id封装物品
		 * */
		public function getItemByBaseIdInterface($baseId:int):ItemOperationVO
		{
			return super.getItemByBaseId($baseId);
		}
		
		/**
		 * 清除物品被选中的状态
		 * */
		public function clearItemsStateInterface():void
		{
			super.clearItemsState();
		}
		
		
		/**
		 * 根据物品id取得物品等级
		 * */
		public function getGeneralLvl($onlyId:Number):int
		{
			var lvl:int=-1;
			var itemsDic:Dictionary=_itemManager.itemsDic;
			var itemO:ItemOperationVO = itemsDic[$onlyId];
			lvl=itemO.item.General.nLevel;
			return lvl;
		}
		
		
		/**
		 * 根据存放包裹地址 返回对应的升级物品vo 
		 * @param $refreshType 包裹整理类型			
		 *  兵种1
		 *  兵量2
		 *  攻击3
		 *  防御4
		 */		
		public function getAllItemsInterface($refreshType:int = 1):Array
		{
			return super.getAllItems($refreshType);
		}
		
	}
}