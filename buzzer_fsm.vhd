library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity buzzer_fsm is	--sequence to  be detected is 101
port(clk: in std_logic;
	  z: in std_logic; --alarm reached
	  r: in std_logic; --alarm not being displayed 
	  a_toggle: in std_logic; --alarm on
	  buzz_c: out std_logic
	  );
end buzzer_fsm;

architecture rtl of buzzer_fsm is

type state_type is (s0, s1);
signal state, next_state: state_type := s0;

begin
process(clk) --synchronous process (register)
begin
if rising_edge(clk) then
	state <= next_state;
end if;
end process;

process(state) -- output decode process (output logic)
begin
buzz_c <= '0'; --default
if state = s1 then
	buzz_c <= '1';
end if;
end process;

process(z, a_toggle, r, state) --next state decode process (next state logic)
begin
next_state <= s0; --default
if state = s0 then
	if ((z = '1') and (a_toggle = '1') and (r = '0'))  then
		next_state <= s1;
	end if;
elsif state = s1 then
	if a_toggle = '1' then
		next_state <= s1;
	else
		next_state <= s0;
	end if;	
end if;
end process;

end rtl;