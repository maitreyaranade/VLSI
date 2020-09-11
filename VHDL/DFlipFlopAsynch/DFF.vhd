--- Code  For  Asynchronous  D Flip-flop
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

--  Uncomment the following lines to use the declarations that are
--  provided for instantiating Xilinx primitive components.
--library UNISIM;
--use UNISIM.VComponents.all;

entity D_FF is
    Port ( D : in std_logic;
           CLK : in std_logic;
           RST : in std_logic;
           Q : out std_logic);
end D_FF;

architecture Behavioral of D_FF is

begin
	 PROCESS (D, CLK, RST)
	 BEGIN
	 IF(RST='0') THEN 
	 Q<='0';
	 ELSIF( CLK'EVENT AND CLK='1')THEN
	 Q<=D ;
	 END IF;
	 END PROCESS;
	 
end Behavioral;

