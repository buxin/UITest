/**
 * Created by ChengXu1 on 2016/11/1.
 */
package chat {
public class ChatRoomModel {

    private var _messageDict:Dictionary;
    private var _isTipNewMessage:Boolean;

    private var m_NewMessageNum:int;

    public function ChatRoomModel() {
        _messageDict = new Dictionary();
    }

    private function onChatMessage(res:ResChatMessage):void {
        if(res.result != 0)
            return;

        var keyString:String = getObjectKey(res.PlatformID, res.ServerID, res.ObjectID);
        var data:ChatRoomData = _messageDict[keyString];
        if(data == null)
        {
            data = new ChatRoomData();
            data.PlatformID = res.PlayerID.PlatformID;
            data.ServerID = res.PlayerID.ServerID;
            data.PlayerID = res.PlayerID.ObjectID;
            data.NickName = res.NickName;
            data.VIPLv = res.VIPLv;
            data.Sex = res.Sex;
            data.Lv = res.Lv;
            data.Signature = res.Signature;
            data.Career = res.Career;
            data.StateLv = res.StateLv;
            data.Type = res.Type;
            _messageDict[keyString] = data;
        }

        var messageData:ChatMessageData = new ChatMessageData();
        messageData.ChatType = res.ChatType;
        messageData.Message = ChatModel.parseExpression(res.Message);
        messageData.Time = Laya.timer.currTimer;
        messageData.NickName = data.NickName;
        data.addMessage(messageData);

        if(res.ChatType == 1 && FunctionOpenType.isOpen(FunctionOpenType.PrivateChat))
            data.IsNewMessage = true;
    }

    public function getObjectKey(platformID:int, serverID:int, objectID:int):String {
        return platformID + "_" + serverID + "_" + objectID;
    }

    public function refreshData():void
    {
        _isTipNewMessage = false;
        m_NewMessageNum = 0;

		if (FunctionOpenType.isOpen(FunctionOpenType.PrivateChat, true)) {
			for each (var chatRoomData:ChatRoomData in _messageDict) {
                if(chatRoomData.IsNewMessage) {
                    _isTipNewMessage = true;
                    m_NewMessageNum++;
                }
			}
		}
    }

    public function get messageDict():Dictionary {
        return _messageDict;
    }

    public function getChatRoomData(platformID:int, serverID:int, playerID:int):ChatRoomData {
        var keyString:String = MapObjectMgr.getObjectKey(platformID,serverID,playerID);
        return _messageDict[keyString];
    }

    public function getNewMessageChatRoomData():ChatRoomData {
        for each (var chatRoomData:ChatRoomData in _messageDict) {
            if(chatRoomData.IsNewMessage)
                return chatRoomData;
        }
        return null;
    }

    public function get isTipNewMessage():Boolean {
        return _isTipNewMessage;
    }

    /**新消息数量**/
    public function get NewMessageNum():int {
        return m_NewMessageNum;
    }
}
}
