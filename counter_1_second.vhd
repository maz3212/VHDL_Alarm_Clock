library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity counter_1_second is
port(	 clk: 				in std_logic;
	  reset: 				in std_logic;
	  ce: 					in std_logic;
	  overflow: 			out std_logic;
	  buzz: 					out std_logic
	  );
end counter_1_second;


architecture behavioural of counter_1_second is

signal count: integer range 0 to 49999999 := 0;
signal overflow_i: std_logic :='0';
signal buzz_i: std_logic := '0';

begin

overflow <= overflow_i;
buzz <= buzz_i;

process(reset, clk)
begin
if reset ='0' then
	count <= 0;
	overflow_i <= '0';
elsif rising_edge(clk) then
	if ce='1' then
		if count = 49999999 then
			count <= 0;
			overflow_i <= '1';
		else
			count <= count +1;
			overflow_i <= '0';
			if count < 25000000 then
				buzz_i <= '1';
			else
				buzz_i <= '0';
			end if;
		end if;
	else
		buzz_i <= '0';
		count <= count;
		overflow_i <= '0';
	end if;
end if;
end process;
end behavioural;
