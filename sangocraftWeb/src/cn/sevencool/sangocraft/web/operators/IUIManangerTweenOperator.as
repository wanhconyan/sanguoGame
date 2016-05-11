package cn.sevencool.sangocraft.web.operators
{
	import cn.sevencool.sangocraft.web.symbols.BasePanel;
	
	import mx.core.IVisualElement;

	public interface IUIManangerTweenOperator
	{
		function showPanel($panel:IVisualElement):void;
		function hidePanel($panel:IVisualElement,$visualElement:IVisualElement):void;
	}
}