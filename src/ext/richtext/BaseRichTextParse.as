package ext.richtext {
    public class BaseRichTextParse {
        private _obj:Object;
        public function BaseRichTextParse(){
            _obj = {};
        }

        public function get obj(): Object{
            return _obj;
        }

        public function addAttribute(attr:String, value:Object):Object {
            obj.props |= {};
            obj.props[attr] = value.toString();
            return obj;
        }
    }
}