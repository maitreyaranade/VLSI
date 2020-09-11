--PROGRAM STATEMENT:VHDL Code for up down counter
---------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-----------------------------------------------------------------------
--  Uncomment the following lines to use the declarations that are
--  provided for instantiating Xilinx primitive components.
--library UNISIM;
--use UNISIM.VComponents.all;
---------------------------------------------------------------------------
entity updown_counter is
    Port ( clk : in std_logic;
           rst : in std_logic;
           load : in std_logic;
           no : in std_logic_vector(3 downto 0);
           direction : in std_logic;
           q : out std_logic_vector(3 downto 0));
end updown_counter;

architecture Behavioral of updown_counter is
signal temp : std_logic_vector(3 downto	0);
begin
 process(clk,rst)
 begin
 if (rst='1') then
 temp <="0000";
 elsif (clk'event and clk='1')then
 if (load= '1')then 
 temp<= no;
 elsif (load='0' and direction='0') then
 temp<= temp+1;
  elsif (load='0' and direction='1') then
 temp<= temp-1;
 end if;
 end if;
 end process;
 q<= temp;
end Behavioral;


