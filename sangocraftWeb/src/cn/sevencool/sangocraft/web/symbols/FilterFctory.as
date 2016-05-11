package cn.sevencool.sangocraft.web.symbols
{
	import flash.filters.BevelFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BitmapFilterType;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.filters.GradientGlowFilter;

	/**
	 * @project 
	 * @class FilterFctory
	 * @author wangfuyuan
	 * @usage 提供一些滤镜
	 * @since 2013-10-23
	 * @modified 2013-10-23
	 * @modifier wangfuyuan
	 */
	public class FilterFctory
	{
		/**
		 * 面板标题的滤镜 
		 * @return 
		 * 
		 */		
		public static var TitleFontFilter:Array = createTitleFontFilter();
		
		/**
		 * 技能名称字体的滤镜 
		 * @return 
		 * 
		 */		
		public static var SkillNameFilter:Array = createSkillNameFilter();
		
		/**
		 * 兵营中按纽字体滤镜
		 * */
		public static var FormationFilter:Array = getFormationFilter();
		
		/**
		 * 战斗场景中的EXP 投影滤镜
		 * */
		public static var ExpShadowFilter:Array = getExpShadowFilter();
		
		/**
		 * 战斗场景中的总兵力 滤镜
		 * */
		public static var AllSoldierFilter:Array = getAllSoldierFilter();
		
		/**
		 * 战斗场景中的敌方军滤镜
		 * */
		public static var EnemyFilter:Array = getEnemyFilter();
		
		/**
		 * 社交中好友数的比例显示
		 * */
		public static var SocialPerFilter:Array = getSocialPerFilter();
		
		/**
		 * 兵营右侧 数量字体叠加滤镜
		 * */
		public static var BarrackNumFilter:Array = getBarrackNumFilter();
		
		
		private static function createTitleFontFilter():Array{
			return [new GlowFilter(0xffffbe,0.25,5,5,5,1,false,false)]
//			return [new GlowFilter(0xffffbe,0.65,5,5,5,1,false,false)]
		}
		
		private static function createSkillNameFilter():Array{
			var gf:GlowFilter = new GlowFilter(0xff3600,0.75,5,5,2,1,false,false);
			var bf:BevelFilter = new BevelFilter(4,90,0xfffacd,1,0xffb6a2,1,5,5,2,1);
			return [gf,bf]
		}
		
		
		private static function getFormationFilter():Array
		{
			return [new GlowFilter(0xdb8600,0.66,10,10,2,BitmapFilterQuality.HIGH,false,false)];
		}
		
		
		private static function getExpShadowFilter():Array
		{
			var df:DropShadowFilter = new DropShadowFilter(4,45,0x150702,1,36,36,5,1,false,false);
			var gf:GradientGlowFilter = new GradientGlowFilter(1,90,[0xd08428,0xfffacd,0xfffacd,0xffe0a9],[0,1,1,1],[0,45,125,245],5,5,2,1,'inner');
			return [df,gf];
		}
		
		
		private static function getAllSoldierFilter():Array
		{
			return [new GlowFilter(0x190202,1,2,2,5,1,false,false)]
		}
		
		
		private static function getEnemyFilter():Array
		{
			return [new GlowFilter(0x100201,1,2,2,5,1,false,false)];
		}
		
		private static function getSocialPerFilter():Array
		{
			return [new GlowFilter(0x2d1d1d,1,1,1,5,1,false,false)];
		}
		
		
		private static function getBarrackNumFilter():Array
		{
			return [new GlowFilter(0x201712,1,2,2,5,1,false,false)];
		}
		
	}
}