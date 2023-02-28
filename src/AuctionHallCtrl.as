package {
    import ui.AuctionHallUI;
    import laya.ui.Button;
    import laya.utils.Handler;
    import laya.utils.Utils;
    import ext.tree.ObjectTree;
    public class AuctionHallCtrl extends AuctionHallUI{
        private tree1: ObjectTree;
		public function AuctionHallCtrl() {
            super();
        }

        public override function onOpened(param:*):void {
            var treeData = Laya.loader.getRes("chooseList.json");
            tree.renderHandler = new Handler(this, onTreeHandler);
            tree.mouseHandler = new Handler(this, onMouseHandler);
            tree.obj = treeData;
            tree.setItemState(0, true);
		}

        private function onTreeHandler(cell:Box, index:int):void {
            if (index >= tree.length) return;
            var item:Object = cell.dataSource;
            var label:Label = cell.getChildByName("label") as Label;
            var imgBg1:DisplayObject = cell.getChildByName("imgBg1");
            imgBg1.visible = item.hasChild;
            if (item.hasChild) return;
            label.text = item.name;
        }

        private function onMouseHandler(e:MouseEvent, index:int):void {
            if (e.type == "click") {
                var isOpen = !tree.array[index].isOpen;
                tree.setItemState(index, isOpen);
            }
        }
    }
}