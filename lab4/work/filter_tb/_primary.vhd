library verilog;
use verilog.vl_types.all;
entity filter_tb is
    generic(
        clk_period      : integer := 10;
        clk_hold        : integer := 2;
        MAX_ERROR_COUNT : integer := 3149
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of clk_period : constant is 1;
    attribute mti_svvh_generic_type of clk_hold : constant is 1;
    attribute mti_svvh_generic_type of MAX_ERROR_COUNT : constant is 1;
end filter_tb;
