# VHDL Alarm Clock
alarm.vhd is the main entity.

This design was intended for a Terasic De-10 Lite FPGA.  
Requires a 16x2 LCD, 3 Switches, 2 momentary push buttons, and a buzzer.  
The buttons are debounced.

Find images and flow charts of the design in ./images

Thanks to Mauer1 for the LCD Controller.  
https://github.com/Maeur1/16x2-LCD-Controller-VHDL


***

## Components

• Clock (Fig.2): This is the top-level entity where all the other components are used and connected to each other. The counters in this component are incremented every second when the time is being displayed, or pauses them when the user is setting time and incrementing them manually (the overflows of the counters only affect each other when the user is not setting the time).  
• Counter_1_second: This is a counter that accepts a 50MHz clock signal and overflows every 50000000 clock cycles (1 second). It also has an output called ‘buzz’ which is a pulse signal that lasts half a second (25000000 clock cycles) (Used to flash currently selected digit and to make the buzzer beep).  
• Counter_up_to_9: This is a counter that has a 4-bit output count that ranges from 0 to 9. It also has an output overflow that gets set to ‘1’ when the counter receives a reset signal or the maximum count is reached. The instance of this counter that is used to display the ones of hours has a special reset signal ‘hour_reset’, this signal resets the counter when the tens of hour is 2 and the ones of hours is greater than or equal to 4, this prevents the user from entering invalid hours (e.g. 28:00:00) (cannot have more than 24 hours in a day).  
• Counter_up_to_5: Regular counter that has a 4-bit output count that ranges from 0 to 5. Has an output overflow that is set to ‘1’ when the maximum count is reached.  
• Counter_up_to_2: Regular counter that has a 4-bit output count that ranges from 0 to 2. Has an output overflow that is set to ‘1’ when the maximum count is reached.  
• Alarm (Fig.3A): This is identical to clock except the counters can only be incremented by user input and the overflows of the counters do not affect each other. The purpose of this component is to allow to user to specify a time for the alarm to go off at.  
• Click_detect: A basic click detector component that makes use of a debounce component, outputs a pulse when it detects a click from a button.  
• Select_decoder (Fig.6): This decoder accepts a 4-bit input from a counter (up to 5) and produces a 6-bit output based on that which is used to select which counter in clock(or alarm) is currently being incremented manually.  
• Buzzer_fsm (Fig.4): This is a basic moore state machine with the purpose of making toggling the buzzer on when the alarm time is met and the alarm switch is set to ‘1’ until the user sets the switch back to ‘0’. The machines has two states, s0 and s1. It starts in s0 with the buzzer toggled off and moves to s1 when the alarm time is reached, the alarm is on, and the alarm is not currently being set, then it stays in s1 until the user toggles the alarm off.  
• LCDOutput (Fig.1): This component sets the outputs for  each of the lcd pins (Enable, register select, read/write, and 8-bit data pins). It has 6 4-bit inputs (p0-p5, Fig.7) which are the numbers to be displayed after being decoded and sent to LCD_controller. This component also has the functionality to flash the currently selected digit (half a second pulse using buzz form counter_1_sec) when setting the time/alarm.   
• Lcd_controller: This component is used to control the lcd screen and is a component of LCDOutput. (See 2.6). Accepts two 128-bit inputs, one is the top line of the lcd and the other is the bottom, and outputs them using 8-bits.  
• Ascii_decoder: This is a component of LCDOutput and accepts a 4-bit input (number to be converted to ascii) and outputs the corresponding ascii (8-bit) equivalent of that 4-bit number. (Works for numbers 0-9).  
 
