package;

import flash.Lib;
import flash.display.Sprite;
import flash.display.Shape;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.events.MouseEvent;

import motion.Actuate;
import motion.easing.Linear;

class Main extends Sprite {

	static inline var OFFSET_Y:Int                       = 100;

	static inline var UIDatePickerModeTime:Int           = 0;
	static inline var UIDatePickerModeDate:Int           = 1;
	static inline var UIDatePickerModeDateAndTime:Int    = 2;
	static inline var UIDatePickerModeCountDownTimer:Int = 3;

	private var format:TextFormat;
	private var label:TextField;
	private var label_mode:TextField;
	private var mode:Int = 0;

	public function new () {
		
		super ();
		
		format = new TextFormat();
		format.font = "Arial";
		format.color = 0xE5EDB6;
		format.size = 16;

		label = new TextField();
		label.defaultTextFormat = format;
		label.text = "Date:";
		label.selectable = false;
		label.x = 10;
		label.y = OFFSET_Y - 30;
		label.width = 150;
		addChild(label);
		
		label_mode = new TextField();
		label_mode.defaultTextFormat = format;
		label_mode.text = "Mode:1";
		label_mode.selectable = false;
		label_mode.x = label.width + 5;
		label_mode.y = OFFSET_Y - 30;
		label_mode.width = 60;
		addChild(label_mode);

		/*
		var btn1 = createBtn("check");
		btn1.x = 0;
		btn1.y = OFFSET_Y;
		addChild(btn1);
		*/

		var btn2 = createBtn("show");
		btn2.x = 10;
		btn2.y = OFFSET_Y;
		addChild(btn2);

		var btn3 = createBtn("mode");
		btn3.x = 120;
		btn3.y = OFFSET_Y;
		addChild(btn3);

		//btn1.addEventListener(MouseEvent.CLICK, check);
		btn2.addEventListener(MouseEvent.CLICK, show);
		//btn3.addEventListener(MouseEvent.CLICK, remove);
		btn3.addEventListener(MouseEvent.CLICK, setDatePickerMode);

		Extension.setEventHandle(onEvent);

		startAnimation();
	}
	
	private function startAnimation():Void {
		var box:Shape = new Shape();
		box.graphics.beginFill(0xF6695B, 1);
		box.graphics.drawRect(0,0,10,10);
		box.graphics.endFill();
		box.y = 0;
		addChild(box);

		// loop
		Actuate.tween(box, 2, { x:stage.stageWidth-box.width } ).ease(Linear.easeNone).repeat().reflect();
	}

	private function onEvent(e:Dynamic) {
		var data = Reflect.field(e, "data");
		var type = Reflect.field(e, "type");
		trace("onEvent:"+type+":"+data);

		if (type=="0") {
			label.text = "Date:"+data;
		}
		if (type=="1") {
			Lib.resume();
		}
	}

	private function createBtn(txt:String):Sprite {

		var tf:TextField = new TextField();
		tf.defaultTextFormat = format;
		tf.text = txt;
		tf.selectable = false;
		tf.x = (100-tf.textWidth)*.5;
		tf.y = (36-tf.textHeight)*.5;

		var btn:Sprite = new Sprite();
		btn.graphics.beginFill(0x00766C, 1);
		btn.graphics.drawRoundRect(0, 0, 100, 36, 12, 12);
		btn.graphics.endFill();
	
		btn.addChild(tf);

		return btn;
	}

	private function check(e:MouseEvent):Void {

		//trace("show:"+Extension.sampleMethod(777));
		//Extension.initTextfield("お元気ですか 你好 hello");
		trace(Extension.initDatePicker());
	}

	private function show(e:MouseEvent):Void {

		Lib.pause();
		Extension.showDatePicker();

	}

	private function remove(e:MouseEvent):Void {

		Lib.pause();
		Extension.removeDatePicker();

	}

	private function setDatePickerMode(e:MouseEvent):Void {

		trace("Mode:"+mode);
		//Extension.setDatePickerMode(UIDatePickerModeDateAndTime);
		Extension.setDatePickerMode(mode);
		label_mode.text = "Mode:" + Std.string(mode);
		mode = ((mode+1 > 3) ? 0 : mode+1);

	}
}
