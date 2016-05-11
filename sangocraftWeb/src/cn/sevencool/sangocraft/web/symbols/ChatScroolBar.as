package cn.sevencool.sangocraft.web.symbols
{
	import cn.sevencool.sangocraft.web.skin.button.ChatThumbBtnSkin;
	import cn.sevencool.sangocraft.web.skin.button.ChatTrackBtnSkin;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	import spark.components.Button;
	import spark.skins.spark.ScrollBarDownButtonSkin;
	import spark.skins.spark.ScrollBarUpButtonSkin;
	
	public class ChatScroolBar extends UIComponent implements IEventDispatcher
	{
		private var _preBtn:Button ;
		
		private var _nextBtn:Button;
		
		private var _preShow:Boolean;
		
		private var _nextShow:Boolean;
		
		private var _trackBtn:Button;
		
		private var _thumBtn:Button ;
		
		
		private var _viewPort:TextField;
		
		
		private var _width:int;
		
		private var _height:int ;
		
		private var _nowLine:int
		
		private var _totalLine:int ;
		
		private var _maxLine:int ;
		
		private var _thumPos:Number;
		
		private var _isWheel:Boolean;
		
		/**
		 * 记录textField滚动的当前行数
		 * */
		private var nowScrollV:int = 0;
		
		private var _total:int = 0;
		
		private var _isShow:Boolean = false;
		
		public function ChatScroolBar()
		{
			
			this.addEventListener(FlexEvent.CREATION_COMPLETE,onCreateComplete);
		
		}
		
		
		private function onCreateComplete(e:FlexEvent):void
		{
		
			preBtn = new Button();
			
			
			nextBtn = new Button();
			
			trackBtn = new Button();
			
			thumBtn = new Button()
				
			this.addChild(preBtn);
		
			this.addChild(nextBtn);
			
			this.addChild(trackBtn);
			
			this.addChild(thumBtn);
			
			if(isShow)
			{
				preBtn.height = nextBtn.height = 11;
			
			}else
			{
				preBtn.height = nextBtn.height = 0;
				preBtn.visible = nextBtn.visible = false;
				
			}
				
		  	trackBtn.width	= preBtn.width = nextBtn.width = thumBtn.width = 7;
			
			trackBtn.y = preBtn.height;
			
			trackBtn.height = this.height - 2 * preBtn.height ;
						
			preBtn.x = nextBtn.x = trackBtn.x = thumBtn.x = 0;
			
			preBtn.y = 0;
			
			nextBtn.y = this.height  - preBtn.height;
			
			thumBtn.visible = false;
			
			//设置按钮样式
			preBtn.setStyle("skinClass",spark.skins.spark.ScrollBarUpButtonSkin);
			nextBtn.setStyle("skinClass",spark.skins.spark.ScrollBarDownButtonSkin)
			trackBtn.setStyle("skinClass",ChatTrackBtnSkin)
//			thumBtn.setStyle("skinClass",ScrollBarThumbSkin )
			thumBtn.setStyle("skinClass",ChatThumbBtnSkin )
			
			
			addEventListener(MouseEvent.CLICK,onMouseClick);
			addEventListener(MouseEvent.MOUSE_WHEEL,onMouseWheel);
			addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
			addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
		
		
		}
		
		/**
		 * 鼠标点击按钮触发事件
		 * 监听操作的按钮
		 * */
		protected function onMouseClick(e:MouseEvent):void
		{
			switch(e.target)
			{
				case preBtn:
					
					nowLine --
					
					break;
				case  nextBtn:
					
					nowLine ++
					
					break;
				case  trackBtn:
					
					if(total)
					{
						
						var point:Point = new Point(mouseX,mouseY);
						
						nowLine = int(point.y/(trackBtn.height)*total)
					
					}else
					{
					}
					
					break;
				case thumBtn:
					
					
					break;
				default :
					break;
			}	
		}
		
		/**
		 * 监听鼠标移动事件
		 * 当当前的目标是thumBtn时 移动thumBtn的位置
		 * */
		protected function onMouseMove(e:MouseEvent):void
		{
			
			var nowPos:int = 0 ;
			var point:Point = new Point(mouseX,mouseY);
			
			nowPos = point.y - oldMouseY + preBtn.height;
			
			
			nowLine = int(nowPos/(trackBtn.height)*total)
		
			
			//thumPos = (nowPos < preBtn.height ? preBtn.height : nowPos) > (this.height - nextBtn.height) ? (this.height - nextBtn.height): preBtn.height;
			
			oldMouseY =  point.y
			
			
		}
		
		/**
		 * 监听鼠标滚轮滚动事件 
		 * 更改thumBtn的位置
		 * */
		private function onMouseWheel(e:MouseEvent):void
		{
			
			if(!isWheel)
			{
				return ;
			}
			
			if(e.target is TextField)
			{
				nowLine = viewPort.scrollV;
			}
			if(e.delta>0)
			{
				if(thumBtn.y ==  preBtn.height  )
				{
					
				}else
				{
					nowLine--
				}
			}else
			{
				if(thumBtn.y == this.height -   preBtn.height)
				{
					
				}else
				{
					nowLine ++;
				}
			}
			
		}
		
		internal var oldMouseY:Number = 0
		
		/**
		 * 监听当前鼠标所在的按钮
		 * */
		private function onMouseOver(e:MouseEvent):void
		{
			if(e.target is Button)	
			{
				var point:Point = new Point(mouseX,mouseY);
				
				
				oldMouseY = point.y;
				
				if(thumBtn.hasEventListener(MouseEvent.MOUSE_DOWN))
				{
					thumBtn.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
				}
				thumBtn.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			}
		}
		
		/**
		 * 监听对thum使用拖动
		 * */
		private function onMouseDown(e:MouseEvent):void
		{
			thumBtn.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			
		}
		
		/**
		 * 移除对thum的监听
		 * */
		private function onMouseUp(e:MouseEvent):void
		{
			if(thumBtn.hasEventListener(MouseEvent.MOUSE_MOVE))
			{
				thumBtn.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			}
		}
		
		/**
		 * 更新显示列表
		 * @param $width 滚动条宽度
		 * @param $heigh 滚动条长度
		 * @param $preShow 上按钮是否可见
		 * @param $nextShow 下按钮是否可见
		 * @param $total 总行数
		 * @param $max textField显示的最大行数
		 * */
//		protected function updateDisplayList($width:int = 0,$heigth:int =0,$preShow:Boolean = true,$nextShow:Boolean = true,$total:int,$max:int):void
//		{
//			
//			
//			
//			
//		}
		
		/**
		 * 视角框
		 * */
		public function get viewPort():TextField
		{
			return _viewPort;
		}
		
		/**
		 * @private
		 */
		public function set viewPort(value:TextField):void
		{
			_viewPort = value;
			
			_viewPort.addEventListener(MouseEvent.MOUSE_WHEEL,onMouseWheel);
			
			totalLine = viewPort.numLines ;
			
			nowLine = total;
			
		}
		
		/**
		 * 拖动条
		 * */
		public function get thumBtn():Button
		{
			return _thumBtn;
		}
		
		/**
		 * @private
		 */
		public function set thumBtn(value:Button):void
		{
			_thumBtn = value;
		}
		
		/**
		 * 底图移动位置校正
		 * */
		public function get trackBtn():Button
		{
			return _trackBtn;
		}
		
		/**
		 * @private
		 */
		public function set trackBtn(value:Button):void
		{
			_trackBtn = value;
		}
		
		/**
		 * 下一行
		 * */
		public function get nextBtn():Button
		{
			return _nextBtn;
		}
		
		/**
		 * @private
		 */
		public function set nextBtn(value:Button):void
		{
			_nextBtn = value;
		}
		
		/**
		 * 上一行
		 * */
		public function get preBtn():Button
		{
			return _preBtn;
		}
		
		/**
		 * @private
		 */
		public function set preBtn(value:Button):void
		{
			_preBtn = value;
		}
		
		/**
		 * 当前行数
		 * */
		public function get nowLine():int
		{
			return _nowLine;
		}
		
		/**
		 * @private
		 */
		public function set nowLine(value:int):void
		{
			_nowLine = value;
		
			if(_nowLine < 0 )
			{
				_nowLine = 0 ;
				thumBtn.y = preBtn.height;
			}else if(nowLine == total)
			{
				thumBtn.y = this.height - nextBtn.height - thumBtn.height;
			}else
			{
				var avargeLen:Number = (this.height  -  thumBtn.height - 2*preBtn.height )/(total)
				
				thumBtn.y =  avargeLen*nowLine + preBtn.height;
			}
			if(thumBtn.y > this.height - preBtn.height - thumBtn.height)
			{
				thumBtn.y = this.height - preBtn.height - thumBtn.height
			}
			
			
			viewPort.scrollV =  nowLine;
			
			
			
			this.dispatchEvent(new Event("LineChange"))
		}

		/**
		 * 上按钮是否可见
		 * */
		public function get preShow():Boolean
		{
			return _preShow;
		}

		/**
		 * @private
		 */
		public function set preShow(value:Boolean):void
		{
			_preShow = value;
		}

		/**
		 * 下按钮是否可见
		 * */
		public function get nextShow():Boolean
		{
			return _nextShow;
		}

		/**
		 * @private
		 */
		public function set nextShow(value:Boolean):void
		{
			_nextShow = value;
		}

		/**
		 * 当前总行数
		 * */
		private function get totalLine():int
		{
			return _totalLine;
		}

		/**
		 * @private
		 */
		private function set totalLine(value:int):void
		{
			_totalLine = value;
//			updateDisplayList();
			// if this total is bigger than maxLine
			if(totalLine <= maxLine)
			{
				thumBtn.visible = false;
				thumBtn.y = preBtn.height ;
				
				isWheel = false;
			}else
			{
				isWheel = true;
				thumBtn.visible = true;
				
				thumBtn.height = maxLine/totalLine * (this.height - preBtn.height - nextBtn.height)
					
				total = totalLine - maxLine;
					
				if(thumBtn.y > preBtn.height)
				{
					nowLine = nowLine;
				}	
			
			}
		}

		/**
		 * 当前面板的最大行数
		 * */
		public function get maxLine():int
		{
			return _maxLine;
		}

		/**
		 * @private
		 */
		public function set maxLine(value:int):void
		{
			_maxLine = value;
		}

		/**
		 * 拖动按钮位置
		 * */
		public function get thumPos():Number
		{
			return _thumPos;
		}

		/**
		 * @private
		 */
		public function set thumPos(value:Number):void
		{
			_thumPos = value;
			
			thumBtn.y = preBtn.height ;
				
				
			
			thumBtn.y += thumPos ;
			
			
			if(thumBtn.y < preBtn.height)
			{
				thumBtn.y  = preBtn.height;
			}
			
			if(thumBtn.y > this.height - nextBtn.height -  thumBtn.height)
			{
				thumBtn.y = this.height -  nextBtn.height -  thumBtn.height ;
			
			}
		}

		internal function get isWheel():Boolean
		{
			return _isWheel;
		}

		internal function set isWheel(value:Boolean):void
		{
			_isWheel = value;
		}

		/**
		 * 滑块可移动的总行数
		 * */
		public function get total():int
		{
			return _total;
		}

		/**
		 * @private
		 */
		public function set total(value:int):void
		{
			_total = value;
			if(_total<0)
			{
				_total =0;
			}
		}

		public function get isShow():Boolean
		{
			return _isShow;
		}

		public function set isShow(value:Boolean):void
		{
			_isShow = value;
		}

	}
}