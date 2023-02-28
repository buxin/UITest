package {
    import ui.ChatUI;
    import laya.utils.Handler;
    import laya.utils.Utils;
    import chat.*;
    import laya.ui.*;
    public class ChatCtrl extends ChatUI{
        private var _model:ChatRoomModel;
        private var _listData:Array;
        private var _roomData:ChatRoomData;
        private var _panelBox:VBox;
        private var _inputText:InputImageText;
        private var _privateChatData:PrivateChatData;
		public function AuctionHallCtrl() {
            super();
            _model = new ChatRoomModel();
        }

        public override function onOpened(param:*):void {
            textInput.text = "";

            _privateChatData = new PrivateChatData();

            _panelBox = new VBox();
            _panelBox.align = VBox.LEFT;
            _panelBox.space = 5;
            panelMessage.addChild(_panelBox);

            var textBox:Box = textInput.parent as Box;
            var _x:int = textInput.x;
            var _y:int = textInput.y;
            var textField:TextInput = textInput.textField;
            var textWidth:int = textField.width;
            var textHeight:int = textField.height;
            _inputText = new InputImageText(textInput);
            _inputText.x = _x;
            _inputText.y = _y;
            textField.width = textWidth;
            textField.height = textHeight;
            textBox.addChild(_inputText);

            btnEnter.clickHandler = new Handler(sendMessage);
        }

        private function sendMessage():void {
            
        }
    }
}