package laya.webgl.submit {
	import laya.maths.Matrix;
	import laya.resource.Context;
	import laya.webgl.shader.d2.ShaderDefines2D;
	import laya.webgl.shader.d2.value.Value2D;
	import laya.webgl.utils.CONST3D2D;
	import laya.webgl.utils.Mesh2D;
	import laya.webgl.utils.RenderState2D;
	
	/**
	 * cache as normal 模式下的生成的canvas的渲染。
	 */
	
	public class SubmitCanvas extends Submit {
		
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		public static function create(canvas:*, alpha:Number, filters:Array):SubmitCanvas {
			var o:SubmitCanvas = (!POOL._length) ? (new SubmitCanvas()) : POOL[--POOL._length];
			o.canv = canvas;
			o._ref = 1;
			o._numEle = 0;
			var v:Value2D = o.shaderValue;
			v.alpha = alpha;			
			v.defines.setValue(0);
			filters && filters.length && v.setFilters(filters);
			return o;
		}
		
		public var _matrix:Matrix = new Matrix();		// 用来计算当前的世界矩阵
		public var canv:Context;
		public var _matrix4:Array = CONST3D2D.defaultMatrix4.concat();
		
		public function SubmitCanvas() {
			super(Submit.TYPE_2D);
			shaderValue = new Value2D(0, 0);
		}
		
		public override function renderSubmit():int {
			// 下面主要是为了给canvas设置矩阵。因为canvas保存的是没有偏移的。
			var preAlpha:Number = RenderState2D.worldAlpha;
			var preMatrix4:Array = RenderState2D.worldMatrix4;
			var preMatrix:Matrix = RenderState2D.worldMatrix;
			
			var preFilters:Array = RenderState2D.worldFilters;
			var preWorldShaderDefines:ShaderDefines2D = RenderState2D.worldShaderDefines;
			
			var v:Value2D = this.shaderValue;
			var m:Matrix = this._matrix;
			var m4:Array = _matrix4;
			var mout:Matrix = Matrix.TEMP;
			Matrix.mul(m, preMatrix, mout);
			m4[0] = mout.a;
			m4[1] = mout.b;
			m4[4] = mout.c;
			m4[5] = mout.d;
			m4[12] = mout.tx;
			m4[13] = mout.ty;
			
			RenderState2D.worldMatrix = mout.clone();
			RenderState2D.worldMatrix4 = m4;
			RenderState2D.worldAlpha = RenderState2D.worldAlpha * v.alpha;
			if (v.filters && v.filters.length) {
				RenderState2D.worldFilters = v.filters;
				RenderState2D.worldShaderDefines = v.defines;
			}
			canv['flushsubmit']();
			RenderState2D.worldAlpha = preAlpha;
			RenderState2D.worldMatrix4 = preMatrix4;
			RenderState2D.worldMatrix.destroy();
			RenderState2D.worldMatrix = preMatrix;
			
			RenderState2D.worldFilters = preFilters;
			RenderState2D.worldShaderDefines = preWorldShaderDefines;
			return 1;
		}
		
		public override function releaseRender():void {
			if( (--this._ref) <1)
			{
				var cache:* = POOL;
				//_vb = null;
				_mesh = null;
				cache[cache._length++] = this;
			}
		}
		
		//TODO:coverage
		public override function clone(context:Context,mesh:Mesh2D,pos:int):ISubmit
		{
			return null;
		}
		
		//TODO:coverage
		public override function getRenderType():int {
			return Submit.TYPE_CANVAS;
		}
		
		private static var POOL:* =[];/*[STATIC SAFE]*/ {POOL._length = 0};
	}

}