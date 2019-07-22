library ieee;
use ieee.std_logic_1164.all;

entity core_tb is
end core_tb;

architecture behavioral of core_tb is
    component sim_clk is
        generic
        (
            PERIOD      : time := 10 ns;
            REPORT_TIME : time := 10 us
        );
        port(clk_out : out std_logic);
    end component;

    component core is
        port
        (
            clk        : in std_logic;

            data_in    : in std_logic_vector(7 downto 0);
            data_out   : out std_logic_vector(7 downto 0);

            status_in  : in std_logic_vector(7 downto 0);
            status_out : out std_logic_vector(7 downto 0)
        );
    end component core;

    -- signals for the clock
    signal clk : std_logic := '0';

    -- signals for the worker core
    signal core_data_in    : std_logic_vector(7 downto 0) := (others => '0');
    signal core_data_out   : std_logic_vector(7 downto 0) := (others => '0');
    signal core_status_in  : std_logic_vector(7 downto 0) := (others => '0');
    signal core_status_out : std_logic_vector(7 downto 0) := (others => '0');
begin
    sim_clk_gen : sim_clk
        port map (clk_out => clk);

    UUT : core
        port map
        (
            clk        => clk,

            data_in    => core_data_in,
            data_out   => core_data_out,

            status_in  => core_status_in,
            status_out => core_status_out
        );

    simulate : process
    begin
        wait until rising_edge(clk);

        core_status_in <= "10000000";

        wait until core_status_out = "10000000";
        wait until rising_edge(clk); -- needed for the processor to wake up
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);

        wait until rising_edge(clk); -- OUTPUTK 00,     op_self_status
        core_status_in <= "00000000";
        wait until rising_edge(clk);

        wait until rising_edge(clk); -- ADD     s0,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- SUB     sF,     01
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- FETCH   s0,     (sF)
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- OUTPUT  s0,     op_self_data
        core_data_in <= x"FF";
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- COMPARE sF,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- JUMP    NZ,     send_ipc_data_loop
        wait until rising_edge(clk);

        wait until rising_edge(clk); -- ADD     s0,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- SUB     sF,     01
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- FETCH   s0,     (sF)
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- OUTPUT  s0,     op_self_data
        core_data_in <= x"01";
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- COMPARE sF,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- JUMP    NZ,     send_ipc_data_loop
        wait until rising_edge(clk);

        wait until rising_edge(clk); -- ADD     s0,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- SUB     sF,     01
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- FETCH   s0,     (sF)
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- OUTPUT  s0,     op_self_data
        core_data_in <= x"02";
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- COMPARE sF,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- JUMP    NZ,     send_ipc_data_loop
        wait until rising_edge(clk);

        wait until rising_edge(clk); -- ADD     s0,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- SUB     sF,     01
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- FETCH   s0,     (sF)
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- OUTPUT  s0,     op_self_data
        core_data_in <= x"03";
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- COMPARE sF,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- JUMP    NZ,     send_ipc_data_loop
        wait until rising_edge(clk);

        wait until rising_edge(clk); -- ADD     s0,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- SUB     sF,     01
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- FETCH   s0,     (sF)
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- OUTPUT  s0,     op_self_data
        core_data_in <= x"04";
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- COMPARE sF,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- JUMP    NZ,     send_ipc_data_loop
        wait until rising_edge(clk);

        wait until rising_edge(clk); -- ADD     s0,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- SUB     sF,     01
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- FETCH   s0,     (sF)
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- OUTPUT  s0,     op_self_data
        core_data_in <= x"05";
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- COMPARE sF,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- JUMP    NZ,     send_ipc_data_loop
        wait until rising_edge(clk);

        wait until rising_edge(clk); -- ADD     s0,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- SUB     sF,     01
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- FETCH   s0,     (sF)
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- OUTPUT  s0,     op_self_data
        core_data_in <= x"06";
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- COMPARE sF,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- JUMP    NZ,     send_ipc_data_loop
        wait until rising_edge(clk);

        wait until rising_edge(clk); -- ADD     s0,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- SUB     sF,     01
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- FETCH   s0,     (sF)
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- OUTPUT  s0,     op_self_data
        core_data_in <= x"07";
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- COMPARE sF,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- JUMP    NZ,     send_ipc_data_loop
        wait until rising_edge(clk);

        wait until rising_edge(clk); -- ADD     s0,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- SUB     sF,     01
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- FETCH   s0,     (sF)
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- OUTPUT  s0,     op_self_data
        core_data_in <= x"08";
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- COMPARE sF,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- JUMP    NZ,     send_ipc_data_loop
        wait until rising_edge(clk);

        wait until rising_edge(clk); -- ADD     s0,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- SUB     sF,     01
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- FETCH   s0,     (sF)
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- OUTPUT  s0,     op_self_data
        core_data_in <= x"09";
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- COMPARE sF,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- JUMP    NZ,     send_ipc_data_loop
        wait until rising_edge(clk);

        wait until rising_edge(clk); -- ADD     s0,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- SUB     sF,     01
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- FETCH   s0,     (sF)
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- OUTPUT  s0,     op_self_data
        core_data_in <= x"0A";
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- COMPARE sF,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- JUMP    NZ,     send_ipc_data_loop
        wait until rising_edge(clk);

        wait until rising_edge(clk); -- ADD     s0,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- SUB     sF,     01
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- FETCH   s0,     (sF)
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- OUTPUT  s0,     op_self_data
        core_data_in <= x"0B";
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- COMPARE sF,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- JUMP    NZ,     send_ipc_data_loop
        wait until rising_edge(clk);

        wait until rising_edge(clk); -- ADD     s0,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- SUB     sF,     01
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- FETCH   s0,     (sF)
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- OUTPUT  s0,     op_self_data
        core_data_in <= x"0C";
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- COMPARE sF,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- JUMP    NZ,     send_ipc_data_loop
        wait until rising_edge(clk);

        wait until rising_edge(clk); -- ADD     s0,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- SUB     sF,     01
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- FETCH   s0,     (sF)
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- OUTPUT  s0,     op_self_data
        core_data_in <= x"0D";
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- COMPARE sF,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- JUMP    NZ,     send_ipc_data_loop
        wait until rising_edge(clk);

        wait until rising_edge(clk); -- ADD     s0,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- SUB     sF,     01
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- FETCH   s0,     (sF)
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- OUTPUT  s0,     op_self_data
        core_data_in <= x"0E";
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- COMPARE sF,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- JUMP    NZ,     send_ipc_data_loop
        wait until rising_edge(clk);

        wait until rising_edge(clk); -- ADD     s0,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- SUB     sF,     01
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- FETCH   s0,     (sF)
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- OUTPUT  s0,     op_self_data
        core_data_in <= x"0F";
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- COMPARE sF,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- JUMP    NZ,     send_ipc_data_loop
        wait until rising_edge(clk);

        wait until rising_edge(clk); -- ADD     s0,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- SUB     sF,     01
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- FETCH   s0,     (sF)
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- OUTPUT  s0,     op_self_data
        core_data_in <= x"FF";
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- COMPARE sF,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- JUMP    NZ,     send_ipc_data_loop
        wait until rising_edge(clk);

        wait until rising_edge(clk); -- ADD     s0,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- SUB     sF,     01
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- FETCH   s0,     (sF)
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- OUTPUT  s0,     op_self_data
        core_data_in <= x"01";
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- COMPARE sF,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- JUMP    NZ,     send_ipc_data_loop
        wait until rising_edge(clk);

        wait until rising_edge(clk); -- ADD     s0,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- SUB     sF,     01
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- FETCH   s0,     (sF)
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- OUTPUT  s0,     op_self_data
        core_data_in <= x"02";
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- COMPARE sF,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- JUMP    NZ,     send_ipc_data_loop
        wait until rising_edge(clk);

        wait until rising_edge(clk); -- ADD     s0,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- SUB     sF,     01
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- FETCH   s0,     (sF)
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- OUTPUT  s0,     op_self_data
        core_data_in <= x"03";
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- COMPARE sF,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- JUMP    NZ,     send_ipc_data_loop
        wait until rising_edge(clk);

        wait until rising_edge(clk); -- ADD     s0,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- SUB     sF,     01
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- FETCH   s0,     (sF)
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- OUTPUT  s0,     op_self_data
        core_data_in <= x"04";
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- COMPARE sF,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- JUMP    NZ,     send_ipc_data_loop
        wait until rising_edge(clk);

        wait until rising_edge(clk); -- ADD     s0,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- SUB     sF,     01
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- FETCH   s0,     (sF)
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- OUTPUT  s0,     op_self_data
        core_data_in <= x"05";
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- COMPARE sF,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- JUMP    NZ,     send_ipc_data_loop
        wait until rising_edge(clk);

        wait until rising_edge(clk); -- ADD     s0,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- SUB     sF,     01
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- FETCH   s0,     (sF)
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- OUTPUT  s0,     op_self_data
        core_data_in <= x"06";
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- COMPARE sF,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- JUMP    NZ,     send_ipc_data_loop
        wait until rising_edge(clk);

        wait until rising_edge(clk); -- ADD     s0,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- SUB     sF,     01
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- FETCH   s0,     (sF)
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- OUTPUT  s0,     op_self_data
        core_data_in <= x"07";
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- COMPARE sF,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- JUMP    NZ,     send_ipc_data_loop
        wait until rising_edge(clk);

        wait until rising_edge(clk); -- ADD     s0,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- SUB     sF,     01
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- FETCH   s0,     (sF)
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- OUTPUT  s0,     op_self_data
        core_data_in <= x"08";
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- COMPARE sF,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- JUMP    NZ,     send_ipc_data_loop
        wait until rising_edge(clk);

        wait until rising_edge(clk); -- ADD     s0,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- SUB     sF,     01
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- FETCH   s0,     (sF)
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- OUTPUT  s0,     op_self_data
        core_data_in <= x"09";
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- COMPARE sF,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- JUMP    NZ,     send_ipc_data_loop
        wait until rising_edge(clk);

        wait until rising_edge(clk); -- ADD     s0,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- SUB     sF,     01
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- FETCH   s0,     (sF)
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- OUTPUT  s0,     op_self_data
        core_data_in <= x"0A";
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- COMPARE sF,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- JUMP    NZ,     send_ipc_data_loop
        wait until rising_edge(clk);

        wait until rising_edge(clk); -- ADD     s0,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- SUB     sF,     01
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- FETCH   s0,     (sF)
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- OUTPUT  s0,     op_self_data
        core_data_in <= x"0B";
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- COMPARE sF,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- JUMP    NZ,     send_ipc_data_loop
        wait until rising_edge(clk);

        wait until rising_edge(clk); -- ADD     s0,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- SUB     sF,     01
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- FETCH   s0,     (sF)
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- OUTPUT  s0,     op_self_data
        core_data_in <= x"0C";
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- COMPARE sF,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- JUMP    NZ,     send_ipc_data_loop
        wait until rising_edge(clk);

        wait until rising_edge(clk); -- ADD     s0,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- SUB     sF,     01
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- FETCH   s0,     (sF)
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- OUTPUT  s0,     op_self_data
        core_data_in <= x"0D";
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- COMPARE sF,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- JUMP    NZ,     send_ipc_data_loop
        wait until rising_edge(clk);

        wait until rising_edge(clk); -- ADD     s0,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- SUB     sF,     01
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- FETCH   s0,     (sF)
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- OUTPUT  s0,     op_self_data
        core_data_in <= x"0E";
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- COMPARE sF,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- JUMP    NZ,     send_ipc_data_loop
        wait until rising_edge(clk);

        wait until rising_edge(clk); -- ADD     s0,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- SUB     sF,     01
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- FETCH   s0,     (sF)
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- OUTPUT  s0,     op_self_data
        core_data_in <= x"0F";
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- COMPARE sF,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- JUMP    NZ,     send_ipc_data_loop
        wait until rising_edge(clk);

        wait until rising_edge(clk); -- ADD     s0,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- SUB     sF,     01
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- FETCH   s0,     (sF)
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- OUTPUT  s0,     op_self_data
        core_data_in <= x"FF";
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- COMPARE sF,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- JUMP    NZ,     send_ipc_data_loop
        wait until rising_edge(clk);

        wait until rising_edge(clk); -- ADD     s0,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- SUB     sF,     01
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- FETCH   s0,     (sF)
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- OUTPUT  s0,     op_self_data
        core_data_in <= x"01";
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- COMPARE sF,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- JUMP    NZ,     send_ipc_data_loop
        wait until rising_edge(clk);

        wait until rising_edge(clk); -- ADD     s0,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- SUB     sF,     01
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- FETCH   s0,     (sF)
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- OUTPUT  s0,     op_self_data
        core_data_in <= x"02";
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- COMPARE sF,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- JUMP    NZ,     send_ipc_data_loop
        wait until rising_edge(clk);

        wait until rising_edge(clk); -- ADD     s0,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- SUB     sF,     01
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- FETCH   s0,     (sF)
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- OUTPUT  s0,     op_self_data
        core_data_in <= x"03";
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- COMPARE sF,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- JUMP    NZ,     send_ipc_data_loop
        wait until rising_edge(clk);

        wait until rising_edge(clk); -- ADD     s0,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- SUB     sF,     01
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- FETCH   s0,     (sF)
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- OUTPUT  s0,     op_self_data
        core_data_in <= x"04";
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- COMPARE sF,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- JUMP    NZ,     send_ipc_data_loop
        wait until rising_edge(clk);

        wait until rising_edge(clk); -- ADD     s0,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- SUB     sF,     01
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- FETCH   s0,     (sF)
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- OUTPUT  s0,     op_self_data
        core_data_in <= x"05";
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- COMPARE sF,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- JUMP    NZ,     send_ipc_data_loop
        wait until rising_edge(clk);

        wait until rising_edge(clk); -- ADD     s0,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- SUB     sF,     01
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- FETCH   s0,     (sF)
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- OUTPUT  s0,     op_self_data
        core_data_in <= x"06";
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- COMPARE sF,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- JUMP    NZ,     send_ipc_data_loop
        wait until rising_edge(clk);

        wait until rising_edge(clk); -- ADD     s0,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- SUB     sF,     01
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- FETCH   s0,     (sF)
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- OUTPUT  s0,     op_self_data
        core_data_in <= x"07";
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- COMPARE sF,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- JUMP    NZ,     send_ipc_data_loop
        wait until rising_edge(clk);

        wait until rising_edge(clk); -- ADD     s0,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- SUB     sF,     01
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- FETCH   s0,     (sF)
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- OUTPUT  s0,     op_self_data
        core_data_in <= x"08";
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- COMPARE sF,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- JUMP    NZ,     send_ipc_data_loop
        wait until rising_edge(clk);

        wait until rising_edge(clk); -- ADD     s0,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- SUB     sF,     01
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- FETCH   s0,     (sF)
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- OUTPUT  s0,     op_self_data
        core_data_in <= x"09";
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- COMPARE sF,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- JUMP    NZ,     send_ipc_data_loop
        wait until rising_edge(clk);

        wait until rising_edge(clk); -- ADD     s0,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- SUB     sF,     01
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- FETCH   s0,     (sF)
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- OUTPUT  s0,     op_self_data
        core_data_in <= x"0A";
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- COMPARE sF,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- JUMP    NZ,     send_ipc_data_loop
        wait until rising_edge(clk);

        wait until rising_edge(clk); -- ADD     s0,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- SUB     sF,     01
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- FETCH   s0,     (sF)
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- OUTPUT  s0,     op_self_data
        core_data_in <= x"0B";
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- COMPARE sF,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- JUMP    NZ,     send_ipc_data_loop
        wait until rising_edge(clk);

        wait until rising_edge(clk); -- ADD     s0,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- SUB     sF,     01
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- FETCH   s0,     (sF)
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- OUTPUT  s0,     op_self_data
        core_data_in <= x"0C";
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- COMPARE sF,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- JUMP    NZ,     send_ipc_data_loop
        wait until rising_edge(clk);

        wait until rising_edge(clk); -- ADD     s0,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- SUB     sF,     01
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- FETCH   s0,     (sF)
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- OUTPUT  s0,     op_self_data
        core_data_in <= x"0D";
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- COMPARE sF,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- JUMP    NZ,     send_ipc_data_loop
        wait until rising_edge(clk);

        wait until rising_edge(clk); -- ADD     s0,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- SUB     sF,     01
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- FETCH   s0,     (sF)
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- OUTPUT  s0,     op_self_data
        core_data_in <= x"0E";
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- COMPARE sF,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- JUMP    NZ,     send_ipc_data_loop
        wait until rising_edge(clk);

        wait until rising_edge(clk); -- ADD     s0,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- SUB     sF,     01
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- FETCH   s0,     (sF)
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- OUTPUT  s0,     op_self_data
        core_data_in <= x"0F";
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- COMPARE sF,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- JUMP    NZ,     send_ipc_data_loop
        wait until rising_edge(clk);

        wait until rising_edge(clk); -- ADD     s0,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- SUB     sF,     01
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- FETCH   s0,     (sF)
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- OUTPUT  s0,     op_self_data
        core_data_in <= x"FF";
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- COMPARE sF,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- JUMP    NZ,     send_ipc_data_loop
        wait until rising_edge(clk);

        wait until rising_edge(clk); -- ADD     s0,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- SUB     sF,     01
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- FETCH   s0,     (sF)
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- OUTPUT  s0,     op_self_data
        core_data_in <= x"01";
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- COMPARE sF,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- JUMP    NZ,     send_ipc_data_loop
        wait until rising_edge(clk);

        wait until rising_edge(clk); -- ADD     s0,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- SUB     sF,     01
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- FETCH   s0,     (sF)
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- OUTPUT  s0,     op_self_data
        core_data_in <= x"02";
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- COMPARE sF,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- JUMP    NZ,     send_ipc_data_loop
        wait until rising_edge(clk);

        wait until rising_edge(clk); -- ADD     s0,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- SUB     sF,     01
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- FETCH   s0,     (sF)
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- OUTPUT  s0,     op_self_data
        core_data_in <= x"03";
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- COMPARE sF,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- JUMP    NZ,     send_ipc_data_loop
        wait until rising_edge(clk);

        wait until rising_edge(clk); -- ADD     s0,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- SUB     sF,     01
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- FETCH   s0,     (sF)
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- OUTPUT  s0,     op_self_data
        core_data_in <= x"04";
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- COMPARE sF,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- JUMP    NZ,     send_ipc_data_loop
        wait until rising_edge(clk);

        wait until rising_edge(clk); -- ADD     s0,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- SUB     sF,     01
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- FETCH   s0,     (sF)
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- OUTPUT  s0,     op_self_data
        core_data_in <= x"05";
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- COMPARE sF,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- JUMP    NZ,     send_ipc_data_loop
        wait until rising_edge(clk);

        wait until rising_edge(clk); -- ADD     s0,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- SUB     sF,     01
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- FETCH   s0,     (sF)
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- OUTPUT  s0,     op_self_data
        core_data_in <= x"06";
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- COMPARE sF,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- JUMP    NZ,     send_ipc_data_loop
        wait until rising_edge(clk);

        wait until rising_edge(clk); -- ADD     s0,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- SUB     sF,     01
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- FETCH   s0,     (sF)
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- OUTPUT  s0,     op_self_data
        core_data_in <= x"07";
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- COMPARE sF,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- JUMP    NZ,     send_ipc_data_loop
        wait until rising_edge(clk);

        wait until rising_edge(clk); -- ADD     s0,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- SUB     sF,     01
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- FETCH   s0,     (sF)
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- OUTPUT  s0,     op_self_data
        core_data_in <= x"08";
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- COMPARE sF,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- JUMP    NZ,     send_ipc_data_loop
        wait until rising_edge(clk);

        wait until rising_edge(clk); -- ADD     s0,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- SUB     sF,     01
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- FETCH   s0,     (sF)
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- OUTPUT  s0,     op_self_data
        core_data_in <= x"09";
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- COMPARE sF,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- JUMP    NZ,     send_ipc_data_loop
        wait until rising_edge(clk);

        wait until rising_edge(clk); -- ADD     s0,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- SUB     sF,     01
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- FETCH   s0,     (sF)
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- OUTPUT  s0,     op_self_data
        core_data_in <= x"0A";
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- COMPARE sF,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- JUMP    NZ,     send_ipc_data_loop
        wait until rising_edge(clk);

        wait until rising_edge(clk); -- ADD     s0,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- SUB     sF,     01
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- FETCH   s0,     (sF)
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- OUTPUT  s0,     op_self_data
        core_data_in <= x"0B";
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- COMPARE sF,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- JUMP    NZ,     send_ipc_data_loop
        wait until rising_edge(clk);

        wait until rising_edge(clk); -- ADD     s0,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- SUB     sF,     01
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- FETCH   s0,     (sF)
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- OUTPUT  s0,     op_self_data
        core_data_in <= x"0C";
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- COMPARE sF,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- JUMP    NZ,     send_ipc_data_loop
        wait until rising_edge(clk);

        wait until rising_edge(clk); -- ADD     s0,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- SUB     sF,     01
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- FETCH   s0,     (sF)
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- OUTPUT  s0,     op_self_data
        core_data_in <= x"0D";
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- COMPARE sF,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- JUMP    NZ,     send_ipc_data_loop
        wait until rising_edge(clk);

        wait until rising_edge(clk); -- ADD     s0,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- SUB     sF,     01
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- FETCH   s0,     (sF)
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- OUTPUT  s0,     op_self_data
        core_data_in <= x"0E";
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- COMPARE sF,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- JUMP    NZ,     send_ipc_data_loop
        wait until rising_edge(clk);

        wait until rising_edge(clk); -- ADD     s0,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- SUB     sF,     01
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- FETCH   s0,     (sF)
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- OUTPUT  s0,     op_self_data
        core_data_in <= x"0F";
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- COMPARE sF,     00
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- JUMP    NZ,     send_ipc_data_loop
        wait until rising_edge(clk);

        wait until rising_edge(clk); -- OUTPUTK cmd_send_done, op_self_status
        core_status_in <= "01000000";
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- OUTPUTK 00,     op_self_status
        core_status_in <= "00000000";
        wait until rising_edge(clk);

        wait for 2000 ms;

    end process simulate;

end behavioral;
