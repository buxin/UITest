/**This class is automatically generated by LayaAirIDE, please do not make any modifications. */
package ui {
	import laya.ui.*;
	import laya.display.*;

	public class ChatUI extends Dialog {
		public var channelButton:Button;
		public var coordinateBtn:Button;
		public var chatButton:Button;
		public var btnEnter:Button;
		public var textInput:TextInput;
		public var panelMessage:Panel;

		public static var uiView:Object =/*[STATIC SAFE]*/{"type":"Dialog","props":{"width":681,"height":324},"compId":2,"child":[{"type":"Sprite","props":{"y":300,"x":0,"texture":"comp/ltdt.png"},"compId":4},{"type":"Button","props":{"y":302,"x":22,"var":"channelButton","strokeColors":"0","stateNum":3,"skin":"comp/zhonghe2.png","labelColors":"#dcdbd1,#ffd884,#c49f61","label":"η»Όε"},"compId":3},{"type":"Button","props":{"y":302,"x":0,"var":"coordinateBtn","stateNum":3,"skin":"comp/zhubiao.png"},"compId":5},{"type":"Button","props":{"y":302,"x":611,"var":"chatButton","stateNum":3,"skin":"comp/biaoqing.png"},"compId":6},{"type":"Button","props":{"y":302,"x":633,"var":"btnEnter","stateNum":3,"skin":"comp/an.png","labelColors":"#dcdbd1,#ffd884,#c49f61","label":"ει"},"compId":7},{"type":"TextInput","props":{"y":301,"x":82,"width":530,"var":"textInput"},"compId":8},{"type":"Panel","props":{"width":681,"var":"panelMessage","vScrollBarSkin":"comp/vscroll.png","height":300},"compId":10}],"loadList":["comp/ltdt.png","comp/zhonghe2.png","comp/zhubiao.png","comp/biaoqing.png","comp/an.png","comp/vscroll.png"],"loadList3D":[]};
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);

		}

	}
}