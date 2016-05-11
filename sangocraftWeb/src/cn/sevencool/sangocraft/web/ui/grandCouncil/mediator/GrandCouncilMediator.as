package cn.sevencool.sangocraft.web.ui.grandCouncil.mediator
{
	import cn.sevencool.sangocraft.data.manager.grandCouncil.mediator.BaseGrandCouncilMediator;
	import cn.sevencool.sangocraft.data.manager.grandCouncil.mediator.IUIOperatableGrandCouncilMediator;
	import cn.sevencool.sangocraft.data.model.MilitaryVO;
	import cn.sevencool.sangocraft.data.model.RArmyBuild;
	import cn.sevencool.sangocraft.data.vo.GrandcouncilArmyVO;
	import cn.sevencool.sangocraft.data.vo.GrandcouncilVO;
	import cn.sevencool.sangocraft.web.manager.UIMananger;
	import cn.sevencool.sangocraft.web.ui.grandCouncil.view.GrandCouncilPanel;
	
	import flash.utils.Dictionary;
	
	/**
	 * project: sangocraft_Web
	 * @class: GrandCouncilMediator
	 * @author: zhoujingye
	 * @usage: 军机处UImediator管理器
	 * @since: 2013-8-22
	 * @modified: 2013-8-22
	 * @modifier: zhoujingye 
	 */
	public class GrandCouncilMediator extends  BaseGrandCouncilMediator implements IUIOperatableGrandCouncilMediator
	{
		/**
		 * 军机处面板
		 * */
		private var _grandCouncilPanel:GrandCouncilPanel = null ;
		/**
		 * 军机处VO
		 * */
		private var _grandcouncilInfoVO:GrandcouncilArmyVO=null;
		/**
		 * 面板标题名称
		 * */
		public var titleNameArr:Array=['marines','though','theCavalry','instrument','wall','prepare'];
		/**
		 * 攻击图片
		 * */
		public var picAttackArr:Array=['marinesAttack','thoughAttack','BattlePic','instrumentAttack'];
		/**
		 * 防御图片
		 * */
		public var picDefenseArr:Array=['spearmanDefense','thoughDefense','defensePic','instrumentDefense','wallDefense'];
		public function GrandCouncilMediator()
		{
			super();
		}
		public function get grandcouncilInfoVO():GrandcouncilArmyVO
		{
			return _grandcouncilInfoVO;
		}

		public function set grandcouncilInfoVO(value:GrandcouncilArmyVO):void
		{
			_grandcouncilInfoVO = value;
		}

		/**
		 * mediator 初始化 
		 * 
		 */		
		override public function startup():void
		{
			_grandCouncilPanel = UIMananger.getInstance().getUIObj(GrandCouncilPanel) as GrandCouncilPanel ;
			_grandCouncilPanel.mediatorUI = this ;
		}
		
		
		/**
		 * 获取玩家银两
		 * */
		public function getPlayerSilverNum():int
		{
			return super.getPlayerSil();
		}
		/**
		 * 军队信息处理
		 * @param $armyInfo 军队信息包
		 * @param $index 选项卡索引
		 * */
		public function armyInfoHandler($index:int):GrandcouncilArmyVO
		{
			var m:MilitaryVO=getArmyVO($index);
			if(!m)
			{
				return _grandcouncilInfoVO;
			}
			if($index+1==m.btType)
			{
				_grandcouncilInfoVO=setVO(m);
			} 
			return _grandcouncilInfoVO;
		}
		
		/**
		 * 点击升级军队建设按钮 
		 * @param $btMilitary  兵科 1枪兵 2弓兵 3骑兵 4器械 5城防
		 * @param $btAttribute 兵科属性 1攻击 2防御 3兵量
		 */		
		public function getArmyBuildBtnClick($btMilitary:int,$btAttribute:int):void
		{
			var type:int=-1;
			type=$btMilitary+1;
			
			super.getArmyBuild(type,$btAttribute);
		}
		
		/**
		 * 获取军队加成信息
		 * */
		public function getArmyBuildValue(type:int,level:int):GrandcouncilVO
		{
			var dic:Dictionary=super.askForGrandCouncilInfo();
			var infoDic:Dictionary=dic[type];
			var vo:GrandcouncilVO=infoDic[level];
			return vo;
		}
		
		/**
		 * 军队升级后信息处理
		 * @param $armyBuild 军队升级后返回的包
		 * @param $index 选项卡索引
		 * */
		public function armyBuildHandler($armyBuild:RArmyBuild,$index:int):GrandcouncilArmyVO
		{
			if(!$armyBuild)
			{
				return _grandcouncilInfoVO;
			}
			if($index+1==$armyBuild.btArmyType)
			{
				setBackVO($armyBuild);
				setArmyBuildVO($armyBuild,$index);
			}
			return _grandcouncilInfoVO;
		}
		
		
		/**
		 * 获取军机处前端维护后端数据
		 * */	
		protected function getArmyVO($type:int):MilitaryVO
		{
			return super.getArmyInfoVO($type);
		}
		
		
		/**
		 * 设置军机处前端维护后端数据
		 * */	
		protected function setArmyVO(m:MilitaryVO,index:int):void
		{
			super.setArmyInfoVO(m,index);
		}
		
		private function setVO($armyInfo:MilitaryVO):GrandcouncilArmyVO
		{
			var vo:GrandcouncilArmyVO=new GrandcouncilArmyVO();
			vo.attackLevel=$armyInfo.btAttactLvl;
			vo.denfenceLevel=$armyInfo.btDefenseLvl;
			vo.numLevel=$armyInfo.btNumberLvl;
			var attackVo:GrandcouncilVO=getArmyBuildValue($armyInfo.btType,$armyInfo.btAttactLvl);
			var denfenceVo:GrandcouncilVO=getArmyBuildValue($armyInfo.btType,$armyInfo.btDefenseLvl);
			var numVo:GrandcouncilVO=getArmyBuildValue($armyInfo.btType,$armyInfo.btNumberLvl);
			var attackVo1:GrandcouncilVO=getArmyBuildValue($armyInfo.btType,$armyInfo.btAttactLvl+1);
			var denfenceVo1:GrandcouncilVO=getArmyBuildValue($armyInfo.btType,$armyInfo.btDefenseLvl+1);
			var numVo1:GrandcouncilVO=getArmyBuildValue($armyInfo.btType,$armyInfo.btNumberLvl+1);
			vo.attackCurrentAdd=attackVo.militaryAttract;
			vo.attackNextAdd=attackVo1.militaryAttract;
			vo.attackCost=attackVo1.militaryCost;
			vo.denfenceCurrentAdd=denfenceVo.militaryDefense;
			vo.denfenceNextAdd=denfenceVo1.militaryDefense;
			vo.denfenceCost=denfenceVo1.militaryCost;
			vo.numCurrentAdd=numVo.militaryNumber;
			vo.numNextAdd=numVo1.militaryNumber;
			vo.numCost=numVo1.militaryCost;
			
			if(super.getPlayerLvl()>$armyInfo.btAttactLvl)
			{
				vo.attackPanelState=true;
			} 
			else 
			{
				vo.attackPanelState=false;
			}
			if(super.getPlayerLvl()>$armyInfo.btDefenseLvl)
			{
				vo.denfencePanelState=true;
			} 
			else 
			{
				vo.denfencePanelState=false;
			}
			if(super.getPlayerLvl()>$armyInfo.btNumberLvl)
			{
				vo.numPanelState=true;
			} 
			else
			{
				vo.numPanelState=false;
			}
			return vo;
		}
		
		
		private function setBackVO($armyBuild:RArmyBuild):void
		{
			if($armyBuild.nErrorCode_tip!=0)
			{
				return;
			}
			var type:int=$armyBuild.btArmyType;
			var kind:int=$armyBuild.btAttribute;
			var lvl:int=$armyBuild.btLevel;
			var valueVO:GrandcouncilVO=getArmyBuildValue(type,lvl);
			var valueVO1:GrandcouncilVO=getArmyBuildValue(type,lvl+1);
			if(kind==1)
			{
				_grandcouncilInfoVO.attackCost=valueVO1.militaryCost;
				_grandcouncilInfoVO.attackCurrentAdd=valueVO.militaryAttract;
				_grandcouncilInfoVO.attackNextAdd=valueVO1.militaryAttract;
				_grandcouncilInfoVO.attackLevel=lvl;
				if(super.getPlayerLvl()>lvl)
				{
					_grandcouncilInfoVO.attackPanelState=true;
				}
				else 
				{
					_grandcouncilInfoVO.attackPanelState=false;
				}
			} 
			else if(kind==2)
			{
				_grandcouncilInfoVO.denfenceCost=valueVO1.militaryCost;
				_grandcouncilInfoVO.denfenceCurrentAdd=valueVO.militaryDefense;
				_grandcouncilInfoVO.denfenceNextAdd=valueVO1.militaryDefense;
				_grandcouncilInfoVO.denfenceLevel=lvl;
				if(super.getPlayerLvl()>lvl)
				{
					_grandcouncilInfoVO.denfencePanelState=true;
				}
				else 
				{
					_grandcouncilInfoVO.denfencePanelState=false;
				}
				
			}
			else if(kind==3)
			{
				_grandcouncilInfoVO.numCost=valueVO1.militaryCost;
				_grandcouncilInfoVO.numCurrentAdd=valueVO.militaryNumber;
				_grandcouncilInfoVO.numNextAdd=valueVO1.militaryNumber;
				_grandcouncilInfoVO.numLevel=lvl;
				if(super.getPlayerLvl()>lvl)
				{
					_grandcouncilInfoVO.numPanelState=true;
				}
				else 
				{
					_grandcouncilInfoVO.numPanelState=false;
				}
				
			}
		}
		
		/**
		 * 升级返回后更新前端保存的数据
		 * */
		private function setArmyBuildVO($armyBuild:RArmyBuild,$index:int):void
		{
			var m:MilitaryVO=getArmyVO($index);
			if(!m)
			{
				return;
			}
			if($armyBuild.btArmyType-1==$index)
			{
				m.btType=$armyBuild.btArmyType;
				if($armyBuild.btAttribute==1)
				{
					m.btAttactLvl=$armyBuild.btLevel;
				}
				else if($armyBuild.btAttribute==2)
				{
					m.btDefenseLvl=$armyBuild.btLevel;
				}
				else if($armyBuild.btAttribute==3)
				{
					m.btNumberLvl=$armyBuild.btLevel;
				}
			}
			setArmyInfoVO(m,$index);
		}
	}
}