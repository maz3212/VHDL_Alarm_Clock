library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ascii_decoder is
port(count: in std_logic_vector(3 downto 0);
	  ascii: out std_logic_vector(7 downto 0)
);
end ascii_decoder;

architecture rtl of ascii_decoder is

type rom is array(0 to 9) of std_logic_vector(7 downto 0);
constant MY_ROM: rom:=(
	0 => "00110000",
	1 => "00110001",
	2 => "00110010",
	3 => "00110011",
	4 => "00110100",
	5 => "00110101",
	6 => "00110110",
	7 => "00110111",
	8 => "00111000",
	9 => "00111001"
	);
	
begin
process(count)
begin
	case count is
		when "0000" =>
			ascii <= MY_ROM(0);
		when "0001" =>
			ascii <= MY_ROM(1);			
		when "0010" =>
			ascii <= MY_ROM(2);
		when "0011" =>
			ascii <= MY_ROM(3);
		when "0100" =>
			ascii <= MY_ROM(4);
		when "0101" =>
			ascii <= MY_ROM(5);			
		when "0110" =>
			ascii <= MY_ROM(6);
		when "0111"=>
			ascii <= MY_ROM(7);
		when "1000" =>
			ascii <= MY_ROM(8);
		when "1001" =>
			ascii <= MY_ROM(9);			
		when others =>
			ascii <= MY_ROM(0);
		end case;
end process;
end rtl;