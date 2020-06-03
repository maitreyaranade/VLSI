--PROGRAM STATEMENT:VHDL Code for asynchronous jk flipflop
--------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-------------------------------------------------------------
--  Uncomment the following lines to use the declarations that are
--  provided for instantiating Xilinx primitive components.
--library UNISIM;
--use UNISIM.VComponents.all;
----------------------------------------------------------------------
entity jk_flipflop is
    Port ( j : in std_logic;
           k : in std_logic;
           prst : in std_logic;
           clr : in std_logic;
           clk : in std_logic;
           q : inout std_logic;
           qbar : inout std_logic);
end jk_flipflop;
---------------------------------------------------------------
architecture Behavioral of jk_flipflop is

begin

    process(j,k,prst,clr,clk,q,qbar)
    begin
    if (prst='0'and clr='1')then 
    q<='1';
    qbar<='0';
    elsif (prst='1'and clr='0')then 
    q<='0';
    qbar<='1';
    end if ;
    if (prst='1' and clr='1')then
    if (clk'event and clk='1') then
    if (j='0'and k='0')then
   q<= q;
   qbar<=qbar;
   elsif (j='1'and k='0')then
   q<='1';
   qbar<='0';
   elsif	(j='0'and k='1')then
   q<='0';
   qbar<='1'; 
    elsif	(j='1'and k='1')then
   q<=not q;
   qbar<=not qbar;
   end if;
   end if;
   end if;
end process;
end Behavioral;
