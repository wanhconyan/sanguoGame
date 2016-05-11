package cn.sevencool.sangocraft.web.ui.beginnersGuide.mediator
{
	import cn.sevencool.sangocraft.data.events.BeginnersGuideEvent;
	import cn.sevencool.sangocraft.data.manager.beginnersGuide.mediator.BaseBeginnersGuideMediator;
	import cn.sevencool.sangocraft.data.manager.beginnersGuide.mediator.IUIOperatableBeginnersGuideMediator;
	import cn.sevencool.sangocraft.data.model.RSGuideQuest;
	import cn.sevencool.sangocraft.data.symbols.SystemModelLocator;
	import cn.sevencool.sangocraft.web.events.UIEvent;
	import cn.sevencool.sangocraft.web.manager.UIMananger;
	import cn.sevencool.sangocraft.web.skin.button.ReturnBtnSkin;
	import cn.sevencool.sangocraft.web.symbols.BasePanel;
	import cn.sevencool.sangocraft.web.ui.battleField.view.ExpeditionInfoPanel;
	import cn.sevencool.sangocraft.web.ui.battleField.view.ExpeditionPanel;
	import cn.sevencool.sangocraft.web.ui.battleField.view.PreBattlePanel;
	import cn.sevencool.sangocraft.web.ui.beginnersGuide.view.BeginnersGuide;
	import cn.sevencool.sangocraft.web.ui.reinforce.view.ReinforcePanel;
	import cn.sevencool.sangocraft.web.ui.screen.view.ScreenPanel;
	
	import com.greensock.TweenLite;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filters.GlowFilter;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;
	
	import mx.controls.Text;
	import mx.events.FlexEvent;
	
	import spark.effects.Animate;
	import spark.effects.animation.MotionPath;
	import spark.effects.animation.SimpleMotionPath;
	
	public class BeginnersGuideMediator extends BaseBeginnersGuideMediator  implements IUIOperatableBeginnersGuideMediator
	{
		public function BeginnersGuideMediator()
		{
			super();
		}
		
		
		/**
		 * 新手引导界面 
		 */		
		private static var _beginnersGuide:BeginnersGuide = null;
		
		/**
		 * 已经初始化的面板字典 
		 */		
		private var _panelDic:Dictionary = null;
		
		/**
		 * 文本框 Dic
		 */		
		private var _textDic:Dictionary = null ;
		
		
		/**
		 *  
		 */
		public var BEGINNERSGUIDEEVENTDISPATCHER:EventDispatcher=new EventDispatcher() 

		override public function startup():void
		{
			_panelDic =  new Dictionary();
			_beginnersGuide = UIMananger.getInstance().getUIObj(BeginnersGuide) as BeginnersGuide;
			_beginnersGuide.addEventListener(UIEvent.BASE_UI_REPOSITION,portInfoAddHandler);
			_beginnersGuide.addEventListener(Event.REMOVED_FROM_STAGE,portInfoAddHandler);
			BEGINNERSGUIDEEVENTDISPATCHER.addEventListener(BeginnersGuideEvent.NEXTGUIDE , nextGuideHandler);
			BEGINNERSGUIDEEVENTDISPATCHER.addEventListener(BeginnersGuideEvent.USESKILL , nextGuideHandler);
			BEGINNERSGUIDEEVENTDISPATCHER.addEventListener(BeginnersGuideEvent.HIDEGUIDE , hideGuideHandler);
			SystemModelLocator.getInstance().addEventListener(Event.RESIZE , screenResizeHandler);
			_textDic = new Dictionary();
			var screenPanel:ScreenPanel = UIMananger.getInstance().getUIObj(ScreenPanel) as ScreenPanel ;
			registerScreenPanelToGuideMediator(screenPanel.gp_functionBtn);
			registerPanelToGuideMediator(ScreenPanel);
			registerPanelToGuideMediator(ExpeditionPanel);
			registerPanelToGuideMediator(ExpeditionInfoPanel);
			registerPanelToGuideMediator(ReinforcePanel);
			registerPanelToGuideMediator(PreBattlePanel);
		}
		
		/**
		 * 关闭面板 
		 * @param event
		 * 
		 */		
		protected function hideGuideHandler(event:Event):void
		{
			if(_beginnersGuide&&_beginnersGuide.stage)
			{
				UIMananger.getInstance().hide(_beginnersGuide);
			}
		}
		
		/**
		 * 执行指定的新手引导xml片段 
		 * @param $xml
		 * 
		 */
		override protected function executeGuideXmlItem($xml:XML):void
		{
			if(!$xml )
			{
				throw new Error("$xml not exist");
				return ;
			}
			var panelID:int = parseInt($xml.attribute("panelID").toString());
			var guidePanel:BasePanel = _panelDic[panelID] ;
			
			if(panelID == -1 )
			{
				throw new Error("some error with panelID guidePanel");
			}
			
			if(guidePanel==null)
			{
				trace("panelID= ",panelID,"is needed");
				return;
			}
			
			if(!guidePanel.stage)
				return;
			
			
			_beginnersGuide = UIMananger.getInstance().show(BeginnersGuide) as BeginnersGuide;
			var offsetX:Number = Number($xml.attribute("offsetX").toString());
			var offsetY:Number  = Number($xml.attribute("offsetY").toString());
			var arrowRotation:Number  = Number($xml.attribute("arrowRotation").toString());
			var arrowmoveSpeed:Number  = Number($xml.attribute("arrowmoveSpeed").toString());
			var endX:Number = guidePanel.x + offsetX;
			var endY:Number = guidePanel.y + offsetY;
			TweenLite.to(_beginnersGuide.arrow,arrowmoveSpeed/1000,{x:endX,y:endY,rotation:arrowRotation});
			trace("BeginnersGuideMediator.displayGuideXml($xml)"+endX +'*'+endY);
			
			textSetup($xml,guidePanel);
			frameSetup($xml,guidePanel);
		
		}
		
	
		private function frameSetup($xml:XML,$guidpanel:BasePanel):void
		{
			//==========================================外框设置=========================================
			_beginnersGuide.freamSp.graphics.clear();
			var framesXML:XML = $xml.frames[0];
			if(framesXML)
			{
				for each(var fXML:XML in framesXML.children())
				{
					var fDir:int = parseInt(fXML.attribute("direction").toString());
					var hint_X:Number = Number(fXML.attribute("hint_X").toString());
					var hint_Y:Number = Number(fXML.attribute("hint_Y").toString());
					var hint_W:Number = Number(fXML.attribute("hint_W").toString());
					var hint_H:Number = Number(fXML.attribute("hint_H").toString());
					_beginnersGuide.freamSp.graphics.lineStyle(2,0xFFF000,1);
					_beginnersGuide.freamSp.graphics.drawRoundRect(
						hint_X + $guidpanel.x,
						hint_Y + $guidpanel.y,
						hint_W,
						hint_H,
						1);  
				}
				_beginnersGuide.freamSp.graphics.endFill();
			}
		}
		/**
		 *文本设置 
		 * @parm $xml xml item
		 * @parm $guidePanel panel to guide
		 */
		private function textSetup($xml:XML,$guidePanel:BasePanel):void
		{
			//==========================================文本设置=========================================
		
			_beginnersGuide.lblSp.removeAllElements();
			var descriptionsXML:XML = $xml.descriptions[0];
			if(descriptionsXML)
			{
				var i:int = 0 ;
				for each(var desXML:XML in descriptionsXML.children())
				{
					var text_X:Number = Number(desXML.attribute("text_X").toString());
					var text_Y:Number = Number(desXML.attribute("text_Y").toString());
					if(!_textDic[i])
					{
						var txt:Text = new Text();
						txt.selectable = false ;
						txt.setStyle('color',0xEE1515);
						txt.setStyle('fontSize',15);
						txt.filters = [new GlowFilter(0x000000, 100, 2, 2, 5, 1, false, false)]
						_textDic[i] = txt;
					}
					_textDic[i].htmlText = desXML.attribute("txt").toString();
					_textDic[i].x = $guidePanel.x + text_X ;
					_textDic[i].y = $guidePanel.y + text_Y ; 
					_beginnersGuide.lblSp.addElement(_textDic[i]);
					i++;
				}
			}
		}
		
		private function screenResizeHandler($evt:Event):void
		{
			super.excuteCurrentXMLItem();
		}
		
//		private function removedFromStageHandler($evt:Event):void
//		{
//			super.refreshguidequestinfo();
//		}
		
		
		private function portInfoAddHandler($evt:UIEvent):void
		{
			_beginnersGuide.y = _beginnersGuide.x = 0 ;
		}
		
		
		protected function nextGuideHandler($evt:BeginnersGuideEvent):void
		{
			super.executeNextXMLItem();
		}
		
		
		internal function registerScreenPanelToGuideMediator($class:BasePanel):void
		{
			$class.addEventListener(Event.ADDED_TO_STAGE ,addedToStageHadler);
		}
		
		internal function registerPanelToGuideMediator($class:Class):void
		{
			var panel:BasePanel = UIMananger.getInstance().getUIObj($class) as BasePanel ;
			panel.addEventListener(Event.ADDED_TO_STAGE ,addedToStageHadler);
		}
		
		
		protected function addedToStageHadler($evt:Event):void
		{
			var ceratPanel:BasePanel = $evt.target as BasePanel;
			
			if(!ceratPanel.initialized)
			{
				flash.utils.setTimeout(creationPanelCompleteHandle,100,ceratPanel);
				return;
			}
			
			super.excuteCurrentXMLItem();
		}
		
		
		internal function creationPanelCompleteHandle($panel:BasePanel ):void
		{
			if(!$panel.initialized)
			{
				flash.utils.setTimeout(creationPanelCompleteHandle,100,$panel);
				return;
			}
			var panelID:int =  $panel.panelID ;
			_panelDic[panelID] = $panel;
			super.excuteCurrentXMLItem();
		}
	}
}