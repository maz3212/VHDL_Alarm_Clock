library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clock is
port(clk: in std_logic;
	  button, button1: in std_logic; --button select and icrement
	  switch0, switch1: in std_logic; --switches
	  buzz: out std_logic; --alarm output 
	  a_toggle: in std_logic; --alarm toggle switch 0off 1on
	  lcd_e        : out std_logic;
	  lcd_rs       : out std_logic;
	  lcd_rw       : out std_logic;
	  lcd_db: out std_logic_vector(7 downto 0) --lcd data bus
);
end clock;

architecture rtl of clock is

signal o0, o1, o2, o3, o4, o5: std_logic := '0'; --overflows for CLOCK
signal c0, c1, c2, c3 ,c4, c5: std_logic_vector(3 downto 0) :=(others => '0'); --7seg inputs
signal a0, a1, a2, a3 ,a4, a5: std_logic_vector(3 downto 0) :=(others => '0'); --CLOCK output
signal b0, b1, b2, b3 ,b4, b5: std_logic_vector(3 downto 0) :=(others => '0'); --ALARM output
signal switches: std_logic_vector (1 downto 0) :=(others => '0'); --switches input
signal z, z1: std_logic := '0'; --BUTTON CLICK, select and increment
signal f: std_logic := '0'; --ENABLE ALARM INCREMENT
signal k: std_logic := '0'; --ENABLE CLOCK INCREMENT
signal r: std_logic := '0'; --DISPLAY ALARM/CLOCK 0CLOCK 1ALARM
signal selector: std_logic_vector(3 downto 0) :=(others => '0'); --SELECT COUNTER OUTPUT
signal y: std_logic_vector(5 downto 0) := (others => '0'); --SELECTOR SIGNAL AFTER DECODE
signal buzz_c: std_logic := '0'; --buzzer counter enable
signal alarm_reached: std_logic := '0';
signal hour_reset: std_logic := '1'; --reset for count1
signal ce0, ce1, ce2, ce3, ce4, ce5, ce6: std_logic := '0'; --clock enables for counters
 

component counter_1_second
port(	 clk: 				in std_logic;
	  reset: 				in std_logic;
	  ce: 					in std_logic;
	  overflow: 			out std_logic;
	  buzz: 					out std_logic);
end component;

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

component click_detect
port(clk: 						in std_logic;
	  btn_in: 					in std_logic;
	  btn_clicked: 			out std_logic);
end component;

component select_decoder
port(a: in std_logic_vector(3 downto 0);
	  b: out std_logic_vector(5 downto 0));
end component;

component alarm
port(clk: in std_logic;
	  f: in std_logic; 
	  r: in std_logic;
	  y: in std_logic_vector(5 downto 0); 
	  z: in std_logic;
	  u0, u1, u2, u3, u4, u5: out std_logic_vector(3 downto 0));
end component;

component buzzer_fsm
port(clk: in std_logic;
	  z: in std_logic;
	  r: in std_logic;
	  a_toggle: in std_logic;
	  buzz_c: out std_logic);
end component;

component LCDOutput
	port (
		clk          : in  std_logic;
		k : in std_logic;
		f: in std_logic;
		y: in std_logic_vector(5 downto 0);
		rst          : in  std_logic;
		c0, c1, c2, c3, c4 ,c5: std_logic_vector(3 downto 0); --inputs to be displayed in format (23:59:59        )
		lcd_e        : out std_logic;
		lcd_rs       : out std_logic;
		lcd_rw       : out std_logic;
		lcd_db       : out std_logic_vector(7 downto 0));
end component;


begin

ce0 <= (o0 and (not k)) or (z1 and k and y(0)); --clock enable assignment
ce1 <= (o1 and (not k)) or (z1 and k and y(1)); 
ce2 <= (o2 and (not k)) or (z1 and k and y(2)); 
ce3 <= (o3 and (not k)) or (z1 and k and y(3)); 
ce4 <= (o4 and (not k)) or (z1 and k and y(4)); 
ce5 <= (o5 and (not k)) or (z1 and k and y(5));
ce6 <= (not k); 


switches <= switch0 & switch1; --concatenate switches

click: click_detect port map(clk, button, z); --click detector (select)
click1: click_detect port map(clk, button1, z1); --click detector (increment)
count0: counter_up_to_2 port map(clk, '1', ce0, open, a0);	--hour
count1: counter_up_to_9 port map(clk, hour_reset, ce1, o0, a1);	--hour, overflows when reaches "23:"
count2: counter_up_to_5 port map(clk, '1', ce2, o1, a2);	--minute
count3: counter_up_to_9 port map(clk, '1', ce3, o2, a3);	--minute
count4: counter_up_to_5 port map(clk, '1', ce4, o3, a4);	--second
count5: counter_up_to_9 port map(clk, '1', ce5, o4, a5);	--second
count6: counter_1_second port map(clk, '1', ce6, o5, open);
buzzer: counter_1_second port map(clk, '1', buzz_c, open, buzz);

alarm1: alarm port map(clk, f, r, y, z1, b0, b1, b2, b3, b4, b5); --ALARM COUNTERS 

select_count: counter_up_to_5 port map(clk, '1', z, open, selector);	--select counter
s_decoder: select_decoder port map(selector, y);

fsm: buzzer_fsm port map(clk, alarm_reached, r, a_toggle, buzz_c);

c0 <= a0 when r='0' else b0; --SET DISPLAY INPUTS
c1 <= a1 when r='0' else b1;
c2 <= a2 when r='0' else b2;
c3 <= a3 when r='0' else b3;
c4 <= a4 when r='0' else b4;
c5 <= a5 when r='0' else b5;

lcd: LCDOutput port map(clk, k, f, y, '1', c0, c1, c2, c3, c4, c5, lcd_e, lcd_rs, lcd_rw, lcd_db);

hour_reset <= '0' when (a0="0010" and a1>=x"4") else '1'; --prevent wrong hours for count1

process(switches)
begin
	case switches is 
		when "00" => --display time
			k <= '0';
			f <= '0';
			r <= '0';
		when "01" => --set time
			k <= '1';
			f <= '0';
			r <= '0';
		when "10" => --set alarm
			k <= '0';
			f <= '1';
			r<= '1';
		when others =>	--display time
			k <= '0';
			f <= '0';
			r <= '0';
	end case;
end process;

process(b0, b1, b2, b3 ,b4, b5, a0, a1, a2, a3, a4, a5)
begin
if ((b0 = a0) and (b1 = a1) and (b2 = a2) and (b3 = a3) and (b4 = a4) and (b5 = a5)) then
	alarm_reached <= '1';
else
	alarm_reached <= '0';
end if;
end process;

end rtl;