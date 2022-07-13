library ieee;
use ieee.std_logic_1164.all;

entity select_decoder is
port(a: in std_logic_vector(3 downto 0);
		b: out std_logic_vector(5 downto 0));
end entity select_decoder;

architecture behavioural of select_decoder is
begin
process(a)
	begin
		
		case a is 
			when x"0" =>
				b <= "000001";
			when x"1" =>
				b <= "000010";
			when x"2" =>
				b <= "000100";
			when x"3" =>
				b <= "001000";
			when x"4" =>
				b <= "010000";
			when x"5" =>
				b <= "100000";
			when others =>
				b <= "000000";
		end case;
			
end process;
end architecture;
	