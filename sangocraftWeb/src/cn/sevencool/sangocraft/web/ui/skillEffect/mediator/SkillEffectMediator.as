package cn.sevencool.sangocraft.web.ui.skillEffect.mediator
{
	import cn.sevencool.sangocraft.data.manager.skillEffect.mediator.BaseSkillEffectMediator;
	import cn.sevencool.sangocraft.data.manager.utils.MediatorUtil;
	import cn.sevencool.sangocraft.web.manager.UIMananger;
	import cn.sevencool.sangocraft.web.ui.screen.mediator.ScreenMediator;
	import cn.sevencool.sangocraft.web.ui.skillEffect.view.SkillEffectPanel;
	
	import com.sevencool.rtslogic.Battlefield;
	import com.sevencool.rtslogic.ai.teamai.battle.event.SkillEvent;
	import com.sevencool.rtslogic.team.Team;
	
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	public class SkillEffectMediator extends BaseSkillEffectMediator
	{
		/**
		 * 移动镜头事件计时器
		 * */
		private var _timer:Timer = new Timer(50);
		
		/**
		 * 当前镜头位置
		 * */
		private var _viewPos:Point = null;
		
		/**
		 * 目标镜头位置
		 * */
		private var _desPos:Point = null;
		
		/**
		 * 屏幕mediator
		 * */
		private var screenMediator:ScreenMediator =null;
		
		/**
		 * 初始位置
		 * */
		private var startPos:Point = null;
		
		/**
		 * 移动向量3
		 * */
		private var moveVector:Point = null;
		public function SkillEffectMediator()
		{
			super();
		}
		
		/**
		 * 技能特效 面板
		 * */
		private var _skillEffectPanel:SkillEffectPanel = null;
		
		/**
		 * 取得面板  
		 * 给面板set 一个mediatorUI 从而可以使面板抓到他的mediator
		 * */
		override public function startup():void
		{
			_skillEffectPanel = UIMananger.getInstance().getUIObj(SkillEffectPanel) as SkillEffectPanel;
			_skillEffectPanel.mediatorUI = this;
			_timer.addEventListener(TimerEvent.TIMER,onTimer);
		}
		
		
		/**
		 * 重写
		 * */
		override public function AbtainSkill(e:SkillEvent):void
		{
			_skillEffectPanel = UIMananger.getInstance().getUIObj(SkillEffectPanel) as SkillEffectPanel
			_skillEffectPanel.currentState = e.campID == 1? "army":"enemy";
			Battlefield.getActivityBattlefield().pause();
			UIMananger.getInstance().show(SkillEffectPanel) ;
			_skillEffectPanel.skillEvent = e;
			
			 screenMediator = MediatorUtil.getMediatorByInterface(ScreenMediator) as ScreenMediator;
			 startPos = _viewPos = new Point(screenMediator.battleRoot.viewPortX,screenMediator.battleRoot.viewPortY);
			
			
			for each(var team:Team in	Battlefield.getActivityBattlefield().teams)
			{
				if(team.id == e.teamID)
				{
					_desPos = new Point(team.x,team.y)
					break;	
				}
			}
			
			moveVector = new Point((_desPos.x - startPos.x)/10,(_desPos.y - startPos.y)/10)
				
			_timer.reset();
			_timer.start();
			
		}
		
		/**
		 * 时间计时器监听
		 * */
		private function onTimer(e:TimerEvent):void
		{
			
			 startPos.x +=moveVector.x;
			 startPos.y +=moveVector.y;
				
			screenMediator.battleRoot.moveViewPort(startPos.x,startPos.y);
			
			if(_timer.currentCount == 10)
			{
				_timer.stop();
				    
			}
		}
	}
}