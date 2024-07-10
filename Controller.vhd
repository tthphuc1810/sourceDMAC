LIBRARY ieee ;
USE ieee.std_logic_1164.all ;
use work.User_Lib.all;
ENTITY Controller IS
   PORT ( Clock, nReset: IN STD_LOGIC ;
          Start: IN STD_LOGIC ;
          
          i_lt_L: IN STD_LOGIC; -- Output signal of Comparator i
         
          
          a_sel, b_sel, MemR_n, MemW_n: OUT STD_LOGIC; 
          LD_i: OUT STD_LOGIC; -- Load signal for Counter i
          En_i: OUT STD_LOGIC;
          EN_A, EN_B, EN_T: OUT STD_LOGIC;
          reset : OUT STD_LOGIC;
	  Done : OUT STD_LOGIC ) ;
   END Controller ;
ARCHITECTURE Behavior OF Controller IS
  --TYPE State_type IS (A, B, C) ;
  SIGNAL State : STD_LOGIC_VECTOR(4 DOWNTO 0) ;
  
BEGIN
-- State transitions 
  PROCESS ( nReset, Clock )
    BEGIN
      
      IF nReset = '0' THEN
	       STATE <= "00000" ; -- STATE 0
      ELSIF (Clock'EVENT AND Clock = '1') THEN
        CASE STATE IS
           WHEN "00000" =>
               STATE <= "00001"; -- STATE 1
           WHEN "00001" =>    --1
               IF START = '1' THEN
	               STATE <= "00010"; -- STATE 2
	       ELSE
	               STATE <= "00001"; -- STATE 1
               END IF ;
            WHEN "00010" => --2
                STATE <= "00011"; -- STATE 3
            WHEN "00011" => --3
                IF i_lt_L = '1' THEN
                  STATE <= "00100"; -- STATE 4
                ELSE
                  STATE <= "01000"; -- STATE 8
                END IF ;
             WHEN "00100" => --4
                STATE <= "00101"; -- STATE 5
             WHEN "00101" => --5
                STATE <= "00110"; -- STATE 6
             WHEN "00110" => --6
		STATE <= "00111"; -- STATE 7
             WHEN "00111" => --7
                STATE <= "00011"; -- STATE 3
                
             WHEN "01000" =>  --8  
                STATE <= "01001"; -- STATE 9 
             WHEN "01001" => --9
               IF START = '0' THEN
	          STATE <= "01010"; -- STATE 10
	       ELSE
	           STATE <= "01001"; -- STATE 9
               END IF ;
		 
             WHEN "01010" => --10   
                   STATE <= "00001"; -- STATE 1                              
             WHEN OTHERs =>
                STATE <= "00001"; -- STATE 1 
          END CASE ;
  END IF ;


  END PROCESS ;
-- Output function
  -- Clear Registers
   Reset <= '1' WHEN STATE = "00000" ELSE '0' ;
  -- Load data into counters  
   LD_i <= '1' WHEN STATE = "00010" ELSE '0' ;
   
 -- Enable Counters
   EN_i <= '1' WHEN STATE = "00111" ELSE '0' ;
  
 WITH STATE SELECT   
	 	a_sel <= '1' when "00111", 
		    	      
		    	 '0' when OTHERS;
  WITH STATE SELECT   
	 	b_sel <= '1' when "00111",
		    	    	    	
             	       '0' when OTHERS;		    	       
 WITH STATE SELECT   
	 	MemR_n <= '0' when "00100",
		    	        	
		    	   '1' when OTHERS;
 WITH STATE SELECT   
	 	MemW_n <= '0' when "00110",
		    	        	
		    	     '1' when OTHERS;	
 WITH STATE SELECT   
	 	EN_A <= '1' when "00010"|"00111", --|"01011"
		    	        	
		    	     '0' when OTHERS;	
 WITH STATE SELECT   
	 	EN_B <= '1' when "00010"|"00111",
		    	        	
		    	     '0' when OTHERS;		
 WITH STATE SELECT   
	 	EN_T <= '1' when "00101",
		    	        	
		    	     '0' when OTHERS;	
	 
 Done <= '1' WHEN (STATE = "01000") OR (STATE = "01001") ELSE '0' ;		    	     	    	     	    	     
END Behavior;   
