library verilog;
use verilog.vl_types.all;
entity filter is
    generic(
        coeff1          : vl_logic_vector(5 downto 0) := (Hi1, Hi1, Hi1, Hi1, Hi0, Hi1);
        coeff2          : vl_logic_vector(5 downto 0) := (Hi1, Hi1, Hi1, Hi0, Hi0, Hi0);
        coeff3          : vl_logic_vector(5 downto 0) := (Hi1, Hi1, Hi1, Hi0, Hi0, Hi0);
        coeff4          : vl_logic_vector(5 downto 0) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0);
        coeff5          : vl_logic_vector(5 downto 0) := (Hi0, Hi0, Hi1, Hi0, Hi1, Hi1);
        coeff6          : vl_logic_vector(5 downto 0) := (Hi0, Hi1, Hi0, Hi0, Hi0, Hi0);
        coeff7          : vl_logic_vector(5 downto 0) := (Hi0, Hi0, Hi1, Hi0, Hi1, Hi1);
        coeff8          : vl_logic_vector(5 downto 0) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0);
        coeff9          : vl_logic_vector(5 downto 0) := (Hi1, Hi1, Hi1, Hi0, Hi0, Hi0);
        coeff10         : vl_logic_vector(5 downto 0) := (Hi1, Hi1, Hi1, Hi0, Hi0, Hi0);
        coeff11         : vl_logic_vector(5 downto 0) := (Hi1, Hi1, Hi1, Hi1, Hi0, Hi1)
    );
    port(
        clk             : in     vl_logic;
        clk_enable      : in     vl_logic;
        reset           : in     vl_logic;
        filter_in       : in     vl_logic_vector(17 downto 0);
        filter_out      : out    vl_logic_vector(17 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of coeff1 : constant is 2;
    attribute mti_svvh_generic_type of coeff2 : constant is 2;
    attribute mti_svvh_generic_type of coeff3 : constant is 2;
    attribute mti_svvh_generic_type of coeff4 : constant is 2;
    attribute mti_svvh_generic_type of coeff5 : constant is 2;
    attribute mti_svvh_generic_type of coeff6 : constant is 2;
    attribute mti_svvh_generic_type of coeff7 : constant is 2;
    attribute mti_svvh_generic_type of coeff8 : constant is 2;
    attribute mti_svvh_generic_type of coeff9 : constant is 2;
    attribute mti_svvh_generic_type of coeff10 : constant is 2;
    attribute mti_svvh_generic_type of coeff11 : constant is 2;
end filter;
