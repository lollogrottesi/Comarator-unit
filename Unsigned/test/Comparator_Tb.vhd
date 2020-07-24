----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.07.2020 16:09:28
-- Design Name: 
-- Module Name: Comparator_Tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Comparator_Tb is
--  Port ( );
end Comparator_Tb;

architecture Behavioral of Comparator_Tb is

constant N : integer := 4;
component Comparator is
    Generic (N: integer:= 32);
    Port (A: in std_logic_vector (N-1 downto 0);
          B: in std_logic_vector (N-1 downto 0);
          A_eq_B: out std_logic;
          A_not_equal_B: out std_logic;
          A_gr_B: out std_logic;
          A_gr_eq_B: out std_logic;
          A_low_B: out std_logic;
          A_low_equal_B: out std_logic);
end component;

signal A_eq_B, A_not_equal_B: std_logic;
signal A_gr_eq_B, A_gr_B: std_logic;
signal A_low_B, A_low_equal_B: std_logic;

signal A,B : std_logic_vector (N-1 downto 0);

begin
dut : Comparator generic map (N)
                 port map (A, B, A_eq_B, A_not_equal_B, A_gr_B, A_gr_eq_B, A_low_B, A_low_equal_B);
                 
                 
    process
    begin
        i_loop: 
        for i in 0 to 2**N-1 loop
            j_loop:
            for j in 0 to 2**N-1 loop
                A <= std_logic_vector(to_unsigned(i, N));
                B <= std_logic_vector(to_unsigned(j, N));
                wait for 10 ns;
                if (i = j) then
                    assert A_eq_B = '1' report "Expected A=B, but A\=B";
                    assert A_not_equal_B = '0' report "Expected A=B, but A\=B in A_not_equal_B";
                else
                    assert A_eq_B = '0' report "Expected A\=B, but A=B"; 
                    assert A_not_equal_B = '1' report "Expected A\=B, but A=B in A_not_equal_B";
                end if;
                if (i >= j) then
                    assert A_gr_eq_B = '1' report "Expected A>=B, but A<B";
                    assert A_low_B = '0' report "Expected A>=B, but A<B A_less_B";
                else
                    assert A_gr_eq_B = '0' report "Expected A<B, but A>=B"; 
                    assert A_low_B = '1' report "Expected A<B, but A>=B A_less_B";
                end if;
                if (i <= j) then
                    assert A_low_equal_B = '1' report "Expected A<=B, but A>B";
                    assert A_gr_B = '0' report "Expected A<B, but A>B, A_gr_B";
                else
                    assert A_low_equal_B = '0' report "Expected A>B, but A<B"; 
                    assert A_gr_B = '1' report "Expected A<B, but A>B, A_gr_B";
                end if;
            end loop j_loop;
        end loop i_loop;
    end process;

end Behavioral;
