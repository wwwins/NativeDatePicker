#ifndef EXTENSION_H
#define EXTENSION_H

#include "Trace.h"

namespace extension {
	
	//extern bool isOpen;

	int SampleMethod(int inputValue);

	bool initDatePicker();

	void showDatePicker();

	void removeDatePicker();

	void setDatePickerMode(int modeValue);
}


#endif
