package com.control.view
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class AbstractAuxiliary extends Sprite
	{
		/**
		 * 纵向辅助线
		 */		
		protected var colAuxiliaryLine:AuxiliaryLine  = null;
		
		/**
		 * 横向辅助线 
		 */		
		protected var rowAuxiliaryLine:AuxiliaryLine = null;
		public function AbstractAuxiliary()
		{
			super();
			colAuxiliaryLine = new AuxiliaryLine();
			rowAuxiliaryLine = new AuxiliaryLine();
			colAuxiliaryLine.mouseChildren = false;
			colAuxiliaryLine.mouseEnabled = false;
			rowAuxiliaryLine.mouseChildren = false;
			rowAuxiliaryLine.mouseEnabled = false;
			this.addChild(colAuxiliaryLine);
			this.addChild(rowAuxiliaryLine);
			AuxiliaryLineManager.ins().addAuxiliAryLine(colAuxiliaryLine);
			AuxiliaryLineManager.ins().addAuxiliAryLine(rowAuxiliaryLine);
			this.addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
			this.addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
		}
		
		protected function onMouseOut(event:MouseEvent):void
		{
			this.showColAuxiliary(false);
			this.showRowAuxiliary(false);
		}
		
		protected function onMouseOver(event:MouseEvent):void
		{
			this.showColAuxiliary(true);
			this.showRowAuxiliary(true);
		}
		
		override public function set width(value:Number):void
		{
			super.width = value ;
			update();
		}
		
		override public function set height(value:Number):void
		{
			super.height = value ;
			update();
		}
		
		private function update():void
		{
			colAuxiliaryLine.width = this.width ;
			colAuxiliaryLine.x = x ;
			colAuxiliaryLine.y = this.height /2 + this.y;
			rowAuxiliaryLine.height = this.height;
			rowAuxiliaryLine.x = this.width/2 + this.x;
			rowAuxiliaryLine.y = y;
		}
		
		protected function showColAuxiliary($bo:Boolean):void
		{
			colAuxiliaryLine.visible = $bo ;
		}
		
		protected function showRowAuxiliary($bo:Boolean):void
		{
			rowAuxiliaryLine.visible = $bo ;
		}
	}
}