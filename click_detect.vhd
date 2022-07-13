library ieee;
use ieee.std_logic_1164.all;

entity click_detect is
port(clk: 						in std_logic;
	  btn_in: 					in std_logic;
	  btn_clicked: 			out std_logic
	  );
end click_detect;


architecture behavioural of click_detect is


signal btn_clicked_i: std_logic :='0';
signal x: std_logic :='1';

type state_type is (wait_0, wait_1);
signal state, next_state: state_type := wait_0; 

component debounce 
port(clk: 						in std_logic;
	  btn_in: 					in std_logic;
	  btn_out: 					out std_logic
	  );
end component;

begin

btn_clicked <= btn_clicked_i;

debounce_inst: debounce port map (clk =>clk, btn_in => btn_in, btn_out => x);


--fsm synchronous process
process(clk)
begin
if rising_edge(clk) then
	state <= next_state;
end if;
end process;


--fsm output/next state decode process
process(state, x)
begin

next_state <= wait_0;
btn_clicked_i<= '0';

if state = wait_0 then
	if x = '0' then
		next_state <= wait_1;
	end if;
else
	if x = '1' then
		btn_clicked_i<= '1';
	else
		next_state <= wait_1;
	end if;
end if;
end process;
end behavioural;