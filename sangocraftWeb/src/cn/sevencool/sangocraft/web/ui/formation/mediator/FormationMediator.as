package cn.sevencool.sangocraft.web.ui.formation.mediator
{
	import cn.sevencool.sangocraft.data.manager.barracks.mediator.IUIOperatableBarracksMediator;
	import cn.sevencool.sangocraft.data.manager.formation.mediator.BaseFormationMediator;
	import cn.sevencool.sangocraft.data.manager.formation.mediator.IUIOperatableFormationMediator;
	import cn.sevencool.sangocraft.data.manager.utils.MediatorUtil;
	import cn.sevencool.sangocraft.data.model.Int64VO;
	import cn.sevencool.sangocraft.data.model.ItemVO;
	import cn.sevencool.sangocraft.data.model.RSSetFormation;
	import cn.sevencool.sangocraft.data.symbols.CommonData;
	import cn.sevencool.sangocraft.data.vo.FormationArrVO;
	import cn.sevencool.sangocraft.data.vo.ItemOperationVO;
	import cn.sevencool.sangocraft.data.vo.MonsterInfo;
	import cn.sevencool.sangocraft.web.manager.UIMananger;
	import cn.sevencool.sangocraft.web.ui.barracks.mediator.BarracksMediator;
	import cn.sevencool.sangocraft.web.ui.formation.view.FormationPanel;
	
	/**
	 * project: sangocraft_Web
	 * @class: FormationMediator
	 * @author: zhoujingye
	 * @usage: 兵营编队UImediator管理器
	 * @since: 2013-8-27
	 * @modified: 2013-11-08
	 * @modifier: zhoujingye 
	 */
	public class FormationMediator extends BaseFormationMediator  implements IUIOperatableFormationMediator
	{
		/**
		 * 编队面板
		 * */
		private var _formationPanel:FormationPanel = null ;
		/**
		 * 编队信息
		 * */
		private var _fomationArr:Array=[];
		/**
		 * 兵营Mediator
		 * */
		private var _barrM:BarracksMediator = null;
		/**
		 * 显示管理器
		 * */
		private var _uiManager:UIMananger = null;
		public function FormationMediator()
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
			_formationPanel = _uiManager.getUIObj(FormationPanel) as FormationPanel ;
			_formationPanel.mediatorUI = this ;
			_barrM=MediatorUtil.getMediatorByInterface(BarracksMediator) as BarracksMediator;
		}
		
		
		/**
		 * 选项卡切换处理
		 * */
		public function btnClickHandler($type:int):FormationArrVO
		{
			var formationArr:FormationArrVO=new FormationArrVO();
			var len:int=_fomationArr.length;
			for(var i:int=0;i<len;i++)
			{
				var formationArrVO:FormationArrVO=_fomationArr[i];
				if($type==formationArrVO.formationID)
				{
					formationArr=getRecentLvl(formationArrVO);
				}
			}
			return formationArr;
		}
		
		
		/**
		 * 设置编队返回包
		 * */
		public function setFormationBack($setFormation:RSSetFormation):void
		{
			super.formationSet($setFormation);
		}
		
		/**
		 * 获取编队设置后的数据
		 * */
		override protected function getBackFomationInfo():void
		{ 
			_fomationArr=super.formationList;
			_formationPanel.setformationSetBack();
		}
		
		/**
		 * 获取格子信息
		 * @param $isMonster:是否为武将
		 * @param $index:编队编号
		 * @return selectFormation($index); 返回格子信息数组
		 * */
		public function getItembag($index:int,$isMonster:Boolean,$refreshType:int,clickItem:ItemOperationVO=null):Array
		{
			return super.selectFormation($index,$isMonster,$refreshType,clickItem);
		}
		
		
		/**
		 * 获取编队信息
		 * */
		public function getFormationInfo():void
		{
			_fomationArr=super.formationList;
		}
		
		
		/**
		 * 实现编队接口
		 * @param $index编队信息
		 * @return array;
		 * */
		public function showFormationArray($index:int):FormationArrVO
		{
			
			return super.formationList[$index];
		}
		
		
		/**
		 * 设置编队
		 * @param $nID  编队编号，1-5
		 * @param $i64ItemID 每个位置上的将领唯一ID 
		 */		
		public function setFormationInfo($nID:int,$i64ItemID:Number,$loc:int):void
		{
			var arr:Array=getFormationCurrentInfo($nID);
			var int64VO:Int64VO=arr[$loc];
			int64VO.i64Value=$i64ItemID;
			arr[$loc]=int64VO;
			super.setFormation($nID+1,arr);
		}
		
		
		/**
		 * @param $index:int 打开的编队的序列
		 * @return array:编队信息
		 * */
		public function getFormationInfor($index:int):Array
		{
			return getFormationCurrentInfo($index);
		}
		
		/**
		 * 包裹里添加移除按钮
		 * 
		 * @param $arr 包裹数据
		 * @param $isMon 该位置是否有将领
		 * @return 
		 * 
		 */		
		public function setRemoveButton($arr:Array,$isMon:Boolean):Array
		{
			var arrNew:Array=$arr;
			if($isMon) 
			{
				var removeButtonArr:Array=[];
				var operate:ItemOperationVO = new ItemOperationVO();
				operate.item=new ItemVO();
				operate.removeBtn = true;
				operate.selectFormations=3;
				removeButtonArr.push(operate);
				arrNew=removeButtonArr.concat(arrNew);
			}
			return arrNew;
		}
		
		
		/**
		 * 
		 * 编队统率力检测
		 * 验证编队中是否有大于主将的编队
		 * @return 
		 * 
		 */		
		public function vaildateCommader():Boolean
		{
			var isLarge:Boolean = false;
			var len:int=_fomationArr.length;
			for(var i:int=0;i<len;i++)
			{
				if(isLarge)
				{
					break;
				}
				var formation:FormationArrVO = _fomationArr[i] as FormationArrVO;
				var commader:int = 0;
				var formationInfoLen:int=formation.formationInfo.length;
				for(var j:int = 0;j<formationInfoLen ;j++)
				{
					var monster:MonsterInfo = formation.formationInfo[j] as MonsterInfo;
					commader += monster.leaderShip;
				}
				
				if(commader > CommonData.nCommander)
				{
					isLarge = true;
				}
			}
			return  isLarge;
		}
		
		
		/**
		 * 取得最新等级
		 * */
		private function getRecentLvl($formationArrVO:FormationArrVO):FormationArrVO
		{
			var arr:Array=$formationArrVO.formationInfo;
			var len:int=arr.length;
			for(var i:int=0;i<len;i++)
			{
				var mon:MonsterInfo=arr[i];
				if(mon.onlyID<=0)
				{
					continue;
				}
				var lvl:int=_barrM.getGeneralLvl(mon.onlyID)
				if(mon.level<lvl)
				{
					mon.level=lvl;
				}
			}
			$formationArrVO.formationInfo=arr;
			return $formationArrVO;
		}
		
		/**
		 * 获取当前编队信息
		 * */
		private function getFormationCurrentInfo($nID:int):Array
		{
			var IDArr:Array=[];
			var formationArrVO:FormationArrVO=_fomationArr[$nID];
			var arr:Array=formationArrVO.formationInfo;
			var len1:int=arr.length;
			for(var i:int=0;i<len1;i++)
			{
				var mon:MonsterInfo=arr[i];
				if(mon.onlyID==-1)
				{
					var int641:Int64VO=new Int64VO();
					int641.i64Value=0;
					IDArr.push(int641);
				} 
				if(mon.onlyID!=-1)
				{
					var int642:Int64VO=new Int64VO();
					int642.i64Value=mon.onlyID;
					IDArr.push(int642);
				}
			}
			return IDArr;
		}
	}
}