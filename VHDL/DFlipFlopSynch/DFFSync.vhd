library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

--  Uncomment the following lines to use the declarations that are
--  provided for instantiating Xilinx primitive components.
--library UNISIM;
--use UNISIM.VComponents.all;

entity d_syn is
    Port ( d : in std_logic;
           clk : in std_logic;
           rst : in std_logic;
           q : out std_logic);
end d_syn;

architecture Behavioral of d_syn is

begin
process(d,clk)
  begin
  if(clk'event and clk='0') then
	   if(rst='0') then
	   q<='0';
	   else
	   q<=d;
	   end if;
	   end if;
	   end process;
end Behavioral;
