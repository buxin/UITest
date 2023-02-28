/**
 * Created by Client on 2017/6/8.
 */
package chat {
public class ChatModel {

    /**单频道最大显示数量**/
    public static var CHANNEL_ITEM_COUNT:int = 40;

    private var mChannelArray:Array;
	private var mRichText:RichText;

    public function ChatModel(channelNum:int, richText:RichText) {
	    mRichText = richText;
        mChannelArray = [];
        for (var i:int = 0, n:int = channelNum; i < n; i++) {
            mChannelArray.push([]);
        }
    }

    public function noticeChatMessage(res:ResChatMessage):void {
        //所有消息入口
        //trace(res.ItemID,res.Message);
        if(res.result != 0) return;
        if(res.Message == "") return;
        if(res.Type == ChatChannelType.Horn) return;

        var friendModel:FriendModel = PlayerMgr.self.friendModel;
        if(FriendUtil.getSocietyRelationByArray(res.PlayerID.PlatformID,
                        res.PlayerID.ServerID,
                        res.PlayerID.ObjectID,
                        friendModel.blackList) != null) {
            return;
        }

        switch(res.Type) {
            case ChatChannelType.GuildSOS:
            case ChatChannelType.GuildSystem:
                res.Type = ChatChannelType.Guild;
                break;
        }

        var recordArray:Array = mChannelArray[res.Type];
		setMsgColor(res);
        var message:String = parseChatMessage(res);
        // 添加添加当前频道颜色
        if (res.Type != ChatChannelType.Private) {
            res.Message = Util.addColor(ChatChannelType.getChannelColor(res.Type), res.Message);
        }

        var parseMessage:Array = RichTextUtil.Parse(message, mRichText.formate, mRichText.color, mRichText.maxWidth, res.NoticeTID);
        if(parseMessage.length == 0) return;

		if (recordArray) {
            PushMessage(parseMessage, recordArray);
            // 综合频道显示所有消息
            if(res.Type != 0) {
                recordArray = mChannelArray[ChatChannelType.Synthesize];
                PushMessage(parseMessage, recordArray);
            }
		}
    }

    private function PushMessage(parseMessage:Array, array:Array):void {
	    for (var i:int = 0, length:int = parseMessage.length; i < length; i++) {
		    array.push(parseMessage[i]);
	    }
	    //CheckSaveNum(array, CHANNEL_ITEM_COUNT);
    }

    public function CheckAllChannel():void {
        for (var i:int = 0, n:int = mChannelArray.length; i < n; i++) {
            CheckSaveNum(mChannelArray[i], CHANNEL_ITEM_COUNT);
        }
    }

    private function CheckSaveNum(array:Array, maxNum:int):void {
        if(maxNum > 0) {    // 判断数组是否大于最大数量
            var length:int = array.length;
            if(length > maxNum) length = length - maxNum;
            else length = 0;

            for (var i:int = 0; i < length; i++) {
                var component:Component = array.shift() as Component;
                if(component) {
                    component.remove();
                }
            }
        }
    }

    public function getRecordByChannel(channel:int):Array {
        return mChannelArray[channel];
    }

    public static function parseExpression(message:String):String {
	    // 转换表情
	    // $15 f15
        //return message;//禁用表情
        //
        var findStr:String = ChatUtil.ExpressionFlag;
	    var index:int = message.indexOf(findStr);

	    while(index > -1) {
		    var string:String = message.slice(index, index + findStr.length + 2);
		    message = message.replace(string, ChatUtil.getExpression(string));
		    index = message.indexOf(findStr);
	    }
        return message;
    }

    private static function parseChatMessage(chatMessage:ResChatMessage):String
    {
        var channel:int = chatMessage.Type;
        var message:String = parseExpression(chatMessage.Message);

        // 根据频道，拼字符串
        switch (channel) {
            case ChatChannelType.System:
                message = getChannelStr(channel,chatMessage.NoticeTID) + message;
                break;
            case ChatChannelType.Private:
                if (chatMessage.ChatType == 2) {
                    message = getChannelStr(channel) + 
						Util.addColor(ChatChannelType.getChannelColor(channel),"您对") + 
						getVipStr(chatMessage.PlatformVIP) + 
						Util.addColor("#ff00cc",getNickNameStr(chatMessage)) + 
						Util.addColor(ChatChannelType.getChannelColor(channel),"说：") + message;
                }
                else {
                    message = getChannelStr(channel) + getVipStr(chatMessage.PlatformVIP) + getNickNameStr(chatMessage) + "对您说：" + message;
                }
//                message = Util.addColor(ChatChannelType.getChannelColor(channel), message);
                break;
            case ChatChannelType.GuildSOS:
            case ChatChannelType.GuildSystem:
                message = getChannelStr(channel) + "<font color='" + ChatChannelType.getChannelColor(channel) + "'>"+ message + "</font>";
                break;
            default:
                if (chatMessage.NickName == null || chatMessage.NickName == "") {
                    message = getChannelStr(channel) + message;
                }else {
                    message = getChannelStr(channel) + "<font color='" + "#E5AA5E" + "'>" + 
						getVipStr(chatMessage.PlatformVIP) + 
						getNickNameStr(chatMessage) + "：</font>" + message;
                }
                break;
        }

        message += "\n";
        return message;
    }

    private static function getChannelStr(channel:int, NoticeTID:int = -1):String {
        var NoticeType:int;
        if(NoticeTID != -1){
            NoticeType = GameUtil.NewNoticeTemplateNoticeType(NoticeTID);
            return Util.addColor(ChatChannelType.getChannelColor(channel), "【" + ChatChannelType.getTypeStr(channel ,NoticeType) + "】");
        }else{
            return Util.addColor(ChatChannelType.getChannelColor(channel), "【" + ChatChannelType.getTypeStr(channel) + "】");
        }
    }
	
	private static function setMsgColor(res:ResChatMessage):void{
		switch (res.Type)
		{
			case ChatChannelType.World:
				res.Message = Util.addColor("#ffcc00", res.Message);
				break;
			case ChatChannelType.Guild:
				res.Message = Util.addColor("#66ff33", res.Message);
				break;
			case ChatChannelType.Group:
				res.Message = Util.addColor("#3399ff", res.Message);
				break;
			case ChatChannelType.Nearby:
				res.Message = Util.addColor("#ffffcc", res.Message);
				break;
			case ChatChannelType.Private:
				res.Message = Util.addColor("#ff00cc", res.Message);
				break;
		}
	}

    private static function getVipStr(vip_lv:int):String {
        return ChatUtil.getVip(vip_lv);
    }

    private static function getNickNameStr(item:ResChatMessage):String {
        if (item.NickName == "") return "";

        var json:Object = {};
        json.PlatformID = item.PlayerID.PlatformID;
        json.ServerID = item.PlayerID.ServerID;
        json.PlayerID = item.PlayerID;
        json.EventText = item.NickName;
        json.EventID = ChatCtrl.CheckPlayer;    // 查看玩家
        json.NickName = item.NickName;
        json.Label = item.NickName;

        return ChatUtil.getLinkButton(json);
    }
}
}
