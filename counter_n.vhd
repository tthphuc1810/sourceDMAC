library ieee ;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
ENTITY counter_n IS 
    GENERIC (N : Integer := 2);
		PORT (clk:  IN std_logic;
			  reset: IN std_logic;
			  enable: IN std_logic;
			  Load : IN std_logic;
			  Din  : IN std_logic_vector(N-1 downto 0);
			  count:  OUT std_logic_vector(N-1 downto 0));
END counter_n;
ARCHITECTURE behav OF counter_n IS
  SIGNAL pre_count: std_logic_vector(N-1 downto 0);  BEGIN
    PROCESS(clk, enable, reset)
		    BEGIN
		      IF reset = '1' THEN
		        pre_count <= (OTHERS =>'0');
		      ELSIF (clk='1' and clk'event) THEN
		        IF Load = '1' THEN
		            pre_count <= Din;
		        ELSIF enable = '1' THEN
			          pre_count <= pre_count + "1"; 
			          
			       END IF;
		 	  END IF;
    END PROCESS;
    count <= pre_count;
END behav;

