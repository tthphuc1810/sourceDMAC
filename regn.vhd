LIBRARY ieee;
USE ieee.std_logic_1164.all;
use work.User_Lib.all;
ENTITY regn IS
  GENERIC (N : INTEGER := 16);
  PORT (
      D : IN STD_LOGIC_VECTOR (N-1 DOWNTO 0) ;
   	  Reset, Clock, En : IN STD_LOGIC ;
	    Q : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
	    );
END regn ;
ARCHITECTURE Behavior OF regn IS
  BEGIN
    PROCESS (Reset, Clock)
      BEGIN
        IF RESET='1' THEN
          Q <= (OTHERS => '0');
        ELSIF (CLOCK'EVENT AND CLOCK='1') THEN
          IF (EN = '1') THEN
            Q <= D;
          END IF;
        END IF;

   END PROCESS ;
END Behavior ;

