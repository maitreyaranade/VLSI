--PROGRAM STATEMENT:VHDL code for synchronous jk cunter using structural modelling
--------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-----------------------------------------------------
--  Uncomment the following lines to use the declarations that are
--  provided for instantiating Xilinx primitive components.
--library UNISIM;
--use UNISIM.VComponents.all;
----------------------------------------------------------
entity stuctural_synchronous is
    Port ( clk : in std_logic;
           resetin : in std_logic;
           q : inout std_logic);
end stuctural_synchronous;

architecture structural of stuctural_synchronous is
   component jkff
   port(j:in std_logic;
	   k:in std_logic;
	   clock:in std_logic;
	   reset:in std_logic;
	   clock_enable:in std_logic;
	   output:out std_logic;
end component jkff;
begin
 a<=q(2)and q(1)and q(0);
 b<=q(3);
 c<=q(1)and q(0);
 d<=not q(1)and q(0);

 ff0:jkff port map(a,b,clk,resetin,q(0));
 ff1:jkff port map(c,c,clk,resetin,q(1));
 ff2:jkff port map(d,c,clk,resetin,q(2));
 ff3:jkff port map('1','1',clk,resetin,q(3));
end structural;
