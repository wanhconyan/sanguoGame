package cn.sevencool.sangocraft.web.symbols.itemsBox
{
	import cn.sevencool.sangocraft.data.symbols.CommonData;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	public class CoolDownSticker extends Sprite{
		
		/**冷却容器*/
		private var cdchest:Sprite = new Sprite ;
		
		/**冷却时间画布*/
		private var cdcanvas:Sprite = new Sprite ;
		
		/**文本显示*/
		private var textDisplay:TextField = new TextField ;
		
		private static var tmf:TextFormat = null ;
		
		private var _timer:Timer = new Timer(100) ;
		
		private var _rectw:Number = 0 ;
		private var _recth:Number = 0 ;
		
		public function CoolDownSticker(rectw:Number , recth:Number , color:uint = 0x0000ff){
			super();
			
			if(tmf == null){
				tmf = new TextFormat ;
				tmf.color = 0xffffff ;
				tmf.size = 10 ;
			}
			
			_rectw = rectw ;
			_recth = recth ;
			
			addChild(cdchest) ;
			
			cdchest.addChild(cdcanvas);
			cdcanvas.x = _rectw / 2 ;
			cdcanvas.y = _recth / 2 ;
			
			var rectcanvas:Shape = new Shape ;
			rectcanvas.graphics.beginFill(color , .7) ;
			rectcanvas.graphics.drawRect(1 , 1 , _rectw - 2 , _recth - 2) ;
			rectcanvas.graphics.endFill() ;
			
			cdchest.addChild(rectcanvas) ;
			
			rectcanvas.mask = cdcanvas ;
			
			textDisplay.selectable = textDisplay.mouseEnabled = false ;
			textDisplay.autoSize = TextFieldAutoSize.LEFT ;
			
			cdchest.addChild(textDisplay) ;
			
			cdchest.visible = false;
		}
		
		private var time:Number;
		private var myBoolean:Boolean = true;
		private var _timeCount:Number
		
		private var count:Number = 0;
		/**timeCount 为该总时间*/
		public function cd(timeCount:Number=0,count:Number = 0,b:Boolean = true):void
		{
			_timeCount = timeCount;
			time = timeCount * 1000 + CommonData.serverTime;
			this.count = count;
			this.myBoolean = b;
			if(timeCount <= 0)
			{
				return;
			}
			
			if(_timer){
				_timer.reset();
				_timer.removeEventListener(TimerEvent.TIMER , tickHandler) ;
			}
			
			_timer.start();
			_timer.addEventListener(TimerEvent.TIMER , tickHandler) ;
			//_timer.addEventListener(TimerEvent.TIMER_COMPLETE , tickCompleteHandler) ;
			
			cdchest.visible = true ;
		}
		
		/**是否cd中*/
		public function get iscd():Boolean{
			return _timer && _timer.running ;
		}
		
		public function stop():void{
			cdchest.visible = false;
			if(_timer){
				_timer.reset();
				_timer.removeEventListener(TimerEvent.TIMER , tickHandler) ;
				//_timer.removeEventListener(TimerEvent.TIMER_COMPLETE , tickCompleteHandler) ;
				//_timer = null ;
			}
			textDisplay.text = '' ;
			cdcanvas.graphics.clear() ;
		}
		
		private function tickCompleteHandler(evt:TimerEvent):void{
			stop() ;
		}
		
		private function tickHandler(evt:TimerEvent):void{
			var percent:Number = (time - CommonData.serverTime) / 1000;
			var t:Number;
			if(this.count >= _timeCount && this.myBoolean)
			{
				t = (this.count - percent) / this.count;
			}
			else
			{
				t = (_timeCount - percent) / _timeCount;
			}
			if(percent <=0)
			{//> 1 || t<=0){
				stop() ;
				return ;
			}
			
			textDisplay.text = percent.toFixed(1);
			textDisplay.setTextFormat(tmf) ;
			textDisplay.x = _rectw / 2 - textDisplay.width / 2 ; 
			textDisplay.y = _recth / 2 - textDisplay.height / 2 ;

			var r:Number = 30 ;
			cdcanvas.graphics.clear();
			cdcanvas.graphics.beginFill(0x0000ee ,1) ;
			cdcanvas.graphics.moveTo(0 , 0) ;
			
			var p:Point = Point.polar(r ,t * Math.PI * 2) ;
			cdcanvas.graphics.lineTo(p.x,p.y);
			
			GraphicsDraw.drawRadian(cdcanvas.graphics , 0 , 0 ,t  * Math.PI * 2  , Math.PI * 2,r) ;
			cdcanvas.graphics.lineTo(0 , 0) ;
			cdcanvas.graphics.endFill() ;
			//trace(t)
		}
		
		
	}
}