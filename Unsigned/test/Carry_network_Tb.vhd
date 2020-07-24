----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.07.2020 14:42:49
-- Design Name: 
-- Module Name: Carry_network_Tb - Behavioral
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

entity Carry_network_Tb is
--  Port ( );
end Carry_network_Tb;

architecture Behavioral of Carry_network_Tb is

constant N: integer := 32;

component Carry_out_network is 
 Generic(N: integer:= 32); 
 Port (A: in std_logic_vector(N-1 downto 0);
       B: in std_logic_vector(N-1 downto 0);
       cin: in std_logic;
       cout: out std_logic);
end component;

signal A, B: std_logic_vector(N-1 downto 0);
signal c_in, c_out: std_logic;
begin

dut : Carry_out_network generic map (N)
                        port map (A, B, c_in, c_out);
      process
      begin
        c_in <= '0';
        A <= (0 => '1', others => '0');
        B <= (0 => '1', others => '0');
        wait for 10 ns;
        c_in <= '0';
        A <= (others => '1');
        B <= (0 => '1', others => '0');
        wait for 10 ns;
        c_in <= '1';
        A <= (others => '1');
        B <= (others => '0');
        wait;
      end process;
--    process 
--    begin
--        c_in <= '0';
--    i_loop:
--        for i in 0 to (2**N)-1 loop
--        j_loop:
--            for j in 0 to (2**N)-1 loop
--                A <= std_logic_vector(to_unsigned(i, N));    
--                B <= std_logic_vector(to_unsigned(j, N)); 
--                wait for 10 ns;
--                if ((i+j) >= 2**N) then
--                    assert c_out = '1' report "Error carry expected 1 found 0";
--                else
--                    assert c_out = '0' report "Error carry expected 0 found 1";
--                end if;
--            end loop j_loop;
--        end loop i_loop; 
--        wait;
--    end process;
end Behavioral;
