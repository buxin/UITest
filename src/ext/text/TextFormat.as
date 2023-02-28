package ext.text {
	
	import laya.ui.Label;
	import laya.utils.Utils;

	public class TextFormat
	{
		public var font:String;
		public var fontSize:int;
		public var color:String;
		public var bold:Boolean;
		public var italic:Boolean;
		public var underline:Boolean;
		private var _align:String;
		private var _letterSpacing:Number;
		private var _leading:int;
		
		public function TextFormat(font:String = "Arial",fontSize:int = 12,color:Number = 0x000000,bold:Boolean = false,italic:Boolean = false,underline:Boolean = false,url:String = "",target:String = "",align:String = "left",leftMargin:Object = null,rightMargin:Object = null,indent:Object = null,leading:Object = null):void
		{
			this.font = font;
			this.fontSize = fontSize;
			color && (this.color = Utils.toHexColor(color));
			this.bold = bold;
			this.italic = italic;
			this.underline = underline;
			this._align = align;
			this._letterSpacing = 0;
		}

		public function set align(value:String):void
		{
			this._align = value;
		}
		public function get align():String
		{
			return this._align;
		}

		public function set size(value:Number):void
		{
			this.fontSize = value;
		}

		public function set letterSpacing(value:Number):void
		{
			this._letterSpacing = value;
		}
		public function get letterSpacing():Number
		{
			return this._letterSpacing;
		}
		public function set leading(val:int):void
		{
			this.letterSpacing = val;
		}
		public function get leading():Number
		{
			return this.letterSpacing;
		}
	}
}