/**
 * Created by ChengXu1 on 2016/11/1.
 */
package chat{
import laya.display.Sprite;
import laya.events.Event;
import laya.events.KeyboardEvent;
import laya.maths.Rectangle;
import laya.events.Keyboard;
import laya.ui.TextInput;
import utils.ClassUtils;
public class InputImageText extends Sprite
{
    private const Space:int = 4;
    private const PLACEHOLDER:String = String.fromCharCode(12288);

    private var maxWidth:int;

    public var textField:TextField;
    private var mcLayer:Sprite;
    private var dataList:Vector.<Express>;

    private var begin:int = 0;
    private var end:int = 0;
    private var scrollV:int = 0;
    private var keyCode:uint = 0;

    private var defaultFormat:TextFormat;
    private var placeFormat:TextFormat;
    private var _mask:Sprite;

    public function InputImageText(textField:TextInput)
    {
        this.textField = textField;
        maxWidth = 320 - Space;

        textField.restrict = "^" + PLACEHOLDER;

        textField.x = Space;
        textField.y = Space;
        this.addChild(textField);

        _mask = new Sprite();
        _mask.graphics.beginFill(0);
        _mask.graphics.drawRect(0, 0, textField.width, textField.height);
        _mask.graphics.endFill();
        this.addChild(_mask);

        mcLayer = new Sprite();
        mcLayer.mask = _mask;
        mcLayer.x = Space;
        mcLayer.y = Space;
        this.addChild(mcLayer);
        dataList = new Vector.<Express>();

        textField.addEventListener(Event.SCROLL, onTextScroll);
        textField.addEventListener(Event.CHANGE, afterChange);
    }

    private function onTextScroll(e:Event):void
    {
        if(textField.scrollV != scrollV)
        {
            scrollV = textField.scrollV;
            layout();
        }
    }

    private function afterChange(e:Event = null):void
    {
        var $begin:int = begin;
        if(begin == end)
        {
            if(keyCode == Keyboard.BACKSPACE)
            {
                delExpress(begin - 1);
                $begin = (begin > 0) ? begin - 1 : 0;
            }
            else if(keyCode == Keyboard.DELETE)
            {
                delExpress(begin);
            }
        }
        else
        {
            for(var i:int = begin; i < end; i++)
            {
                delExpress(i);
            }
        }
        updateExpressIndex($begin);
        layout();
        keyCode = 0;
    }

    private function layout():void
    {
        if(textField.length == 0)
        {
            clear();
            return;
        }
        textField.setTextFormat(defaultFormat, 0, textField.length);
        var textStr:String = textField.text;
        for(var i:int = 0; i < textStr.length; i++)
        {
            var char:String = textStr.charAt(i);
            if(char == PLACEHOLDER)
            {
                textField.setTextFormat(placeFormat, i, i + 1);
            }
        }
        while(mcLayer.numChildren > 0)
        {
            mcLayer.removeChildAt(0);
        }
        for each(var data:Express in dataList)
        {
            var rect:Rectangle = textField.getCharBoundaries(data.index);
            if(rect != null)
            {
                data.displayObject.x = rect.x + 2;
                data.displayObject.y = rect.y - 6;
                mcLayer.addChild(data.displayObject);
            }
        }

        _mask.graphics.clear();
        _mask.graphics.beginFill(0);
        _mask.graphics.drawRect(0, 0, textField.width, textField.height + Space);
        _mask.graphics.endFill();
    }

    public function insertExpression(sign:String):void
    {
        if(textField.length >= textField.maxChars)
        {
            return;
        }
        begin = textField.selectionBeginIndex;
        end = textField.selectionEndIndex;
        for(var i:int = begin; i < end; i++)
        {
            delExpress(i);
        }
        textField.replaceText(begin, end, PLACEHOLDER);

        var $i:int = -1;
        for(i = 0; i < dataList.length; i++)
        {
            var data:Express = dataList[i];
            if(data.index >= begin)
            {
                $i = i;
                break;
            }
        }
        var displayObject:Sprite = getDisplayObject(sign);
        if($i == -1) {
            dataList.push(new Express(begin, sign, displayObject));
        } else {
            dataList.splice($i, 0, new Express(begin, sign, displayObject));
        }

        updateExpressIndex(begin);
        layout();
        textField.setSelection(begin + 1, begin + 1);
    }

    private function updateExpressIndex($begin:int):void
    {
        var $i:int = -1;
        for(var i:int = 0; i < dataList.length; i++)
        {
            if(dataList[i].index >= $begin)
            {
                $i = i;
                break;
            }
        }
        if($i != -1)
        {
            var textStr:String = textField.text;
            for(i = $begin; i < textStr.length; i++)
            {
                if(textStr.charAt(i) == PLACEHOLDER)
                {
                    dataList[$i++].index = i;
                }
            }
        }
    }

    private function getExpress(index:int):Express
    {
        for each(var data:Express in dataList)
        {
            if(data.index == index)
            {
                return data;
            }
        }
        return null;
    }

    private function delExpress(index:int):void
    {
        for(var i:int = 0; i < dataList.length; i++)
        {
            var data:Express = dataList[i];
            if(data.index == index)
            {
                dataList.splice(i, 1);
                if(mcLayer.contains(data.displayObject))
                {
                    mcLayer.removeChild(data.displayObject);
                }
                return;
            }
        }
    }

    private function getDisplayObject(sign:String):MovieClip
    {
        sign = sign.replace("$", "f");
        var $_class:Class = ClassUtils.getClass(sign) as Class;
        var $_item:MovieClip = new $_class();
        $_item.mouseChildren = false;
        $_item.mouseEnabled = false;
        return $_item;
    }

    public function get srcContent():String
    {
        var charArr:Array = [];
        var textStr:String = textField.text;
        for(var i:int = 0; i < textStr.length; i++)
        {
            var char:String = textStr.charAt(i);
            if(char == PLACEHOLDER)
            {
                var data:Express = getExpress(i);
                if(data) charArr.push(data.sign);
            }
            else
            {
                charArr.push(char);
            }
        }
        return charArr.join("");
    }

    public function set srcContent(content:String):void
    {
        clear();
        var reg:RegExp = /\$\d{2}/gi;
        var signArr:Array = content.match(reg);
        content = content.replace(reg, PLACEHOLDER);

        // if(content.length > textField.maxChars)
       // {
           // content = content.substr(0, textField.maxChars);
        //}

        for(var i:int = 0; i < content.length; i++)
        {
            var char:String = content.charAt(i);
            if(char == PLACEHOLDER) {
                var sign:String = signArr.shift() as String;
                dataList.push(new Express(i, sign, getDisplayObject(sign)));
            }
        }

        //
        textField.htmlText = content;
        if(textField.multiline == false && maxWidth < textField.width)
        {
            textField.multiline = true;
            textField.wordWrap = true;
            textField.width = maxWidth;
        }

        layout();
    }

    public function clear():void
    {
        textField.htmlText = "";
        begin = end = scrollV = keyCode = 0;
        dataList = new Vector.<Express>();
        if(mcLayer != null)
        {
            mcLayer.removeChildren();
        }
    }

    public function dispose():void {
        textField.removeEventListener(Event.SCROLL, onTextScroll);
        textField.removeEventListener(Event.CHANGE, afterChange);
        dataList = null;
        this.removeChildren();
    }

}
}
/*===============================================*/

import laya.display.Sprite;

class Express
{
    public var index:int;
    public var sign:String;
    public var displayObject:Sprite;

    public function Express(index:int, sign:String, displayObject:Sprite)
    {
        this.index = index;
        this.sign = sign;
        this.displayObject = displayObject;
    }
}
