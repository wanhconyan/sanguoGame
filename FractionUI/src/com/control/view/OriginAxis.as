package com.control.view
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import spark.core.SpriteVisualElement;
	
	public class OriginAxis extends SpriteVisualElement
	{
		private var sp:Sprite;
		
		private var angleOne:Shape;
		private var angleTwo:Shape;
		private var textField:TextField;
		public function OriginAxis()
		{
			super();
			init()
		}
		
		private function init():void
		{
			sp = new Sprite();
			textField = new TextField();
			angleOne = new Shape();
			angleTwo = new Shape();
			this.addChild(angleOne);
			this.addChild(angleTwo);
			this.addChild(sp);
			textField.text ="(0,0)";
			var textFormat:TextFormat = new TextFormat();
			textFormat.size = 12;
			textField.defaultTextFormat =  textFormat;
			textField.x = 0 ;
			textField.y = 0;
			textField.selectable = false;
			this.addChild(textField);
			this.addEventListener(Event.ADDED,onAdd);
			this.addEventListener(Event.RESIZE,onResize);
		}
		
		protected function onResize(event:Event):void
		{
			draw(this.parent.width-13,this.parent.height-13);
			this.x = this.parent.width/2 ;
			this.y = this.parent.height/2 ;		
		}
		
		/**
		 * 对象被添加到父类 
		 * @param event
		 */		
		protected function onAdd(event:Event):void
		{
			draw(this.parent.width-13,this.parent.height-13);
			this.x = this.parent.width/2 ;
			this.y = this.parent.height/2 ;
		}
		
		
		/**
		 * 绘画 
		 * @param width
		 * @param height
		 */
		private function draw(w:Number = 100,h:Number = 100):void
		{
			sp.graphics.clear();
			angleOne.graphics.clear();
			angleTwo.graphics.clear();
			
			angleTwo.graphics.beginFill(0x00ff00);
			angleOne.graphics.beginFill(0xff0000);
//			angleOne.graphics.moveTo(-3,0);
//			angleOne.graphics.lineTo(3,0);
//			angleOne.graphics.lineTo(0,6*Math.cos(Math.PI/6));
//			angleOne.graphics.lineTo(-3,0);
			
			angleOne.graphics.moveTo(0,-6*Math.cos(Math.PI/6));
			angleOne.graphics.lineTo(3,0);
			angleOne.graphics.lineTo(-3,0);
			
			angleTwo.graphics.moveTo(0,3);
			angleTwo.graphics.lineTo(0,-3);
			angleTwo.graphics.lineTo(6*Math.cos(Math.PI/6),0);
			angleTwo.graphics.lineTo(3,0);
			
			sp.graphics.lineStyle(1,0x000000,1);
			sp.graphics.moveTo(-w/2,0);
			sp.graphics.lineTo(w/2,0);
			sp.graphics.moveTo(0,-h/2);
			sp.graphics.lineTo(0,h/2);
			sp.graphics.endFill();
			sp.y = 3;
			angleTwo.x = w/2;
			angleTwo.y = 3 ;
			
			angleOne.x = 0 ;
			angleOne.y = -h/2 + 3;
		
		}
	}
}