package cn.sevencool.sangocraft.web.battle.ai
{
	
	import flash.utils.ByteArray;
	
	import org.oswxf.rpc.util.BinaryUtil;
	
	import sango.fight.CModule;

	public class FightLogical
	{
		private static var fightData:ByteArray;
		
		/**
		 * 加载数据库文件 
		 * @param $name
		 * @param $data
		 * @return 
		 * 
		 */		
		static	public function ReadLoadData($name:String,$data:ByteArray):Boolean
		{
			var dhh1_ptr:int =CModule.malloc($data.length);
			CModule.writeBytes(dhh1_ptr,$data.length,$data);
			var 	readloaddata_result:Boolean  = as3api.ReadLoadData($name,dhh1_ptr,$data.length);
			CModule.free(dhh1_ptr);
			return readloaddata_result;
		}
		/**
		 * 加载地图 
		 * @param $mapid
		 * @param $data
		 * @return 
		 * 
		 */		
		static	public function ReadLoadFightMapData($mapid:int,$data:ByteArray):Boolean
		{
			$data.position = 0;
			var map_ptr:int =CModule.malloc($data.length);
			CModule.writeBytes(map_ptr,$data.length,$data);
			var map_result:Boolean = as3api.ReadLoadFightMapData($mapid,map_ptr,$data.length);
			CModule.free(map_ptr);
			return map_result;
		}
		
		/**
		 * 获取buff播放顺序
		 * @param $nOnlyID
		 * @param $szOutBuff
		 * @return 
		 * 
		 */		
		static public function GetFightOperateData($nOnlyID:int):ByteArray
		{
			const CHAR_SET:String = 'gbk' ;
			var bytes:ByteArray = new ByteArray() ;
			var str1:String = '';
			var fightData:String = as3api.GetFightOperateData($nOnlyID,str1) ;
//			bytes.writeMultiByte(str,CHAR_SET);
			var arr:Array = fightData.split('_');
			for(var i:int = 0 ; i <arr.length-1 ; i++)
			{
				var fight:int = int(arr[i]);
				BinaryUtil.writeInt(fight , bytes) ;
			}
			return bytes;
		}
		
		/**
		 * 
		 * @param $data
		 * @return 
		 * 
		 */		
		static	public function FightDataPrepare($data:ByteArray = null,isNew:Boolean = false):String
		{
			
//			CModule.startAsync();
			
			if($data)
			{
				fightData = $data;
			}
			var str:String = '';
			fightData.position = 0;
			var input_ptr:int = CModule.malloc(fightData.length);
			CModule.writeBytes(input_ptr,fightData.length,fightData);
			as3api.FightDataPrepare(input_ptr,str,isNew);
			CModule.free(input_ptr);
			
			var result:String = ""
			for(var i:int=0;i<60;i++)
			{
				var reStr:String = GetFightData();
				if( reStr == " " || reStr == "")
				{
					break;
				}
				
				result += reStr + "\n";
			}
			
			return result;
		}
		
		static	public function GetFightData():String
		{
			var str:String = '';
			var result:String = as3api.GetFightData(str);
			return result;
		}
		/**
		 * 全军出击 
		 * @param $nOnlyID 玩家id
		 * @param $nFrameIndex 施法回合数
		 * @return  
		 * 
		 */		
		static	public function AllArmyHitOutOperate($nOnlyID:int,$nFrameIndex:int):Boolean
		{
			return as3api.AllArmyHitOutOperate($nOnlyID,$nFrameIndex);
		}
		
		/**
		 * 使用技能 
		 * @param $nOnlyID 玩家id
		 * @param $nGeneralID 武将id
		 * @param $nFrameIndex 施法回合数
		 * @param $nSkillID 技能id
		 * @return 
		 * 
		 */		
		static	public function UseSkillOperate($nOnlyID:int, $nGeneralID:int, $nFrameIndex:int, $nSkillID:int):Boolean
		{
			trace($nFrameIndex);
			return as3api.UseSkillOperate($nOnlyID, $nGeneralID, $nFrameIndex, $nSkillID);
		}
		
		
		
	}
}