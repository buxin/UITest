/**
 * Created by Client on 2017/6/2.
 */
package ext.richtext {
    import laya.display.Sprite;
    import laya.ui.VBox;
    public class RichText extends VBox {

    private var _maxNum:int;
    private var _maxWidth:int;
    private var _DataArray:Array = [];
    private var _showBg:Boolean = false;//是否显示背景色块

    public function RichText() {
        align = VBox.LEFT;
        space = 4;
    }

    public function set showBg(value:Boolean):void{
        _showBg = value;
    }

    public function set leading(value:int):void {
        this.space = value;
    }

    /**行间距**/
    public function get leading():int {
        return this.space;
    }

    public function get maxWidth():int {
        return _maxWidth;
    }

    public function set maxWidth(value:int):void {
        _maxWidth = value;
    }

    public function get maxNum():int {
        return _maxNum;
    }

    /**最大显示多少行文本**/
    public function set maxNum(value:int):void {
        _maxNum = value;
    }

    public function get DataArray():Array {
        return _DataArray;
    }

    public function set DataArray(value:Array):void {
        if(value != _DataArray) clearText();

	    length = value.length;
        _DataArray = value;

        if(_maxNum > 0) {    // 判断数组是否大于最大数量
            if(length > _maxNum) length = length - _maxNum;
            else length = 0;

            for (i = 0; i < length; i++) {
                var removeLineData:RichLineData = _DataArray.shift() as RichLineData;
                if(removeLineData) {
                    removeLineData.remove();
                }
            }
        }

	    var length:int = _DataArray.length;
        var titleStr:String ;//头字符串
        var ItemObj:*;
        var gColor:Array;
        var getColorArr:Array = [];//头字符串
        var ChatLinkLabel:String;
        for (var i:int = 0; i < length; i++) {
            var lineData:RichLineData = _DataArray[i] as RichLineData;
            if(lineData) {
                if (lineData.parent == null) {
                    addChild(lineData);
                }
                lineData.x = 0;
                lineData.y = i;
                if(_showBg) {
                    for (var j:String in lineData.items) {
                        ItemObj = lineData.items[j];
                        if (ItemObj is Label) {
                            ItemObj.background = true;
                            ItemObj.stroke = "";
                            titleStr = ItemObj.text;
                            ItemObj.text = ItemObj.textField.text;
                            if(j == "0") {
                                gColor = setTextBackGroundColor(titleStr);
                                if(gColor[0] != -1){
                                    getColorArr = gColor;
                                }
                            }
                            ItemObj.color = getColorArr[0];
                            ItemObj.backgroundColor = getColorArr[1];
                        } else {
                            if (ItemObj is ChatLinkButton) {
                                ChatLinkButton(ItemObj).btnLabel.background = true;
                                ChatLinkButton(ItemObj).btnLabel.stroke = "";
                                ChatLinkButton(ItemObj).btnLabel.isHtml = false;

                                if(ItemObj.EventID == ChatCtrl.CheckPlayer){
                                    ChatLinkButton(ItemObj).labelColors = gColor[0]+","+gColor[0]+","+gColor[0];//显示本行头颜色
                                }else if(ItemObj.EventID == ChatCtrl.EquipmentTip){
                                    ChatLinkLabel = ChatLinkButton(ItemObj).label;
                                    ChatLinkButton(ItemObj).labelColors = "0x0012ff,0x0012ff,0x0012ff";
                                }
                                ChatLinkButton(ItemObj).btnLabel.backgroundColor = getColorArr[1];
                            }
                        }
                    }
                }
            }
            else {
                var text:String = _DataArray[i];
                _DataArray.splice(i, 1);
                i--;

                appendText(text);
                length = _DataArray.length;
            }
        }

        callLater(changeItems);
    }

    private function setTextBackGroundColor(str:String):Array{
        var titleStr:String = str;
        var curColor:Array;
        var colorArr:Array = [[0xffff00,0xff0000],[0xffffff,0xc30000],[0xffffff,0xf83eff],[0xffffff,0x0d9bff]];
        //
        if (findTitle(titleStr, "【世界】")) {
            curColor = [0x403200,0xf9f61f];//文本:0x403200,底:0xf9f61f
        } else if (findTitle(titleStr, "【公告】")) {
            curColor = colorArr[0];
        } else if (findTitle(titleStr, "【系统】")) {
            curColor = colorArr[1];
        } else if (findTitle(titleStr, "【传说】")) {
            curColor = colorArr[2];
        } else if (findTitle(titleStr, "【谣传】")) {
            curColor = colorArr[3];
        } else if (findTitle(titleStr, "【综合】")) {
            curColor = [0xffffff,0xc30000];//文本:0xffffff,底:0xc30000
        } else if (findTitle(titleStr, "【队伍】")) {
            curColor = [0x0800af,0xffffff];//文本:0x0800af,底:0xffffff
        } else if (findTitle(titleStr, "【帮派】")) {
            curColor = [0x018716,0xffffff];//文本:0x018716,底:0xffffff
        } else if (findTitle(titleStr, "【附近】")) {
            curColor = [0x403300,0xffffff];//文本:0x403300,底:0xffffff
        } else if (findTitle(titleStr, "【私聊】")) {
            curColor = [0x960094,0xffffff];//文本:0x960094,底:0xffffff
        } else {
            //未设定
            curColor = [-1,-1];
        }
        return curColor;
    }

    private function findTitle(SouceStr:String,findStr:String):Boolean{
        //头字符判断
        var Bool:Boolean = false;
        if(SouceStr != "" && findStr != "") {
            if (SouceStr.substr(0, findStr.length) == findStr) {
                Bool = true;
            }
        }
        return Bool;
    }

    public function appendText(value:String):void {
        var array:Array = RichTextUtil.Parse(value, _format, color, maxWidth);
	    for (var i:int = 0, length:int = array.length; i < length; i++) {
		    _DataArray.push(array[i]);
	    }
    }

    public function clearText():void {
        Debug::Memory {
            App.memoryTracker.makeContainer(this);
        }
        removeChildren();
    }

    public function set text(value:String):void {
        clearText();
        if(_DataArray) _DataArray.length = 0;
        appendText(value);
		DataArray = _DataArray;
    }

    public function drawRect(_x:int,_y:int,_w:int,_h:int,_c:int):Sprite {
        var sp:Sprite = new Sprite();
        sp.graphics.clear();
        sp.graphics.beginFill(_c, alpha);
        sp.graphics.drawRect(_x,_y,_w,_h);
        sp.graphics.endFill();
        return sp;
    }

	override public function dispose():void {
        _format = null;
        clearText();
        _color = null;
		if(_DataArray) _DataArray.length = 0;
		super.dispose();
	}
}
}

