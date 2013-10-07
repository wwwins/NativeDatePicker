package;

import flash.Lib;
import flash.display.Sprite;
import flash.display.Shape;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.events.MouseEvent;

import motion.Actuate;

class Main extends Sprite {

	static inline var OFFSET_Y:Int = 100;
	private var format:TextFormat;
	private var label:TextField;

	public function new () {
		
		super ();
		
		format = new TextFormat();
		format.color = 0x0000FF;
		format.size = 16;

		label = new TextField();
		label.defaultTextFormat = format;
		label.text = "Date:";
		label.selectable = false;
		label.x = 0;
		label.y = OFFSET_Y - 30;
		label.width = 150;
		addChild(label);
		
		var btn1 = createBtn("check");
		btn1.x = 0;
		btn1.y = OFFSET_Y;
		addChild(btn1);

		var btn2 = createBtn("show");
		btn2.x = 110;
		btn2.y = OFFSET_Y;
		addChild(btn2);

		var btn3 = createBtn("remove");
		btn3.x = 220;
		btn3.y = OFFSET_Y;
		//addChild(btn3);

		btn1.addEventListener(MouseEvent.CLICK, check);
		btn2.addEventListener(MouseEvent.CLICK, show);
		//btn3.addEventListener(MouseEvent.CLICK, remove);

		Extension.setEventHandle(onEvent);

		startAnimation();
	}
	
	private function startAnimation():Void {
		var box:Shape = new Shape();
		box.graphics.beginFill(0xff0000, 1);
		box.graphics.drawRect(0,0,10,10);
		box.graphics.endFill();
		box.y = 0;
		addChild(box);

		Actuate.tween(box, 2, { x:Math.random () * stage.stageWidth } ).onComplete(animateBox, [box]);
	}

	private function animateBox(box:Shape) {
		Actuate.tween(box, 2, { x:Math.random () * stage.stageWidth } ).onComplete(animateBox, [box]);
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
		tf.y = (50-tf.textHeight)*.5;

		var btn:Sprite = new Sprite();
		btn.graphics.beginFill(0x987654, 1);
		btn.graphics.drawRoundRect(0, 0, 100, 50, 12, 12);
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
}
