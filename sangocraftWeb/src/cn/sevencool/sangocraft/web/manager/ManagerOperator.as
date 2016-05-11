package cn.sevencool.sangocraft.web.manager
{
	import cn.sevencool.sangocraft.data.manager.barracks.control.BarracksManager;
	import cn.sevencool.sangocraft.data.manager.battleField.control.BattleFieldManager;
	import cn.sevencool.sangocraft.data.manager.beginnersGuide.control.BeginnersGuideManager;
	import cn.sevencool.sangocraft.data.manager.formation.control.FormationManager;
	import cn.sevencool.sangocraft.data.manager.grandCouncil.control.GrandCouncilManager;
	import cn.sevencool.sangocraft.data.manager.loading.control.LoadingPanelManager;
	import cn.sevencool.sangocraft.data.manager.login.control.LoginManager;
	import cn.sevencool.sangocraft.data.manager.mainPanel.control.MainPanelManager;
	import cn.sevencool.sangocraft.data.manager.militaryOffice.control.MilitaryOfficeManager;
	import cn.sevencool.sangocraft.data.manager.reinForce.control.ReinforceManager;
	import cn.sevencool.sangocraft.data.manager.screen.control.BasicInforManager;
	import cn.sevencool.sangocraft.data.manager.screen.control.ScreenManager;
	import cn.sevencool.sangocraft.data.manager.sell.control.SellManager;
	import cn.sevencool.sangocraft.data.manager.skillEffect.control.SkillEffectManager;
	import cn.sevencool.sangocraft.data.manager.socalRelative.control.SocalRelativeManager;
	import cn.sevencool.sangocraft.data.manager.strengthening.control.StrengtheningManager;
	import cn.sevencool.sangocraft.data.manager.upgrade.control.UpgradeManager;
	import cn.sevencool.sangocraft.data.manager.utils.ModuleManager;
	import cn.sevencool.sangocraft.data.symbols.ItemManager;
	import cn.sevencool.sangocraft.data.symbols.ItemsManager;
	import cn.sevencool.sangocraft.data.symbols.SoundManager;
	import cn.sevencool.sangocraft.web.ui.barracks.mediator.BarracksMediator;
	import cn.sevencool.sangocraft.web.ui.battleField.mediator.BattleFieldMediator;
	import cn.sevencool.sangocraft.web.ui.beginnersGuide.mediator.BeginnersGuideMediator;
	import cn.sevencool.sangocraft.web.ui.formation.mediator.FormationMediator;
	import cn.sevencool.sangocraft.web.ui.grandCouncil.mediator.GrandCouncilMediator;
	import cn.sevencool.sangocraft.web.ui.loading.mediator.LoadingMediator;
	import cn.sevencool.sangocraft.web.ui.login.mediator.LoginMediator;
	import cn.sevencool.sangocraft.web.ui.mainPanel.mediator.BasicInforMediator;
	import cn.sevencool.sangocraft.web.ui.mainPanel.mediator.MainPanelMediator;
	import cn.sevencool.sangocraft.web.ui.militaryOffice.mediator.MilitaryOfficMediator;
	import cn.sevencool.sangocraft.web.ui.reinforce.mediator.ReinforceMediator;
	import cn.sevencool.sangocraft.web.ui.screen.mediator.ScreenMediator;
	import cn.sevencool.sangocraft.web.ui.sell.mediator.SellMediator;
	import cn.sevencool.sangocraft.web.ui.skillEffect.mediator.SkillEffectMediator;
	import cn.sevencool.sangocraft.web.ui.socialRelative.mediator.SocialRelativeMediator;
	import cn.sevencool.sangocraft.web.ui.strengthen.mediator.StrengthenMediator;
	import cn.sevencool.sangocraft.web.ui.upgrade.mediator.UpGradeMediator;
	
	
	/**
	 * project: sangocraft_Web
	 * @class: ManagerOperator
	 * @author: zhouyan
	 * @usage: manager初始化
	 * @since: 2013-8-15
	 * @modified: 2013-8-15
	 * @modifier: zhouyan 
	 */
	public class ManagerOperator extends ModuleManager
	{
		public function ManagerOperator()
		{
		}
		
		/**
		 * 初始注册的manager
		 * 初始一些需要初始的 
		 * 
		 */		
		override protected function init():void
		{
			initial() ;
			registerModule(MilitaryOfficeManager, MilitaryOfficMediator);
			registerModule(ScreenManager, ScreenMediator);
			registerModule(MainPanelManager, MainPanelMediator);
			registerModule(GrandCouncilManager, GrandCouncilMediator);
			registerModule(SocalRelativeManager,SocialRelativeMediator);
			registerModule(BattleFieldManager,BattleFieldMediator);
			registerModule(BarracksManager,BarracksMediator);
			registerModule(FormationManager,FormationMediator);
			registerModule(SellManager,SellMediator);
			registerModule(StrengtheningManager,StrengthenMediator);
			registerModule(UpgradeManager,UpGradeMediator);
			registerModule(BasicInforManager,BasicInforMediator);
			registerModule(ReinforceManager,ReinforceMediator);
			registerModule(SkillEffectManager,SkillEffectMediator);
//            registerModule(GameGuideManager,GameGuideMediator);
            registerModule(LoadingPanelManager,LoadingMediator);
            registerModule(BeginnersGuideManager,BeginnersGuideMediator);
		}
		
		
		/**
		 * 初始需要用到的资料 
		 */		
		private function initial():void
		{
			ItemManager.getInstance() ;
			ItemsManager.getInstance();
			SoundManager.getInstance().initialize() ;
		}
	}
}