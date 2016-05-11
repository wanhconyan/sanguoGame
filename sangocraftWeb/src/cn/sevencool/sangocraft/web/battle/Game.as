package cn.sevencool.sangocraft.web.battle
{
	import cn.sevencool.sangocraft.data.symbols.CommonData;
	import cn.sevencool.sangocraft.data.symbols.material.MaterialKeys;
	import cn.sevencool.sangocraft.data.symbols.material.MaterialManager;
	import cn.sevencool.sangocraft.data.symbols.material.xmlUtil.XMLCompressUtil;
	
	import com.sevencool.iamsanguo.core.battle.AmmoFactory;
	import com.sevencool.iamsanguo.core.battle.BattleContainer;
	import com.sevencool.iamsanguo.core.battle.UnitCreater;
	import com.sevencool.rtslogic.Battlefield;
	
	import flash.geom.Point;
	
	import starling.display.Sprite;
	import starling.display.Stage;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	/**
	 * 战斗容器 
	 * @author Focefiger
	 * 
	 */	
	public class Game extends Sprite
	{
		
		
		private var onDrag:Boolean = true;
		private var lastMousePos:Point = new Point();
		private var battleContainer:BattleContainer;
		
		public function Game()
		{
			
			battleContainer = new BattleContainer();
			this.addChild(battleContainer);
			battleContainer.addEventListener(TouchEvent.TOUCH,containerTouchHandler);
			
			Battlefield.getActivityBattlefield().battleContainer = battleContainer;
			Battlefield.getActivityBattlefield().ammoFactory = new AmmoFactory();
			
			var unitConfig:XML = XMLCompressUtil.uncompress(MaterialManager.getInstance().getContentByKey(MaterialKeys.UNIT_CONFIG));
			var formationConfig:XML = XMLCompressUtil.uncompress(MaterialManager.getInstance().getContentByKey(MaterialKeys.FORMATION_CONFIG));
			UnitCreater.config = unitConfig;
			UnitCreater.formationConfig = formationConfig;
			
			this.addEventListener(Event.ENTER_FRAME,enterFrameHandler);
		}
		
		/**
		 * 拖动战场事件 
		 * @param e
		 * 
		 */		
		private function containerTouchHandler(e:TouchEvent):void
		{
			var touch:Touch  = e.getTouch(battleContainer);
			
			if(touch!=null && CommonData.dragMap){
				
				switch(touch.phase)
				{
					case TouchPhase.BEGAN:
						onDrag = true;
						checkMouse(touch.globalX,touch.globalY);
						break;
					case TouchPhase.ENDED:
						onDrag = false;
						checkMouse(touch.globalX,touch.globalY);
						break;
					case TouchPhase.MOVED:
						if(onDrag)
						{
							var movePos:Point = checkMouse(touch.globalX,touch.globalY);
							battleContainer.x += movePos.x;
							battleContainer.y += movePos.y;
							containerCheck();
						}
						break;
					
				}
			}
			
		}
		
		private function containerCheck():void
		{
			if(battleContainer.x > BattleContainer.BG_OFFSET_X)
			{
				battleContainer.x = BattleContainer.BG_OFFSET_X;
			}
			if(battleContainer.y > BattleContainer.BG_OFFSET_Y)
			{
				battleContainer.y = BattleContainer.BG_OFFSET_Y;
			}
			
			if(battleContainer.x + battleContainer.BGWidth + BattleContainer.BG_OFFSET_X <  (this.parent as Stage).stageWidth)
			{
				battleContainer.x = (this.parent as Stage).stageWidth - battleContainer.BGWidth - BattleContainer.BG_OFFSET_X;
			}
			
			if(battleContainer.y + battleContainer.BGHeight + BattleContainer.BG_OFFSET_Y < (this.parent as Stage).stageHeight)
			{
				battleContainer.y = (this.parent as Stage).stageHeight - battleContainer.BGHeight - BattleContainer.BG_OFFSET_Y;
			}
		}
		
		public function moveViewPort(_x:Number,_y:Number):void
		{
			if(_x < 0 || _y < 0)
			{
				return;
			}
			if(_x < 1 && _y < 1)
			{
				moveToViewPortByPix(_x *battleContainer.BGWidth,_y *battleContainer.BGHeight);
			}
			else
			{
				moveToViewPortByPix(_x,_y);
			}
		}
		
		private function moveToViewPortByPix(_x:int,_y:int):void
		{
			battleContainer.x = -_x + (this.parent as Stage).stageWidth / 2;
			battleContainer.y = - _y + (this.parent as Stage).stageHeight / 2;
			containerCheck();
		}
		
		public function get viewPortX():int
		{
			return (this.parent as Stage).stageWidth / 2 - battleContainer.x;
		}
		
		public function get viewPortY():int
		{
			return (this.parent as Stage).stageHeight / 2 - battleContainer.y;
		}
		
		private function checkMouse(touchX:Number,touchY:Number):Point
		{
			var currentPos:Point = new Point(touchX,touchY);
			var rePoint:Point = currentPos.subtract(lastMousePos);
			lastMousePos = currentPos;
			return rePoint;
		}
		/**
		 * 刷新事件 
		 * @param event
		 * 
		 */		
		private function enterFrameHandler(event:Event):void
		{
			if(Battlefield.getActivityBattlefield() && Battlefield.getActivityBattlefield().map)
			{
				Battlefield.getActivityBattlefield().rander();
			}
		}
	}
}