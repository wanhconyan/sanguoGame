package cn.sevencool.sangocraft.web.symbols.tooltip
{
	public class ToolTipTextformat
	{
		public static var defaultColor:uint = 0x000000;
		private var textformatStr:String = "";
		public function ToolTipTextformat()
		{
		}
		
		public function start():void
		{
			textformatStr = "";
		}
		
		public function addLine(str:String,color:uint=0xffffff , size:uint = 12):void
		{
			if(isNaN(color))
			{
				color = defaultColor;
			}
			textformatStr += '<P><FONT size="'+ size + 
				'" COLOR="#' + color.toString(16) + 
				'">' + str + '</FONT></P>';
		}
		
		public function addSpan(str:String , color:uint = 0xffffff , size:uint = 12 ):void{
			if(isNaN(color)){
				color = defaultColor;
			}
			
			textformatStr += '<SPAN><FONT size="'+ size + 
				'" COLOR="#' + color.toString(16) + 
				'">' + str + '</FONT></SPAN>';
		}
		
		/**换行*/
		public function newline():void{
			textformatStr += '<BR />' ;
		}
		
		public function addTab(...arg):void
		{
			textformatStr += '<TEXTFORMAT TABSTOPS="';
			for(var i:int=0;i<arg.length;i++)
			{
				if(i!=0)
				{
					textformatStr += ",";
				}
				var tapWidth:Number = Number(arg[i]);
				textformatStr += tapWidth.toString();
			}
			
			textformatStr +='">';
		}
		
		public function addTapLine(color:uint=NaN,...arg):void
		{
			if(isNaN(color))
			{
				color = defaultColor;
			}
			textformatStr += '<P><FONT COLOR="#' + color.toString(16) + '">';
			for(var i:int=0;i<arg.length;i++)
			{
				if(i!=0)
				{
					textformatStr += "<TAB/>";
				}
				var str:String = String(arg[i]);
				textformatStr += str;
			}	
			textformatStr += '</FONT></P>';
			
		}
		
		public function endTab():void
		{
			textformatStr += '</TEXTFORMAT>';
		}
		
		public function addImgLine(src:String,str:String=""):void
		{
			textformatStr +='<P><IMG hspace="0" vspace="0" src="' + src + '"/>';
			textformatStr += str;
			textformatStr +='</P>';
		}
		
		public function toHTMLString():String
		{
			return textformatStr;
		}
	}
}