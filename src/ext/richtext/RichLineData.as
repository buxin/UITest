/**
 * Created by Client on 2017/6/8.
 */
package ext.richtext {
import laya.display.Sprite;
import laya.display.Text;
import laya.ui.HBox;
import laya.ui.Label;
import laya.display.Text;
import ext.text.TextFormat;
import laya.events.Event;
public class RichLineData extends HBox {
    /**剩余的解析文本**/
    private var _remainText:Object;

    private var _isFull:Boolean;

    private var _maxWidth:int;

    public var _NoticeTID:int;

    public function RichLineData() {
        align = HBox.BOTTOM;
    }

    public function get isFull():Boolean {
        return _isFull;
    }

    public function set isFull(value:Boolean):void {
        _isFull = value;
    }

    public function get RemainText():Object
    {
        return _remainText;
    }

    public function set RemainText(value:Object):void
    {
		if (value is String) {
			// 设置value是XML。 value == ""  返回 true
			var bool:Boolean = value == "";
			var bool2:Boolean = value == "\n";
			var bool3:Boolean = value == "<br>";
			if (bool || bool2 || bool3) 
				value = null;
		}
		
        _remainText = value;
    }

    public function get NoticeTID():uint {
        return _NoticeTID;
    }

    public function set NoticeTID(value:uint):void {
        _NoticeTID = value
    }

    public function addHBox(dis:Sprite):void {
        addChild(dis);
		height = measureHeight;
    }

    public function get SurplusWidth():int {
        return width > 0 ? (maxWidth - width) : maxWidth;
    }

    public function ParseStr(lineText:String, format:TextFormat):void {
        var surplusWidth:int = SurplusWidth;
        if (surplusWidth < format.size) {
            RemainText = lineText;
            isFull = true;
            return;
        }

        if(TempTextField == null) initTemp();
        TempTextField.width = surplusWidth;
        TempTextField.height = 1;

        // TempTextField.defaultTexFormat = format;

        TempTextField.htmlText = lineText;
        TempTextField.x = 500;
        TempTextField.y = 100;

        RemainText = null;
        if (TempTextField.numLines > 1) {
            isFull = true;
            var firstLine:String = TempTextField.getLineText(0);
            var textIndex:int = getLineText(firstLine, lineText);

            //TempTextField.defaultTextFormat = format;
            TempTextField.htmlText = firstLine;

            RemainText = lineText.slice(textIndex);
            lineText = firstLine;
        }

        if (lineText != "") {
            var label:Label = new Label();
            label.size = format.size;
            label.color = format.color;
            label.font = format.font;
            label.isHtml = true;
            label.text = lineText;
            label.stroke = "0";
	        label.cacheAsBitmap = true;
            var mouse:Boolean = lineText.indexOf("event") > -1;
            label.mouseChildren = mouse;
            label.mouseEnabled = mouse;
            if(mouse) label.addEventListener("link", onLink);
            label.commitMeasure();
            addHBox(label);
        }
    }

    private static function onLink(e:Event):void {
        var json:Object = JSON.parse(e.text);
        //ChatLinkButton.onClickHandler(json);
        trace("需要实现");
    }

    private static function getLineText(firstLine:String, lineText:String):int {
        return firstLine.length;
    }

    private static var TempTextField:Text;
    private static function initTemp():void {
        TempTextField = new Text();
        TempTextField.autoSize = "left";
        TempTextField.wordWrap = true;
    }

    public function get maxWidth():int {
        return _maxWidth;
    }

    public function set maxWidth(value:int):void {
        _maxWidth = value;
    }
}
}
