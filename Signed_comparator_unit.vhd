----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.07.2020 17:37:45
-- Design Name: 
-- Module Name: Signed_comparator_unit - Mixed
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Signed_comparator_unit is
    Generic (N: integer:= 32);
    Port (A: in std_logic_vector (N-1 downto 0);
          B: in std_logic_vector (N-1 downto 0);
          sign_unsign: in std_logic;--1-> signed comparator, 0-> unsigned.
          A_eq_B: out std_logic;
          A_not_equal_B: out std_logic;
          A_gr_B: out std_logic;
          A_gr_eq_B: out std_logic;
          A_low_B: out std_logic;
          A_low_equal_B: out std_logic);
end Signed_comparator_unit;

architecture Mixed of Signed_comparator_unit is

component Carry_out_network is
 Generic(N: integer:= 32); 
 Port (A: in std_logic_vector(N-1 downto 0);
       B: in std_logic_vector(N-1 downto 0);
       cin: in std_logic;
       cout: out std_logic);
end component;

signal b_compl: std_logic_vector (N-1 downto 0);
signal carry_out: std_logic;
signal A_xor_B: std_logic_vector(N-1 downto 0);
signal nor_network: std_logic_vector(N-3 downto 0);
signal tmp_a_eq_b: std_logic;
signal sign_a_b: std_logic_vector(1 downto 0);
begin
sign_a_b <= A(N-1)&B(N-1) when sign_unsign = '1' else
            "00";
b_compl <= not B;
A_xor_B <= A xor B;
nor_network(0) <= A_xor_B (0) or A_xor_B(1);
--Perform A-B (using two's complements of B).
Carry_out_net: Carry_out_network generic map (N)
                                 port map (A, b_compl, '1', carry_out);      
                                 
--To perform the equality without perform the difference, use a XORtoNOR network.
A_equal_B:
    for i in 1 to N-3 generate
        nor_network(i) <= nor_network(i-1) or A_xor_B(i+1);
    end generate A_equal_B;
--tmp_a_eq_b = 1 if A=B , 0 otherwise.
tmp_a_eq_b <= nor_network(N-3) nor A_xor_B(N-1);     
 

    process(sign_a_b, A, B, tmp_a_eq_b, carry_out)
    begin
        case sign_a_b is 
            when "00" =>
                --If both positive check as unsigned numbers.
                A_gr_eq_B <= carry_out;
                A_gr_B <= carry_out and (not tmp_a_eq_b);
                A_low_B <= not carry_out;   
                A_low_equal_B <= (not carry_out) or tmp_a_eq_b;
            when "01" =>
                --A > B.
                A_gr_eq_B <= '1';
                A_gr_B <= '1';
                A_low_B <= '0';
                A_low_equal_B <= '0';
            when "10" =>
                --A < B.
                A_gr_eq_B <= '0';
                A_gr_B <= '0';
                A_low_B <= '1';
                A_low_equal_B <= '1';
            when "11" =>
                --If both negative.
                A_gr_eq_B <= carry_out;
                A_gr_B <= carry_out and (not tmp_a_eq_b);
                A_low_B <= not carry_out;   
                A_low_equal_B <= (not carry_out) or tmp_a_eq_b;  
                
            when others =>
                 A_gr_eq_B <= carry_out;
                A_gr_B <= carry_out and (not tmp_a_eq_b);
                A_low_B <= not carry_out;   
                A_low_equal_B <= (not carry_out) or tmp_a_eq_b; 
        end case;
    end process;
    
A_eq_B <= tmp_a_eq_b;
A_not_equal_B <= not tmp_a_eq_b;

end Mixed;
