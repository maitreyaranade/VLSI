--- Code  For  2-bit  Comparator  Using  Behavioral  Style  Of  Modeling

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

--  Uncomment the following lines to use the declarations that are
--  provided for instantiating Xilinx primitive components.
--library UNISIM;
--use UNISIM.VComponents.all;

entity comarator is
    Port ( A : in std_logic_vector(1 downto 0);
           B : in std_logic_vector(1 downto 0);
           agb : out std_logic;
           alb : out std_logic;
           aeb : out std_logic);
end comarator;

architecture Behavioral of comarator is

begin
   process(A,B)
   begin
   if(A>B)THEN
   agb<='1';
   alb<='0';
   aeb<='0';
   elsif(A<B)THEN 
   agb<='0';
   alb<='1';
   aeb<='0';
   else
   agb<='0';
   alb<='0';
   aeb<='1';
   end if;
   end process;

end Behavioral;
