/**
 * Created by Tool.
 */
package chat {
/**
 * [响应类]发送聊天消息
 */
public class ResChatMessage{
    /**
     * 聊天消息类型,1-综合,2-世界,3-队伍,4-私聊,5-附近,6-系统，12-SOS行会求救,13-玩家发送公告
     */
    public var Type:int;
    /**
     * 消息内容
     */
    public var Message:String = "";
     /**
     * 平台ID
     */
    public var PlatformID:uint;
    /**
     * 区服ID
     */
    public var ServerID:uint;
    /**
     * 对象ID
     */
    public var ObjectID:uint;
    /**
     * 角色名称
     */
    public var NickName:String = "";
    /**
     * 物品模板ID
     */
    public var ItemID:int;
    /**
     * VIP等级
     */
    public var VIPLv:int;
    /**
     * 0-成功 100-禁言 101-私聊玩家不在线 102-该地图无法使用SoS行会求救 103-没有行会救援令 104-没有行会
     */
    public var result:int;
    /**
     * 1-发送者 2-接受者
     */
    public var ChatType:int;
    /**
     * 职业
     */
    public var Career:int;
    /**
     * 签名
     */
    public var Signature:String = "";
    /**
     * 等级
     */
    public var Lv:int;
    /**
     * 性别
     */
    public var Sex:int;
    /**
     * 平台特权
     */
    public var PlatformVIP:int;
    /**
     * 境界等级
     */
    public var StateLv:int;
    /**
     * 公告TID
     */
    public var NoticeTID:int;
}