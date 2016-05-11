package cn.sevencool.sangocraft.web.symbols
{
	import cn.sevencool.sangocraft.data.symbols.CommonData;
	import cn.sevencool.sangocraft.data.symbols.material.MaterialManager;
	import cn.sevencool.sangocraft.data.symbols.material.factory.ImageFactory;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	import spark.core.SpriteVisualElement;

	/**
	 * project:sangocraftWeb
	 * @class: FigureDisplay
	 * @author: zhouyan
	 * @usage: 数字显示
	 * @since: 2012-9-11
	 * @modified: 2012-9-11
	 * @modifier: zhouyan 
	 */
	public class FigureDisplay extends SpriteVisualElement
	{
		/**
		 * 图片层 
		 */		
		private var _picSP:Sprite = null;
		
		public function FigureDisplay()
		{
			super();
			_bitDic = new Dictionary();
			_picSP = new Sprite();
			this.addChild(_picSP);
		}
		
		private var _bitDic:Dictionary = null;
		
		/**
		 * @private
		 */
		public function set maxMedian(value:int ):void
		{
			for(var i:int = 0 ; i < value ; i++)
			{
				_bitDic[i] = new Bitmap();
			}
		}

		/**
		 *显示数字 
		 */
		public function get figure():int
		{
			return _figure;
		}

		private var _figure:int = -1;
		
		/**
		 * 数字显示
		 * @param $figure 显示的数字
		 * @param $materialKeys  加载的Key
		 * @param $gap 间距
		 * @param $direction 方向（默认1从左往右/-1从右往左）
		 * 
		 */		
		public function figureHandler($figure:String,$materialKeys:String,$gap:int = 25,$direction:int=1):void
		{
			_figure = int($figure);
			while(_picSP.numChildren > 0)
			{
				_picSP.removeChildAt(0);
			}
			var figureArr:Array = $figure.split('');
			for(var m:int = 0; m < figureArr.length ;m++)
			{
				var num:String = '';
				if($direction == -1)
				{
					num = figureArr[figureArr.length-1-m];
				}else{
					num = figureArr[m];
				}
				var bmp:Bitmap = _bitDic[m];
				if(!bmp)
				{
					throw new Error('Not declared sufficient bitmap digits!');
				}
				var mcUrl:String = MaterialManager.getInstance().getURL($materialKeys,num);
				bmp = ImageFactory.getBitmap(mcUrl ,bmp);
				bmp.x = $gap*m*$direction;
				bmp.y = 10 ;
				_picSP.addChild(bmp);//暂时先屏蔽手写数字
			}
		}
		
	}
}