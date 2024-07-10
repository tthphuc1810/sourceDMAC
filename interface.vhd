library ieee;
use ieee.std_logic_1164.all;
use work.user_lib.all;

entity interface is
  -- generic (DATA_WIDTH : integer := 8);
  port (
    clock       : in    std_logic;
    nreset      : in    std_logic;
-- External
    dreq, Hlda  : in    std_logic;
    Hreq, Dack  : out   std_logic;
-- Internal
    Done        : in    std_logic;
    Start       : out   std_logic
  );
end entity;
architecture fsm of interface is
TYPE State_type IS (Rst, Dreq_S, Hreq_S, Hlda_S, Dack_S, Done_S, End_S) ; 
  SIGNAL State : State_type;
begin
  Fsm_GEN: process (clock, nreset)
  begin
    if (nreset = '0') then
      State <= Rst;
    elsif rising_edge (clock) then
      case state is
        when Rst => -- 
          State <= Dreq_S;
        when Dreq_S => -- 
          If dreq = '1'then
		State <= Hreq_S;
	  Else
		State <= Dreq_S;
	  End if;
        when Hreq_S => -- 
          State <= Hlda_S;
        when Hlda_S =>  -- 
          If Hlda = '1'then
		State <= Dack_S;
	  Else
		State <= Hlda_S;
	  End if;
        when Dack_S =>  -- 
          State <= Done_S;
        when Done_S =>  -- 
	  If Done = '1'then
		State <= End_S;
	  Else
		State <= Done_S;
	  End if;
        when End_S => 
          State <= Dreq_S;

        when others =>
	  State <= Rst;
      end case;
    end if;
  end process;
 WITH STATE SELECT   
	 	Hreq <= '1' when Hreq_S|Hlda_S|Dack_s|Done_S,
		    	        	
		    	'0' when OTHERS;	
 WITH STATE SELECT   
	 	Dack <= '1' when Dack_s|Done_S,
		    	        	
		    	'0' when OTHERS;	
 WITH STATE SELECT   
	 	Start <= '1' when Dack_s|Done_S,
		    	        	
		    	 '0' when OTHERS;	
end fsm;
