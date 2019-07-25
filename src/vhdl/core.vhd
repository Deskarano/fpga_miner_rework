-- args: --ieee=synopsys -fexplicit

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity core is
    port
    (
        clk        : in std_logic;

        data_in    : in std_logic_vector(7 downto 0);
        data_out   : out std_logic_vector(7 downto 0);

        status_in  : in std_logic_vector(7 downto 0);
        status_out : out std_logic_vector(7 downto 0)
    );
end core;

architecture behavioral of core is
    component kcpsm6 is
        generic
        (
            hwbuild                 : std_logic_vector(7 downto 0) := X"00";
            interrupt_vector        : std_logic_vector(11 downto 0) := X"3FF";
            scratch_pad_memory_size : integer := 64
        );
        port
        (
            address        : out std_logic_vector(11 downto 0);
            instruction    : in std_logic_vector(17 downto 0);
            bram_enable    : out std_logic;
            in_port        : in std_logic_vector(7 downto 0);
            out_port       : out std_logic_vector(7 downto 0);
            port_id        : out std_logic_vector(7 downto 0);
            write_strobe   : out std_logic;
            k_write_strobe : out std_logic;
            read_strobe    : out std_logic;
            interrupt      : in std_logic;
            interrupt_ack  : out std_logic;
            sleep          : in std_logic;
            reset          : in std_logic;
            clk            : in std_logic
        );
    end component kcpsm6;

    component core_prog is
        generic
        (
            C_FAMILY          : string  := "S6";
            C_RAM_SIZE_KWORDS : integer := 1
        );

        port
        (
            address      : in std_logic_vector(11 downto 0);
            instruction  : out std_logic_vector(17 downto 0);
            enable       : in std_logic;
            clk          : in std_logic;

            address_b    : in std_logic_vector(15 downto 0);
            data_in_b    : in std_logic_vector(31 downto 0);
            parity_in_b  : in std_logic_vector(3 downto 0);
            data_out_b   : out std_logic_vector(31 downto 0);
            parity_out_b : out std_logic_vector(3 downto 0);
            enable_b     : in std_logic;
            we_b         : in std_logic_vector(3 downto 0)
        );
    end component core_prog;

    component msa_extender is
        port
        (
            clk      : in std_logic;
            reset    : in std_logic;

            data_val : in std_logic;
            data_in  : in std_logic_vector(31 downto 0);

            msa_out  :  out std_logic_vector(31 downto 0)
        );
    end component msa_extender;

    -- signals for the processor
    signal address        : std_logic_vector(11 downto 0) := (others => '0');
    signal instruction    : std_logic_vector(17 downto 0) := (others => '0');
    signal bram_enable    : std_logic                     := '0';
    signal in_port        : std_logic_vector(7 downto 0)  := (others => '0');
    signal out_port       : std_logic_vector(7 downto 0)  := (others => '0');
    signal port_id        : std_logic_vector(7 downto 0)  := (others => '0');
    signal write_strobe   : std_logic                     := '0';
    signal k_write_strobe : std_logic                     := '0';
    signal read_strobe    : std_logic                     := '0';
    signal interrupt      : std_logic                     := '0';
    signal interrupt_ack  : std_logic                     := '0';
    signal kcpsm6_sleep   : std_logic                     := '0';
    signal kcpsm6_reset   : std_logic                     := '0';

    -- signals for the memory
    signal bram_we         : std_logic_vector(3 downto 0)  := (others => '0');
    signal bram_addr_in    : std_logic_vector(15 downto 0) := (others => '0');
    signal bram_data_out   : std_logic_vector(31 downto 0) := (others => '0');
    signal bram_parity_out : std_logic_vector(3 downto 0)  := (others => '0');

    signal addr_buf        : std_logic_vector(7 downto 0) := (others => '0');
    signal data_buf        : std_logic_vector(31 downto 0) := (others => '0');
    signal parity_buf      : std_logic_vector(3 downto 0)  := (others => '0');

    -- status and data out buffers
    signal status_out_buf : std_logic_vector(7 downto 0) := (others => '0');
    signal data_out_buf   : std_logic_vector(7 downto 0) := (others => '0');

    -- random other buffers
    signal buf_select  : std_logic_vector(3 downto 0)  := (others => '0');
    signal read_buf    : std_logic_vector(31 downto 0) := (others => '0');

    signal msa_out_buf : std_logic_vector(31 downto 0) := (others => '0');

    signal hash_a_buf  : std_logic_vector(31 downto 0) := (others => '0');
    signal hash_b_buf  : std_logic_vector(31 downto 0) := (others => '0');
    signal hash_c_buf  : std_logic_vector(31 downto 0) := (others => '0');
    signal hash_d_buf  : std_logic_vector(31 downto 0) := (others => '0');
    signal hash_e_buf  : std_logic_vector(31 downto 0) := (others => '0');
    signal hash_f_buf  : std_logic_vector(31 downto 0) := (others => '0');
    signal hash_g_buf  : std_logic_vector(31 downto 0) := (others => '0');
    signal hash_h_buf  : std_logic_vector(31 downto 0) := (others => '0');

    signal hash_rc_buf  : std_logic_vector(31 downto 0) := (others => '0');
    signal hash_msa_buf : std_logic_vector(31 downto 0) := (others => '0');

    signal S1           : std_logic_vector(31 downto 0) := (others => '0');
    signal ch           : std_logic_vector(31 downto 0) := (others => '0');
    signal temp1        : std_logic_vector(31 downto 0) := (others => '0');

    signal S0           : std_logic_vector(31 downto 0) := (others => '0');
    signal maj          : std_logic_vector(31 downto 0) := (others => '0');
    signal temp2        : std_logic_vector(31 downto 0) := (others => '0');

