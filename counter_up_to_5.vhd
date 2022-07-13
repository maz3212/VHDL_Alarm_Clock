library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity counter_up_to_5 is
port(	 clk: 					in std_logic;
	  reset: 					in std_logic;
	  ce: 					in std_logic;
	  overflow: 				out std_logic;
	  counter_output:				out std_logic_vector(3 downto 0)
	  );
end counter_up_to_5;


architecture behavioural of counter_up_to_5 is

signal count: integer range 0 to 5 := 0;
signal overflow_i: std_logic :='0';

begin

overflow <= overflow_i;
counter_output <= std_logic_vector(to_unsigned(count,4));

process(reset, clk)
begin
if reset ='0' then
	count <= 0;
	overflow_i <= '0';
elsif rising_edge(clk) then
	if ce='1' then
		if count = 5 then
			count <= 0;
			overflow_i <= '1';
		else
			count <= count +1;
			overflow_i <= '0';
		end if;
	else
		count <= count;
		overflow_i <= '0';
	end if;
end if;
end process;
end behavioural;
