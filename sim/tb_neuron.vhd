library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_neuron is
end entity tb_neuron;

architecture sim of tb_neuron is
    constant CLK_PERIOD : time := 10 ns;

    signal clk    : std_logic := '0';
    signal rst    : std_logic := '0';
    signal x0     : signed(7 downto 0) := (others => '0');
    signal x1     : signed(7 downto 0) := (others => '0');
    signal w0     : signed(7 downto 0) := (others => '0');
    signal w1     : signed(7 downto 0) := (others => '0');
    signal b      : signed(7 downto 0) := (others => '0');
    signal output : signed(7 downto 0);
begin
    uut: entity work.neuron_2in_relu
        generic map (
            DATA_WIDTH => 8,
            ACC_WIDTH  => 16
        )
        port map (
            clk    => clk,
            rst    => rst,
            x0     => x0,
            x1     => x1,
            w0     => w0,
            w1     => w1,
            b      => b,
            output => output
        );

    clk_process: process
    begin
        while now < 500 ns loop
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process;

    stim_proc: process
    begin
        rst <= '1';
        wait for CLK_PERIOD;
        rst <= '0';
        wait for CLK_PERIOD;

        x0 <= to_signed(3, 8);
        x1 <= to_signed(5, 8);
        w0 <= to_signed(4, 8);
        w1 <= to_signed(6, 8);
        b  <= to_signed(10, 8);
        wait for CLK_PERIOD;
        assert output = to_signed(52, 8) report "Test 1 failed" severity error;

        x0 <= to_signed(3, 8);
        x1 <= to_signed(5, 8);
        w0 <= to_signed(4, 8);
        w1 <= to_signed(6, 8);
        b  <= to_signed(-60, 8);
        wait for CLK_PERIOD;
        assert output = to_signed(0, 8) report "Test 2 failed" severity error;

        x0 <= to_signed(5, 8);
        x1 <= to_signed(4, 8);
        w0 <= to_signed(-2, 8);
        w1 <= to_signed(-3, 8);
        b  <= to_signed(10, 8);
        wait for CLK_PERIOD;
        assert output = to_signed(0, 8) report "Test 3 failed" severity error;

        x0 <= to_signed(10, 8);
        x1 <= to_signed(10, 8);
        w0 <= to_signed(10, 8);
        w1 <= to_signed(10, 8);
        b  <= to_signed(50, 8);
        wait for CLK_PERIOD;
        assert output = to_signed(127, 8) report "Test 4 failed" severity error;

        x0 <= to_signed(10, 8);
        x1 <= to_signed(3, 8);
        w0 <= to_signed(10, 8);
        w1 <= to_signed(9, 8);
        b  <= to_signed(0, 8);
        wait for CLK_PERIOD;
        assert output = to_signed(127, 8) report "Test 5 failed" severity error;

        x0 <= to_signed(0, 8);
        x1 <= to_signed(0, 8);
        w0 <= to_signed(0, 8);
        w1 <= to_signed(0, 8);
        b  <= to_signed(0, 8);
        wait for CLK_PERIOD;
        assert output = to_signed(0, 8) report "Test 6 failed" severity error;

        x0 <= to_signed(0, 8);
        x1 <= to_signed(0, 8);
        w0 <= to_signed(5, 8);
        w1 <= to_signed(5, 8);
        b  <= to_signed(42, 8);
        wait for CLK_PERIOD;
        assert output = to_signed(42, 8) report "Test 7 failed" severity error;

        x0 <= to_signed(-5, 8);
        x1 <= to_signed(10, 8);
        w0 <= to_signed(4, 8);
        w1 <= to_signed(4, 8);
        b  <= to_signed(0, 8);
        wait for CLK_PERIOD;
        assert output = to_signed(20, 8) report "Test 8 failed" severity error;

        x0 <= to_signed(127, 8);
        x1 <= to_signed(127, 8);
        w0 <= to_signed(1, 8);
        w1 <= to_signed(1, 8);
        b  <= to_signed(0, 8);
        wait for CLK_PERIOD;
        assert output = to_signed(127, 8) report "Test 9 failed" severity error;

        report "ALL 9 TESTS PASSED" severity note;
        wait;
    end process;
end architecture sim;
