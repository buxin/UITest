/**
 * Created by ChengXu1 on 2016/11/1.
 */
package chat {
public class ChatRoomData {
    /**
     * 平台ID
     */
    public var PlatformID:uint;
    /**
     * 区服ID
     */
    public var ServerID:uint;
    /**
     * 玩家ID
     */
    public var PlayerID:uint;
    /**
     * 角色名称3
     */
    public var NickName:String = "";
    /**
     * 性别
     */
    public var Sex:uint;
    /**
     * 职业
     */
    public var Career:uint;
    /**
     * 关系
     */
    public var Relation:int = -1;
    /**
     * 等级
     */
    public var Lv:uint;
    /**
     * 签名
     */
    public var Signature:String = "";
    /**
     * VIP等级
     */
    public var VIPLv:uint;
    /**
     * 境界等级
     */
    public var StateLv:uint;
    /**
     * 聊天消息类型,1-综合,2-世界,3-队伍,4-私聊,5-附近,6-系统，12-SOS行会求救,13-玩家发送公告
     */
    public var Type:uint;

    /**消息数量**/
    public var MessageArray:Array;

    private var _IsNewMessage:Boolean = false;

    public function ChatRoomData() {
        MessageArray = [];
    }

    public function addMessage(messageData:ChatMessageData):void {
        MessageArray.push(messageData);

        SaveArrNumber(MessageArray,40);
    }

    public function get IsNewMessage():Boolean {
        return _IsNewMessage;
    }

    public function set IsNewMessage(value:Boolean):void {
        _IsNewMessage = value;
    }

    /**
        * 保存数组个数，如果个数超过，就删除前面几个
        * @param	array		当前数组 类型只可以 Array 和 Vector
        * @param	num		个数
        */
    public function SaveArrNumber(array:Object, num:int, isPush:Boolean = true):void {
        var length:int = array.length;
        if (length > num) {
            if(isPush) {
                var count:int = length - num;
                array.splice(0, count);
            }else {
                array.length = length;
            }
        }
    }
}
}
