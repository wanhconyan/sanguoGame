package  com.core.xmlHelper
{
	
	import com.core.vo.fraction.FractionNode;
	import com.core.vo.fraction.FractionVO;
	
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	public class XmlCreateManager extends EventDispatcher
	{
		private static var _instance:XmlCreateManager ;
		
		private var _formationDic:Dictionary = null;
		public function XmlCreateManager()
		{
			_formationDic = new Dictionary();
		}
		
		public static function getInstance():XmlCreateManager
		{
			if(!_instance)
			{
				_instance = new XmlCreateManager();
			}
			return _instance;
		}  
		
		
		/**
		 * 将vo转化成xml
		 * */
		public function analysisVOToXml($fractions:FractionVO):XML
		{
			var questArr:Array = [];
			
			var fractionNodeXml:XML;
			var xml:XML =
				<fractionConfig>
				</fractionConfig>;
			var fractionsXML:XML =<fractions>
				</fractions>;  
			fractionsXML.@id = $fractions.fractionID ;
			fractionsXML.@fractionName = $fractions.fractionName ;
			for each(var fraction:FractionNode in $fractions.nodes)
			{
				fractionNodeXml = new XML(<fractionNode/>);
				
				fractionNodeXml.@yNode = fraction.yNode;
				fractionNodeXml.@xNode = fraction.xNode;
				fractionsXML.appendChild(fractionNodeXml);
			} 
			xml.appendChild(fractionsXML)
			return xml;
		}
		
		
		public function getFormationByID($formationID:int,$xml:XML = null):FractionVO
		{
			var fractions:XMLList = $xml.fractions;
			for each(var xmlList:XML in fractions)
			{
				if(xmlList.@id == $formationID)
				{
					return translationXmlToVO(xmlList);
				}
			}
			return null;
		}	
		
		
		/**
		 * 将xml转化成vo
		 * */
		public function translationXmlToVO($xml:XML):FractionVO
		{
			var xml:XML = $xml ;
			var fractionVO:FractionVO = null ;
			var fractions:XMLList = xml.fractionNode;
			var len:int  = fractions.length();
			fractionVO = new FractionVO();
			fractionVO.fractionName = $xml.@fractionName;
			fractionVO.fractionID = $xml.@id;
			fractionVO.nodes = new Vector.<FractionNode>();
			var node:FractionNode =  null;
			for(var i:int = 0 ; i < len ; i ++)
			{
				node = new FractionNode();
				var questXML:XML = fractions[i] ;
				node.xNode = questXML.@xNode;
				node.yNode = questXML.@yNode;
				fractionVO.nodes.push(node); ;
			}
			return fractionVO ;
		}
	}
}