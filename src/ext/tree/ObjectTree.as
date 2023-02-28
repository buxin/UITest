package ext.tree {
    import laya.ui.Tree;
    public class ObjectTree extends Tree{
        public function ObjectTree(){
            super();
        }

        /**
        *obj结构的数据源。
        */
        public function set obj(value:Object):void {
            var arr:Array = [];
            parseObject(value, arr, null, true);
            
            array = arr;
        }

        /**
        * @private
        * 解析并处理XML类型的数据源。
        */
        protected function parseObject(obj:Object, source:Array, nodeParent:Object, isRoot:Boolean):void {
            if (!isRoot) {
                var curObj:Object = {};
                var childs:Array;
                var hasChild: Boolean = false;
                for (var prop:String in obj){
                    var value:* = obj[prop];
                    curObj.nodeParent = nodeParent;
                    if(value is Array){
                        if(!childs) childs = [];
                        childs = childs.concat(value);
                    }else{
                        curObj[prop] = value == "true" ? true : value == "false" ? false : value;
                    }
                }

                if(childs && childs.length>0){
                    hasChild = true;
                    curObj.isDirectory = true;
                }
                curObj.hasChild = hasChild;
                source.push(curObj);

                for each(var node:Object in childs){
                    parseObject(node, source, curObj, false);
                }
            }else{
                for each(var node:Object in obj){
                    parseObject(node, source, null, false);
                }
            }
        }
    }
}