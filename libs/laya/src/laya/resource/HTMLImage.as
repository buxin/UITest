package laya.resource {
	import laya.net.URL;
	import laya.utils.Browser;
	
	/**
	 * @private
	 * <p> <code>HTMLImage</code> 用于创建 HTML Image 元素。</p>
	 * <p>请使用 <code>HTMLImage.create()<code>获取新实例，不要直接使用 <code>new HTMLImage<code> 。</p>
	 */
	public class HTMLImage extends Bitmap {
		
		/**
		 * <p><b>不支持canvas了，所以备Texture2D替换了</p>
		 * <p>创建一个 <code>HTMLImage</code> 实例。</p>
		 * <p>请使用 <code>HTMLImage.create()<code>创建实例，不要直接使用 <code>new HTMLImage<code> 。</p>
		 *
		 */
		public static var create:Function = function(width:int, height:int, format:int):Bitmap {
			var tex:Texture2D = new Texture2D(width, height,format, false, false);
			tex.wrapModeU = BaseTexture.WARPMODE_CLAMP;
			tex.wrapModeV = BaseTexture.WARPMODE_CLAMP;
			return tex;
		}
	}
}