begin
    bram_addr_in <= "111" & addr_buf & "11111";
    bram_we      <= status_out_buf(5) & status_out_buf(5) &
                    status_out_buf(5) & status_out_buf(5);

    data_out   <= data_out_buf;
    status_out <= status_out_buf;

    interrupt <= interrupt_ack;

    picoblaze : kcpsm6
        generic map
        (
            hwbuild                 => X"00",
            interrupt_vector        => X"7D1",
            scratch_pad_memory_size => 64
        )

        port map
        (
            address        => address,
            instruction    => instruction,
            bram_enable    => bram_enable,
            port_id        => port_id,
            write_strobe   => write_strobe,
            k_write_strobe => k_write_strobe,
            out_port       => out_port,
            read_strobe    => read_strobe,
            in_port        => in_port,
            interrupt      => interrupt,
            interrupt_ack  => interrupt_ack,
            sleep          => kcpsm6_sleep,
            reset          => kcpsm6_reset,
            clk            => clk
        );

    program : core_prog
        generic map
        (
            C_FAMILY             => "7S",
            C_RAM_SIZE_KWORDS    => 2
        )

        port map
        (
            address     => address,
            instruction => instruction,
            enable      => bram_enable,
            clk         => clk,

            address_b    => bram_addr_in,
            data_in_b    => data_buf,
            parity_in_b  => parity_buf,
            data_out_b   => bram_data_out,
            parity_out_b => bram_parity_out,
            enable_b     => '1',
            we_b         => bram_we
        );

    extend_msa : msa_extender
        port map
        (
            clk      => clk,
            reset    => status_out_buf(4),

            data_val => status_out_buf(3),
            data_in  => bram_data_out,

            msa_out  => msa_out_buf
        );

    synchronize : process(clk)
    begin
        if rising_edge(clk) then
            kcpsm6_sleep <= status_out_buf(7) and not status_in(7);
        end if;
    end process synchronize;

    S1    <= std_logic_vector(rotate_right(unsigned(hash_e_buf), 6))  xor
             std_logic_vector(rotate_right(unsigned(hash_e_buf), 11)) xor
             std_logic_vector(rotate_right(unsigned(hash_e_buf), 25));
    ch    <= (hash_e_buf and hash_f_buf) xor ((not hash_e_buf) and hash_g_buf);
    temp1 <= hash_h_buf + S1 + ch + hash_rc_buf + hash_msa_buf;

    S0    <= std_logic_vector(rotate_right(unsigned(hash_a_buf), 2))  xor
             std_logic_vector(rotate_right(unsigned(hash_a_buf), 13)) xor
             std_logic_vector(rotate_right(unsigned(hash_a_buf), 22));
    maj   <= (hash_a_buf and hash_b_buf) xor (hash_a_buf and hash_c_buf) xor
             (hash_b_buf and hash_c_buf);
    temp2 <= S0 + maj;

    handle_hashing : process(clk)
    begin
        if rising_edge(clk) then
            -- update hash buffers if they're currently being written to
            if write_strobe = '1' or k_write_strobe = '1' then
                case port_id(2 downto 0) is
                    when "001" =>
                        if out_port(4) = '1' then
                            hash_a_buf <= (others => '0');
                            hash_b_buf <= (others => '0');
                            hash_c_buf <= (others => '0');
                            hash_d_buf <= (others => '0');
                            hash_e_buf <= (others => '0');
                            hash_f_buf <= (others => '0');
                            hash_g_buf <= (others => '0');
                            hash_h_buf <= (others => '0');
                        end if;

                    when "100" =>
                        case buf_select is
                            when "0010" => hash_a_buf(7 downto 0) <= out_port;
                            when "0011" => hash_b_buf(7 downto 0) <= out_port;
                            when "0100" => hash_c_buf(7 downto 0) <= out_port;
                            when "0101" => hash_d_buf(7 downto 0) <= out_port;
                            when "0110" => hash_e_buf(7 downto 0) <= out_port;
                            when "0111" => hash_f_buf(7 downto 0) <= out_port;
                            when "1000" => hash_g_buf(7 downto 0) <= out_port;
                            when "1001" => hash_h_buf(7 downto 0) <= out_port;
                            when others => NULL;
                        end case;

                    when "101" =>
                        case buf_select is
                            when "0010" => hash_a_buf(15 downto 8) <= out_port;
                            when "0011" => hash_b_buf(15 downto 8) <= out_port;
                            when "0100" => hash_c_buf(15 downto 8) <= out_port;
                            when "0101" => hash_d_buf(15 downto 8) <= out_port;
                            when "0110" => hash_e_buf(15 downto 8) <= out_port;
                            when "0111" => hash_f_buf(15 downto 8) <= out_port;
                            when "1000" => hash_g_buf(15 downto 8) <= out_port;
                            when "1001" => hash_h_buf(15 downto 8) <= out_port;
                            when others => NULL;
                        end case;

                    when "110" =>
                        case buf_select is
                            when "0010" => hash_a_buf(23 downto 16) <= out_port;
                            when "0011" => hash_b_buf(23 downto 16) <= out_port;
                            when "0100" => hash_c_buf(23 downto 16) <= out_port;
                            when "0101" => hash_d_buf(23 downto 16) <= out_port;
                            when "0110" => hash_e_buf(23 downto 16) <= out_port;
                            when "0111" => hash_f_buf(23 downto 16) <= out_port;
                            when "1000" => hash_g_buf(23 downto 16) <= out_port;
                            when "1001" => hash_h_buf(23 downto 16) <= out_port;
                            when others => NULL;
                        end case;

                    when "111" =>
                        case buf_select is
                            when "0010" => hash_a_buf(31 downto 24) <= out_port;
                            when "0011" => hash_b_buf(31 downto 24) <= out_port;
                            when "0100" => hash_c_buf(31 downto 24) <= out_port;
                            when "0101" => hash_d_buf(31 downto 24) <= out_port;
                            when "0110" => hash_e_buf(31 downto 24) <= out_port;
                            when "0111" => hash_f_buf(31 downto 24) <= out_port;
                            when "1000" => hash_g_buf(31 downto 24) <= out_port;
                            when "1001" => hash_h_buf(31 downto 24) <= out_port;
                            when others => NULL;
                        end case;

                    when others => NULL;
                end case;
            end if;

            -- update msa and rc values
            if status_out_buf(2) = '1' then
                hash_rc_buf <= bram_data_out;
            end if;

            if status_out_buf(1) = '1' then
                hash_msa_buf <= bram_data_out;
            end if;

            -- run a hash iteration
            if status_out_buf(0) = '1' then
                hash_h_buf <= hash_g_buf;
                hash_g_buf <= hash_f_buf;
                hash_f_buf <= hash_e_buf;
                hash_e_buf <= hash_d_buf + temp1;
                hash_d_buf <= hash_c_buf;
                hash_c_buf <= hash_b_buf;
                hash_b_buf <= hash_a_buf;
                hash_a_buf <= temp1 + temp2;
            end if;

        end if;
    end process handle_hashing;

    read_buf <= bram_data_out when buf_select = "0000" else
                msa_out_buf   when buf_select = "0001" else
                hash_a_buf    when buf_select = "0010" else
                hash_b_buf    when buf_select = "0011" else
                hash_c_buf    when buf_select = "0100" else
                hash_d_buf    when buf_select = "0101" else
                hash_e_buf    when buf_select = "0110" else
                hash_f_buf    when buf_select = "0111" else
                hash_g_buf    when buf_select = "1000" else
                hash_h_buf    when buf_select = "1001" else
                (others => '0');

    input_ports : process(clk)
    begin
        if rising_edge(clk) then
            case port_id(2 downto 0) is
                when "000" => in_port <= data_in;
                when "001" => in_port <= status_in;

                when "010" => in_port <= (others => '0'); --reserved

                when "011" => in_port <= "0000" & parity_buf;
                when "100" => in_port <= read_buf(7 downto 0);
                when "101" => in_port <= read_buf(15 downto 8);
                when "110" => in_port <= read_buf(23 downto 16);
                when "111" => in_port <= read_buf(31 downto 24);

                when others => in_port <= (others => '0');
            end case;
        end if;
    end process input_ports;

    output_ports : process(clk)
    begin
        if rising_edge(clk) then
            -- reset various commands that don't need to go out
            status_out_buf(5 downto 0) <= (others => '0');

            if write_strobe = '1' or k_write_strobe = '1' then
                case port_id(2 downto 0) is
                    when "000" => data_out_buf <= out_port;
                    when "001" =>
                        status_out_buf <= out_port;

                        if out_port(4) = '1' then
                            addr_buf   <= (others => '0');
                            data_buf   <= (others => '0');
                            parity_buf <= (others => '0');
                        end if;

                    when "010" => addr_buf(7 downto 0) <= out_port;
                    when "011" =>
                        parity_buf <= out_port(3 downto 0);
                        buf_select <= out_port(7 downto 4);

                    when "100" =>
                        case buf_select is
                            when "0000" => data_buf(7 downto 0) <= out_port;
                            when others => NULL;
                        end case;

                    when "101" =>
                        case buf_select is
                            when "0000" => data_buf(15 downto 8) <= out_port;
                            when others => NULL;
                        end case;

                    when "110" =>
                        case buf_select is
                            when "0000" => data_buf(23 downto 16) <= out_port;
                            when others => NULL;
                        end case;

                    when "111" =>
                        case buf_select is
                            when "0000" => data_buf(31 downto 24) <= out_port;
                            when others => NULL;
                        end case;


                    when others => NULL;
                end case;
            end if;
        end if;
    end process output_ports;
end behavioral;
