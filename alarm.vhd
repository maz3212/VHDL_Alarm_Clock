library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alarm is
port(clk: in std_logic;
	  f: in std_logic; --enable increment
	  r: in std_logic; --enable display
	  y: in std_logic_vector(5 downto 0); --selector signal
	  z: in std_logic; --button
	  u0, u1, u2, u3, u4, u5: out std_logic_vector(3 downto 0) --counter outputs
);
end alarm;

architecture rtl of alarm is
signal ce0, ce1, ce2, ce3, ce4, ce5, ce6: std_logic := '0';
signal a0, a1, a2, a3 ,a4, a5: std_logic_vector(3 downto 0) :=(others => '0'); --coutner output
signal hour_reset: std_logic := '1'; --reset for count1

component counter_up_to_2
port(	 clk: 				in std_logic;
	  reset: 				in std_logic;
	  ce: 					in std_logic;
	  overflow: 			out std_logic;
	  counter_output:		out std_logic_vector(3 downto 0));
end component;

component counter_up_to_5
port(	 clk: 				in std_logic;
	  reset: 				in std_logic;
	  ce: 					in std_logic;
	  overflow: 			out std_logic;
	  counter_output:		out std_logic_vector(3 downto 0));
end component;

component counter_up_to_9
port(	 clk: 				in std_logic;
	  reset: 				in std_logic;
	  ce: 					in std_logic;
	  overflow: 			out std_logic;
	  counter_output:		out std_logic_vector(3 downto 0));
end component;


begin
ce0 <= (z and f and r and y(0));
ce1 <= (z and f and r and y(1));
ce2 <= (z and f and r and y(2));
ce3 <= (z and f and r and y(3));
ce4 <= (z and f and r and y(4));
ce5 <= (z and f and r and y(5));


count0: counter_up_to_2 port map(clk, '1', ce0, open, a0);
count1: counter_up_to_9 port map(clk, hour_reset, ce1, open, a1);
count2: counter_up_to_5 port map(clk, '1', ce2, open, a2);
count3: counter_up_to_9 port map(clk, '1', ce3, open, a3);
count4: counter_up_to_5 port map(clk, '1', ce4, open, a4);
count5: counter_up_to_9 port map(clk, '1', ce5, open, a5);

u0 <= a0;
u1 <= a1;
u2 <= a2;
u3 <= a3;
u4 <= a4;
u5 <= a5;

hour_reset <= '0' when (a0="0010" and a1>=x"4") else '1'; --prevent wrong hours for count1
end rtl;