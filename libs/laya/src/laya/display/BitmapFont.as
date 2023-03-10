package laya.display {
	import laya.maths.Rectangle;
	import laya.net.Loader;
	import laya.resource.Texture;
	import laya.resource.Texture2D;
	import laya.utils.Handler;
	
	/**
	 * <code>BitmapFont</code> 是位图字体类，用于定义位图字体信息。
	 * 字体制作及使用方法，请参考文章
	 * @see http://ldc2.layabox.com/doc/?nav=ch-js-1-2-5
	 */
	public class BitmapFont {
		private var _texture:Texture;
		private var _fontCharDic:Object = {};
		private var _fontWidthMap:Object = {};
		private var _complete:Handler;
		private var _path:String;
		private var _maxWidth:Number = 0;
		private var _spaceWidth:Number = 10;
		private var _padding:Array;
		
		/**当前位图字体字号，使用时，如果字号和设置不同，并且autoScaleSize=true，则按照设置字号比率进行缩放显示。*/
		public var fontSize:Number = 12;
		/**表示是否根据实际使用的字体大小缩放位图字体大小。*/
		public var autoScaleSize:Boolean = false;
		/**字符间距（以像素为单位）。*/
		public var letterSpacing:Number = 0;
		
		/**
		 * 通过指定位图字体文件路径，加载位图字体文件，加载完成后会自动解析。
		 * @param	path		位图字体文件的路径。
		 * @param	complete	加载并解析完成的回调。
		 */
		public function loadFont(path:String, complete:Handler):void {
			_path = path;
			_complete = complete;
			
			if (!path || path.indexOf(".fnt") === -1) {
				console.error('Bitmap font configuration information must be a ".fnt" file');
				return;
			}
			Laya.loader.load([{url: path, type: Loader.XML}, {url: path.replace(".fnt", ".png"), type: Loader.IMAGE}], Handler.create(this, _onLoaded));
		}
		
		/**
		 * @private
		 */
		private function _onLoaded():void {
			this.parseFont(Loader.getRes(_path), Loader.getRes(_path.replace(".fnt", ".png")));
			_complete && _complete.run();
		}
		
		/**
		 * 解析字体文件。
		 * @param	xml			字体文件XML。
		 * @param	texture		字体的纹理。
		 */
		public function parseFont(xml:XmlDom, texture:Texture):void {
			if (xml == null || texture == null) return;
			_texture = texture;
			var tX:int = 0;
			var tScale:Number = 1;
			
			var tInfo:* = xml.getElementsByTagName("info");
			if (!tInfo[0].getAttributeNode)
			{
				return parseFont2(xml, texture);
			}
			fontSize = parseInt(tInfo[0].getAttributeNode("size").nodeValue);
			
			var tPadding:String = tInfo[0].getAttributeNode("padding").nodeValue;
			var tPaddingArray:Array = tPadding.split(",");
			_padding = [parseInt(tPaddingArray[0]), parseInt(tPaddingArray[1]), parseInt(tPaddingArray[2]), parseInt(tPaddingArray[3])];
			
			var chars:Array;
			chars = xml.getElementsByTagName("char");
			var i:int = 0;
			for (i = 0; i < chars.length; i++) {
				var tAttribute:* = chars[i];
				var tId:int = parseInt(tAttribute.getAttributeNode("id").nodeValue);
				
				var xOffset:Number = parseInt(tAttribute.getAttributeNode("xoffset").nodeValue) / tScale;
				var yOffset:Number = parseInt(tAttribute.getAttributeNode("yoffset").nodeValue) / tScale;
				var xAdvance:Number = parseInt(tAttribute.getAttributeNode("xadvance").nodeValue) / tScale;
				
				var region:Rectangle = new Rectangle();
				region.x = parseInt(tAttribute.getAttributeNode("x").nodeValue);
				region.y = parseInt(tAttribute.getAttributeNode("y").nodeValue);
				region.width = parseInt(tAttribute.getAttributeNode("width").nodeValue);
				region.height = parseInt(tAttribute.getAttributeNode("height").nodeValue);
				
				var tTexture:Texture = Texture.create((texture as Texture2D), region.x, region.y, region.width, region.height, xOffset, yOffset);
				_maxWidth = Math.max(_maxWidth, xAdvance + letterSpacing);
				_fontCharDic[tId] = tTexture;
				_fontWidthMap[tId] = xAdvance;
			}
		}
		
		/**
		 * 解析字体文件。
		 * @param	xml			字体文件XML。
		 * @param	texture		字体的纹理。
		 */
		public function parseFont2(xml:XmlDom, texture:Texture):void {
			if (xml == null || texture == null) return;
			_texture = texture;
			var tX:int = 0;
			var tScale:Number = 1;
			
			var tInfo:* = xml.getElementsByTagName("info");
			fontSize = parseInt(tInfo[0].attributes["size"].nodeValue);
			
			var tPadding:String = tInfo[0].attributes["padding"].nodeValue;
			var tPaddingArray:Array = tPadding.split(",");
			_padding = [parseInt(tPaddingArray[0]), parseInt(tPaddingArray[1]), parseInt(tPaddingArray[2]), parseInt(tPaddingArray[3])];
			
			var chars:Array = xml.getElementsByTagName("char");
			var i:int = 0;
			for (i = 0; i < chars.length; i++) {
				var tAttribute:Array = chars[i].attributes;
				var tId:int = parseInt(tAttribute["id"].nodeValue);
				
				var xOffset:Number = parseInt(tAttribute["xoffset"].nodeValue) / tScale;
				var yOffset:Number = parseInt(tAttribute["yoffset"].nodeValue) / tScale;
				
				var xAdvance:Number = parseInt(tAttribute["xadvance"].nodeValue) / tScale;
				
				var region:Rectangle = new Rectangle();
				region.x = parseInt(tAttribute["x"].nodeValue);
				region.y = parseInt(tAttribute["y"].nodeValue);
				region.width = parseInt(tAttribute["width"].nodeValue);
				region.height = parseInt(tAttribute["height"].nodeValue);
				
				var tTexture:Texture = Texture.create((texture as Texture2D), region.x, region.y, region.width, region.height, xOffset, yOffset);
				_maxWidth = Math.max(_maxWidth, xAdvance + letterSpacing);
				_fontCharDic[tId] = tTexture;
				_fontWidthMap[tId] = xAdvance;
			}
		}
		/**
		 * 获取指定字符的字体纹理对象。
		 * @param	char 字符。
		 * @return 指定的字体纹理对象。
		 */
		public function getCharTexture(char:String):Texture {
			return _fontCharDic[char.charCodeAt(0)];
		}
		
		/**
		 * 销毁位图字体，调用Text.unregisterBitmapFont 时，默认会销毁。
		 */
		public function destroy():void {
			if (_texture) {
				for (var p:* in _fontCharDic) {
					var tTexture:Texture = _fontCharDic[p];
					if (tTexture) tTexture.destroy();
				}
				_texture.destroy();
				_fontCharDic = null;
				_fontWidthMap = null;
				_texture = null;
				_complete = null;
				_padding = null;
			}
		}
		
		/**
		 * 设置空格的宽（如果字体库有空格，这里就可以不用设置了）。
		 * @param	spaceWidth 宽度，单位为像素。
		 */
		public function setSpaceWidth(spaceWidth:Number):void {
			_spaceWidth = spaceWidth;
		}
		
		/**
		 * 获取指定字符的宽度。
		 * @param	char 字符。
		 * @return  宽度。
		 */
		public function getCharWidth(char:String):Number {
			var code:Number = char.charCodeAt(0);
			if (_fontWidthMap[code]) return _fontWidthMap[code] + letterSpacing;
			if (char === " ") return _spaceWidth + letterSpacing;
			return 0;
		}
		
		/**
		 * 获取指定文本内容的宽度。
		 * @param	text 文本内容。
		 * @return  宽度。
		 */
		public function getTextWidth(text:String):Number {
			var tWidth:Number = 0;
			for (var i:int = 0, n:int = text.length; i < n; i++) {
				tWidth += getCharWidth(text.charAt(i));
			}
			return tWidth;
		}
		
		/**
		 * 获取最大字符宽度。
		 */
		public function getMaxWidth():Number {
			return _maxWidth;
		}
		
		/**
		 * 获取最大字符高度。
		 */
		public function getMaxHeight():Number {
			return fontSize;
		}
		
		/**
		 * @private
		 * 将指定的文本绘制到指定的显示对象上。
		 */
		public function _drawText(text:String, sprite:Sprite, drawX:Number, drawY:Number, align:String, width:Number):void {
			var tWidth:int = getTextWidth(text);
			var tTexture:Texture;
			var dx:Number = 0;
			align === "center" && (dx = (width - tWidth) / 2);
			align === "right" && (dx = (width - tWidth));
			var tx:Number = 0;
			for (var i:int = 0, n:int = text.length; i < n; i++) {
				tTexture = getCharTexture(text.charAt(i));
				if (tTexture) {
					sprite.graphics.drawImage(tTexture, drawX + tx + dx, drawY);
					tx += getCharWidth(text.charAt(i));
				}
			}
		}
	}
}