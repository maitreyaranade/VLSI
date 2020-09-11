library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

--  Uncomment the following lines to use the declarations that are
--  provided for instantiating Xilinx primitive components.
--library UNISIM;
--use UNISIM.VComponents.all;

entity jk_syn is
    Port ( j : in std_logic;
           k : in std_logic;
           clk : in std_logic;
           rst : in std_logic;
           q : inout std_logic);
end jk_syn;

architecture Behavioral of jk_syn is

begin
process(clk)
begin
if(clk'event and clk='1') then
if(rst='0')then
q<='0';
elsif(rst='1')then
if(j='0' and k='0')then
q<=q;
 elsif(j='1' and k='0')then
q<='1';
elsif(j='0' and k='1') then
q<='0';
else
q<=not(q);
 end if;
 end if;
 end if;
end process;

end Behavioral;
