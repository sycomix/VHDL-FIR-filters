----------------------------------------------------------------------------------
-- Testbench for ParallelPolyphase

-- Initial version: Colm Ryan (cryan@bbn.com)
-- Create Date: 05/05/2015

-- Dependencies:
--
--
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

use work.DataTypes.all;

entity FIR_tb is
--  Port ( );
end FIR_tb;

architecture Behavioral of FIR_tb is

constant coeffs : integer_vector := (2, 3, 4, 5, 6);

signal rst : std_logic := '0';
signal clk : std_logic := '0';
signal finished : boolean := false;

signal data_in : std_logic_vector(15 downto 0) := (others => '0');
signal data_out : std_logic_vector(47 downto 0);

begin

  dut : entity work.FIR_DirectTranspose
    generic map(coeffs => coeffs, data_in_width=>16)
    port map (
      rst => rst,
      clk => clk,
      data_in => data_in,
      data_in_vld => '0',
      data_in_last => '0',
      data_out => data_out);

  stim : process
  begin
    rst <= '1';
    wait for 100ns;
    rst <= '0';

    wait until rising_edge(clk);
    sampleDriver : for ct in 1 to 16 loop
      data_in <= std_logic_vector(to_signed(ct, 16));
      wait until rising_edge(clk);
    end loop;
    data_in <= (others => '0');

    wait for 1us;
    finished <= true;
  end process;

  --clock generation
  clk <= not clk after 10ns when not finished;

end Behavioral;
