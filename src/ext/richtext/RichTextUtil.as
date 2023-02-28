package ext.richtext {
	import ext.text.TextFormat;
	import laya.ui.Label;
	public class RichTextUtil {
	private static var ParseList:Array = [];
	private static var _format:TextFormat;
	private static var _color:Object;
	private static var _maxWidth:int;

	public static function Parse(value:String, format:TextFormat, color:Object, maxWidth:int, NoticeTID:int = 0):Array {
		ParseList.length = 0;
		_format = format;
		_color = color;
		_maxWidth = maxWidth;

		try {
			var valueLength:int = value.length;
			if(valueLength >= 2) {
				var count:int = valueLength - 1;
				var flag:String = value.substr(count);
				if(flag == "\n") value = value.substr(0, count);
			}

			var text:String = replaceString(value, "<br>", "<br></br>");

			var contentXML:XML = getXML(text);
			if(contentXML == null) contentXML = getXML(text, true);
			if(contentXML == null) {
				// 无法解析此文本 第一的o(>﹏<)o不要啊，加入第二
				//GlobalErrorLogic.postToPHP("解析到错误的文本", value);
				ParseList.length = 0;
				return ParseList;
			}
			appendXML(contentXML, _color, NoticeTID);

			var lineData:RichLineData = getEndLineData();
			lineData.NoticeTID = NoticeTID;
			lineData.isFull = true;


		}catch (e:Error) {
			//GlobalErrorLogic.postToPHP("解析聊天报错", text, e.message);
			ParseList.length = 0;
			return ParseList;
		}

		return ParseList;
	}

	private static function getXML(text:String, isAddNode:Boolean = false):XML {
		XML.ignoreWhitespace = false;
		try {
			if (isAddNode == false && text.indexOf("<") == -1) isAddNode = true;
			var contentXML:XML = isAddNode ? new XML("<node>" + text + "</node>") : new XML(text);
			if(isAddNode == false && contentXML) {
				var childLength:int = contentXML.children().length();
				if(childLength == 0) {
					return getXML(text, true);
				}
			}
		}catch(e:Error) {

		}finally {
			XML.ignoreWhitespace = true;
		}
		return contentXML;
	}

	private static function appendObject(contentObj:Object, color:Object, NoticeTID:int = 0):void {
		_format.color = color;
		for each(var node:Object in contentObj){
			parseObject(node, source, null, false);
		}



		/*var contentChildren:XMLList = contentXML.children();
		for (var i:int = 0, length:int = contentChildren.length(); i < length; i++)
		{
			_format.color = color;
			var node:XML = contentChildren[i];
			var nodeXMLList:XMLList;
			var nodeLength:int;
			var nodeName:String;
			if (node) {
				nodeXMLList = node.children();
				nodeLength = nodeXMLList.length();
				nodeName = node.name();
			}

			var lineData:RichLineData = getEndLineData(NoticeTID);
			if (nodeLength == 0) {
				var isContinue:Boolean = false;
				var isParseXML:Boolean = nodeName == RichTextParse.NodeName;
				switch(nodeName) {
					case "br":
						lineData.isFull = true;
						break;
					case RichTextParse.NodeName:
					case null:
						var parseNode:Object = isParseXML ? node : node.toString();
						var isEnd:Boolean = false;	// 是否结束
						do {
							isParseXML ? lineData.ParseXML(parseNode as XML) : lineData.ParseStr(parseNode as String, _format);
							parseNode = lineData.RemainText; // 剩余文本
							isEnd = parseNode == null;
							if (isEnd == false) {
								lineData.RemainText = null;
								lineData = getEndLineData(NoticeTID);
							}
						} while (isEnd == false);
						break;
					default:
						isContinue = true;
						break;
				}
				if(isContinue) continue;
			}else {
				var curColor:Object;
				var attributes:XMLList = node.attributes();
				for each (var attrs:XML in attributes)
				{
					var prop:String = attrs.name().toString();
					var value:String = attrs.toString();
					if(prop == "color") curColor = convertColorToUInt(value);
				}

				appendXML(node, curColor ? curColor : color, NoticeTID);
			}
		}*/
	}

	private static function convertColorToUInt(color:String):Number {
		color = color.replace("#", "0x");
		return parseInt(color, 16)
	}

	private static function getEndLineData(NoticeTID:int = 0):RichLineData {
		var length:int = ParseList.length;
		var endLineData:RichLineData = ParseList[length - 1] as RichLineData;
		var isNew:Boolean = endLineData == null || endLineData.isFull;
		var lineData:RichLineData = isNew ? new RichLineData() : endLineData;
		if(isNew) {
			lineData.maxWidth = _maxWidth;
			lineData.height = int(_format.size);
			lineData.NoticeTID = NoticeTID;

			Debug::Memory {
				App.memoryTracker.track(lineData);
			}
			ParseList.push(lineData);
		}
		return lineData;
	}

	private static function replaceString(str:String, oldStr:String, newStr:String):String {
		return str.split(oldStr).join(newStr);
	}
}
}
