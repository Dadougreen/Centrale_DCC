----------------------------------------------------------------------------------
-- Company: SORBONNE UNIVERSITE
-- Designed by: J.DENOULET, Winter 2021
--
-- Module Name: DCC_FRAME_GENERATOR - Behavioral
-- Project Name: Centrale DCC
-- Target Devices: NEXYS 4 DDR
-- 
--	G�n�rateur de Trames de Test pour la Centrale DCC
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DCC_FRAME_GENERATOR is
    Port ( Interrupteur	: in STD_LOGIC_VECTOR(7 downto 0);	    -- Interrupteurs de la Carte
           Trame_DCC 	: out STD_LOGIC_VECTOR(50 downto 0));	-- Trame DCC de Test					
end DCC_FRAME_GENERATOR;

architecture Behavioral of DCC_FRAME_GENERATOR is

begin

-- G�n�ration d'une Trame selon l'Interrupteur Tir� vers le Haut
-- Si Plusieurs Interupteurs Sont Tir�s, Celui de Gauche Est Prioritaire

-- Compl�ter les Trames pour R�aliser les Tests Voulus

process(Interrupteur)
begin
	
	-- Interrupteur 7 Activ�
		--> Trame Marche Avant du Train d'Adresse i
	if Interrupteur(7)='1' then
	
		Trame_DCC <=  "11111111111111111111111"				-- Pr�ambule
					& '0'				-- Start Bit
					& "00000010"			-- Champ Adresse
					& '0'				-- Start Bit
					& "01101111" 				-- Champ Commande
					& '0'				-- Start Bit
					& "01101111"		-- Champ Contr�le
					& '1'	;			-- Stop Bit

	-- Interrupteur 6 Activ�
		--> Trame Marche Arri�re du Train d'Adresse i
	elsif Interrupteur(6)='1' then
	
		Trame_DCC <=  "11111111111111111111111" -- Pr�ambule
					& '0'				       -- Start Bit
					& "00000010"			   -- Champ Adresse
					& '0'				       -- Start Bit
					& "01001111" 			   -- Champ Commande
					& '0'				       -- Start Bit
					& "01001111"		       -- Champ Contr�le
					& '1'	;			       -- Stop BitBit

	-- Interrupteur 5 Activ�
		--> Allumage des Phares du Train d'Adresse i
	elsif Interrupteur(5)='1' then
	
		Trame_DCC <=  "11111111111111111111111"				-- Pr�ambule
					& '0'				-- Start Bit
					& "00000010"			-- Champ Adresse
					& '0'				-- Start Bit
					& "10010000"			-- Champ Commande
					& '0'				-- Start Bit
					& "10010010"				-- Champ Contr�le
					& '1'	;			-- Stop Bit

	-- Interrupteur 4 Activ�
		--> Extinction des Phares du Train d'Adresse i
	elsif Interrupteur(4)='1' then
	
		Trame_DCC <=  "11111111111111111111111"				-- Pr�ambule
					& '0'				-- Start Bit
					& "00000010"			-- Champ Adresse
					& '0'				-- Start Bit
					& "10000000"			-- Champ Commande
					& '0'				-- Start Bit
					& "10000010"				-- Champ Contr�le
					& '1'	;			-- Stop Bit

	-- Interrupteur 3 Activ�
		--> Activation du Klaxon (Fonction F11) du Train d'Adresse i
	elsif Interrupteur(3)='1' then
	
		Trame_DCC <=  "11111111111111111111111"				-- Pr�ambule
					& '0'				-- Start Bit
					& "00000010"			-- Champ Adresse
					& '0'				-- Start Bit
					& "10100100"			-- Champ Commande
					& '0'				-- Start Bit
					& "10100110"				-- Champ Contr�le
					& '1'	;			-- Stop Bit

	-- Interrupteur 2 Activ�
		--> R�amorssage du Klaxon (Fonction F11) du Train d'Adresse i
	elsif Interrupteur(2)='1' then
	
		Trame_DCC <=  "11111111111111111111111"				-- Pr�ambule
					& '0'				-- Start Bit
					& "00000010"			-- Champ Adresse
					& '0'				-- Start Bit
					& "10100000"			-- Champ Commande
					& '0'				-- Start Bit
					& "10100000"				-- Champ Contr�le
					& '1'	;			-- Stop Bit

	-- Interrupteur 1 Activ�
		--> Annonce SNCF (Fonction F13) du Train d'Adresse i
	elsif Interrupteur(1)='1' then
	
		Trame_DCC <= "11111111111111"				-- Pr�ambule
					& '0'				-- Start Bit
					& "00000010"			-- Champ Adresse
					& '0'				-- Start Bit
					& "11011110"			-- Champ Commande (Octet 1)
					& '0'				-- Start Bit
					& "00000001"			-- Champ Commande (Octet 2)
					& '0'				-- Start Bit
					& "11011111"				-- Champ Contr�le
					& '1'	;			-- Stop Bit

	-- Interrupteur 0 Activ�
		--> Annonce SNCF (Fonction F13) du Train d'Adresse i
	elsif Interrupteur(0)='1' then
	
		Trame_DCC <= "11111111111111"				-- Pr�ambule
					& '0'				-- Start Bit
					& "00000010"			-- Champ Adresse
					& '0'				-- Start Bit
					& "11011110"			-- Champ Commande (Octet 1)
					& '0'				-- Start Bit
					& "00000001"			-- Champ Commande (Octet 2)
					& '0'				-- Start Bit
					& "11011111"				-- Champ Contr�le
					& '1'	;			-- Stop Bit

	-- Aucun Interrupteur Activ�
		--> Arr�t du Train d'Adresse i
	else 
	
		Trame_DCC <=  "11111111111111111111111"				-- Pr�ambule
					& '0'				-- Start Bit
					& "00000010"			-- Champ Adresse
					& '0'				-- Start Bit
					& "01100000"			-- Champ Commande
					& '0'				-- Start Bit
					& "01100000"				-- Champ Contr�le
					& '1'	;			-- Stop Bit
	end if;
end process;

end Behavioral;

