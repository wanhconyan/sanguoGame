package cn.sevencool.sangocraft.web.symbols
{
	/**
	 * project: sangocraft_Web
	 * @class: IUIView
	 * @author: zhouyan
	 * @usage: 面板接口
	 * @since: 2013-8-15
	 * @modified: 2013-8-15
	 * @modifier: zhouyan 
	 */
	public interface IUIView
	{
		function get type():int;
		function get usableCount():int;
		function get needExclude():Boolean;
		function get needTween():Boolean;
	}
}