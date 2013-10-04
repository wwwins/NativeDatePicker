package;

#if cpp
	import cpp.Lib;
#elseif neko
	import neko.Lib;
#end


class Extension {

	public static function setEventHandle(handler:Dynamic):Void {

		extension_set_event_handle(handler);

	}
	private static var extension_set_event_handle = Lib.load("extension", "extension_set_event_handle", 1);


	public static function sampleMethod (inputValue:Int):Int {

		return extension_sample_method(inputValue);

	}
	private static var extension_sample_method = Lib.load ("extension", "extension_sample_method", 1);



	public static function initDatePicker():Bool {

		return extension_init_datePicker();

	}
	private static var extension_init_datePicker = Lib.load ("extension", "extension_init_datePicker", 0);


	public static function showDatePicker():Void {

		extension_show_datePicker();

	}
	private static var extension_show_datePicker = Lib.load ("extension", "extension_show_datePicker", 0);


	public static function removeDatePicker():Void {

		extension_remove_datePicker();

	}
	private static var extension_remove_datePicker = Lib.load ("extension", "extension_remove_datePicker", 0);

}
