package cn.sevencool.sangocraft.web.net
{
	import cn.sevencool.sangocraft.web.events.SCEvent;
	
	import flash.events.Event;
	import flash.utils.ByteArray;

	public class WXFLoaderEvent extends SCEvent
	{
		
		public static const WXFLOADER_TASK_COMPLETE:String ='wxfloader_task_complete';
		
		public static const WXFLOADER_TASKLIST_COMPLETE:String = 'WXFLOADER_TASKLIST_COMPLETE';
		
		public function WXFLoaderEvent($type:String , $taskid:String)
		{
			super($type);
			taskid = $taskid;
		}
		
		public var taskid:String ='-1';
		public var loadData:ByteArray = null;
		public var url:String = null;
	}
}