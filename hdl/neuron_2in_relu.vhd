library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity neuron_2in_relu is
    generic (
        DATA_WIDTH : integer := 8;
        ACC_WIDTH  : integer := 16
    );
    port (
        clk    : in  std_logic;
        rst    : in  std_logic := '0';
        x0     : in  signed(DATA_WIDTH-1 downto 0);
        x1     : in  signed(DATA_WIDTH-1 downto 0);
        w0     : in  signed(DATA_WIDTH-1 downto 0);
        w1     : in  signed(DATA_WIDTH-1 downto 0);
        b      : in  signed(DATA_WIDTH-1 downto 0);
        output : out signed(DATA_WIDTH-1 downto 0)
    );
end entity neuron_2in_relu;

architecture rtl of neuron_2in_relu is
    constant MAX_VAL : signed(ACC_WIDTH-1 downto 0) := to_signed(2**(DATA_WIDTH-1) - 1, ACC_WIDTH);

    signal p0       : signed(ACC_WIDTH-1 downto 0);
    signal p1       : signed(ACC_WIDTH-1 downto 0);
    signal b_ext    : signed(ACC_WIDTH-1 downto 0);
    signal sum_p    : signed(ACC_WIDTH-1 downto 0);
    signal z_sum    : signed(ACC_WIDTH-1 downto 0);
    signal relu_out : signed(ACC_WIDTH-1 downto 0);
    signal sat_out  : signed(DATA_WIDTH-1 downto 0);
begin
    p0 <= x0 * w0;
    p1 <= x1 * w1;
    b_ext <= resize(b, ACC_WIDTH);

    sum_p <= p0 + p1;
    z_sum <= sum_p + b_ext;

    relu_out <= (others => '0') when z_sum < 0 else z_sum;
    sat_out  <= to_signed(2**(DATA_WIDTH-1) - 1, DATA_WIDTH) when relu_out > MAX_VAL
                else resize(relu_out, DATA_WIDTH);

    process(clk, rst)
    begin
        if rst = '1' then
            output <= (others => '0');
        elsif rising_edge(clk) then
            output <= sat_out;
        end if;
    end process;
end architecture rtl;
