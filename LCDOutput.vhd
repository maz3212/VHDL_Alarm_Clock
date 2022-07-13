----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Mayur Panchal
-- 
-- Create Date:    14:13:20 11/06/2016 
-- Design Name: 
-- Module Name:    ControllerTest_TOP - Behavioral 
-- Project Name: 	 LCD Controller Test
-- Target Devices: 	XC5VLX50T
-- Tool versions: 	ISE 14.7
-- Description: 	Handles controlling the 16x2 Character LCD screen
--
-- Dependencies: 
--
-- Revision: 1
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity LCDOutput is
	port (
		clk          : in  std_logic;
		k: in std_logic;
		f: in std_logic;
		y: in std_logic_vector(5 downto 0);
		rst          : in  std_logic;
		c0, c1, c2, c3, c4 ,c5: std_logic_vector(3 downto 0); --inputs to be displayed in format (23:59:59        )
		lcd_e        : out std_logic;
		lcd_rs       : out std_logic;
		lcd_rw       : out std_logic;
		lcd_db       : out std_logic_vector(7 downto 0)
		);
end LCDOutput;

architecture Behavioral of LCDOutput is
	
	COMPONENT lcd_controller IS
	  PORT(
		 clk        : IN    STD_LOGIC;  --system clock
		 reset_n    : IN    STD_LOGIC;  --active low reinitializes lcd
		 rw, rs, e  : OUT   STD_LOGIC;  --read/write, setup/data, and enable for lcd
		 lcd_data   : OUT   STD_LOGIC_VECTOR(7 DOWNTO 0); --data signals for lcd
		 line1_buffer : IN STD_LOGIC_VECTOR(127 downto 0); -- Data for the top line of the LCD
		 line2_buffer : IN STD_LOGIC_VECTOR(127 downto 0)); -- Data for the bottom line of the LCD
	END COMPONENT;
	
	component ascii_decoder
	port(count: in std_logic_vector(3 downto 0);
	  ascii: out std_logic_vector(7 downto 0));
	end component;
	
	component counter_1_second
	port(	 clk: 				in std_logic;
	  reset: 				in std_logic;
	  ce: 					in std_logic;
	  overflow: 			out std_logic;
	  buzz: 					out std_logic
	  );
	end component;
	
	-- These lines can be configured to be input from anything. 
	-- 8 bits per character
	signal top_line : std_logic_vector(127 downto 0) := (others => '0');
	signal bottom_line : std_logic_vector(127 downto 0) := (others => '0');
	
	signal p0, p1, p2, p3,p4, p5: std_logic_vector(7 downto 0); --ascii values to be outputed to lcd
	signal f0, f1, f2, f3,f4, f5: std_logic_vector(7 downto 0); --ascii values to be outputed to lcd with flash
	signal flash: std_logic := '0'; --flashes selected digit for half a second
		
begin

LCD: lcd_controller port map(
	clk => clk,
	reset_n => rst,
	e => lcd_e,
	rs => lcd_rs,
	rw => lcd_rw,
	lcd_data => lcd_db,
	line1_buffer => top_line,
	line2_buffer => bottom_line 
);

flash_counter: counter_1_second port map(clk, '1', '1', open, flash); --flash triggers for half a second

f0 <= "01011111" when ((k='1' or f='1') and y(0)='1' and flash='1') else p0; --flashes digit when incrementing otherwise display regularly
f1 <= "01011111" when ((k='1' or f='1') and y(1)='1' and flash='1') else p1;
f2 <= "01011111" when ((k='1' or f='1') and y(2)='1' and flash='1') else p2;
f3 <= "01011111" when ((k='1' or f='1') and y(3)='1' and flash='1') else p3;
f4 <= "01011111" when ((k='1' or f='1') and y(4)='1' and flash='1') else p4;
f5 <= "01011111" when ((k='1' or f='1') and y(5)='1' and flash='1') else p5;

ascii0: ascii_decoder port map(c0, p0);
ascii1: ascii_decoder port map(c1, p1);
ascii2: ascii_decoder port map(c2, p2);
ascii3: ascii_decoder port map(c3, p3);
ascii4: ascii_decoder port map(c4, p4);
ascii5: ascii_decoder port map(c5, p5);

top_line <= f0 & f1 & "00111010" & f2 & f3 & "00111010" & f4 & f5 & "00100000" & "00100000" & "00100000" & "00100000" & "00100000" & "00100000" & "00100000" & "00100000";
bottom_line <= x"20202020202020202020202020202020";

end Behavioral;

