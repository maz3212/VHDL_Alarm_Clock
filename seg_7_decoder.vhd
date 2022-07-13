library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity seg_7_decoder is
port(addr: in std_logic_vector(3 downto 0);
	  data: out std_logic_vector(6 downto 0)
);
end seg_7_decoder;

architecture rtl of seg_7_decoder is

type rom is array(0 to 15) of std_logic_vector(6 downto 0);
constant MY_ROM: rom:=(
	0 => "1000000",
	1 => "1111001",
	2 => "0100100",
	3 => "0110000",
	4 => "0011001",
	5 => "0010010",
	6 => "0000010",
	7 => "1111000",
	8 => "0000000",
	9 => "0011000",
	10 => "0001000",
	11 => "0000011",
	12 => "1000110",
	13 => "0100001",
	14 => "0000110",
	15 => "0001110"
	);
	
begin
process(addr)
begin
	case addr is
		when x"0" =>
			data <= MY_ROM(0);
		when x"1" =>
			data <= MY_ROM(1);			
		when x"2" =>
			data <= MY_ROM(2);
		when x"3" =>
			data <= MY_ROM(3);
		when x"4" =>
			data <= MY_ROM(4);
		when x"5" =>
			data <= MY_ROM(5);			
		when x"6" =>
			data <= MY_ROM(6);
		when x"7" =>
			data <= MY_ROM(7);
		when x"8" =>
			data <= MY_ROM(8);
		when x"9" =>
			data <= MY_ROM(9);			
		when x"a" =>
			data <= MY_ROM(10);
		when x"b" =>
			data <= MY_ROM(11);
		when x"c" =>
			data <= MY_ROM(12);
		when x"d" =>
			data <= MY_ROM(13);			
		when x"e" =>
			data <= MY_ROM(14);
		when x"f" =>
			data <= MY_ROM(15);
		when others =>
			data <= MY_ROM(0);
		end case;
end process;
end rtl;