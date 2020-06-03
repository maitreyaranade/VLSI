--PROGRAM STATEMENT:VHDL Code ALU
----------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

--  Uncomment the following lines to use the declarations that are
--  provided for instantiating Xilinx primitive components.
--library UNISIM;
--use UNISIM.VComponents.all;
-------------------------------------------------------------------------------------------

entity ALU is
    Port ( nibble1 : in std_logic_vector(3 downto 0);
           nibble2 : in std_logic_vector(3 downto 0);
           operation : inout std_logic_vector(2 downto 0);
           flag : out std_logic;
           result : out std_logic_vector(3 downto 0));
end ALU;
-----------------------------------------------------------------------------------------

architecture behavioral of ALU is
  signal temp : std_logic_vector(4 downto 0);
begin
process ( nibble1 , nibble2 , operation,temp )
begin
flag<='0';
case operation is
when "000"=>temp<=std_logic_vector(("0" & nibble1 ) + (nibble2));
result<=std_logic_vector(temp(3 downto 0));
flag<=temp(4);
when "001"=>
if (nibble1 > nibble2 )then
result<= (nibble1)- (nibble2);
flag<= '0';
else
result <=(nibble2)-(nibble1);
flag<='1';
end if ;
when"010"=>
result<= nibble1 or nibble2 ;
when"011"=>
result<= nibble1 xor nibble2 ;
when"100"=>
result<= nibble1 and nibble2 ;
when"101"=>
result<= nibble1 nand nibble2 ;
when"110"=>
result<= nibble1 nor nibble2 ;
when"111"=>
result<= nibble1 xnor nibble2;
when others=>
result<="0000";
flag<='0';
end case ;
end process ;
end behavioral;
