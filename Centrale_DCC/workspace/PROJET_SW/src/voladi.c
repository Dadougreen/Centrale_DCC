#include "xgpio.h"
#include "xparameters.h"
#include "xil_io.h"
#include "centrale_dcc.h"

//L'utilisation des masque pour faire une mise a jour sur le slv_reg
#define SW0 0x1 // Masque de switch 0
#define SW1 0x2 // Masque de switch 1
#define SW2 0x4 // Masque de switch 2
#define SW3 0x8 // Masque de switch 3
#define BTNC 0x2 // Masque du bouton poussoir centrale
#define BTNG 0x4 // Masque du bouton poussoir gauche
#define BTND 0x1 // Masque du bouton poussoir droite

// En fonction des types de commandes, on utilise des preambules
#define PREAMBULE1 0xFFFFFE00 //Preambule avec 1 octet de commande
#define PREAMBULE2 0xFFFC0000 //Preambule avec 2 octets de commande

#define MASK_SW_SPEED 		0x3
#define MASK_SW_DIRECTION 	0x4
#define MASK_SW_ADR 		0x70
#define MASK_SW_LUMIERE 	0x80
#define MASK_SW_KLAXON 		0x100
#define MASK_SW_ANNONCE		0x200
#define STOP_KLAXON 		0xA0

#define STARTBIT_1_1o 0x00000100
#define STARTBIT_2_1o 0x80000000
#define STARTBIT_3_1o 0x00400000
#define STOPBIT_1o 0x00002000

#define STARTBIT_1_2o 0x00020000
#define STARTBIT_2_2o 0x00000100
#define STARTBIT_3_2o 0x80000000
#define STARTBIT_4_2o 0x00400000
#define STOPBIT_2o 0x00002000

int type = 0;
XGpio boutons,switchs; //les variables globales qu'on va utiliser
u32 trame0 = 0; // u32 : entier non-signe
u32 trame1 = 0;

//---------------------------------FONCTIONS---------------------------------//

//------------------------------getDirection---------------------------------------------//
/*Cette fonction prend en entree l'etat des switchs et retourne une
valeur qui represente la direction du train
1 : direction avant
2 : direction arriere
*/
u32 getDirection(u32 sw_state) {
	u32 sw = sw_state & MASK_SW_DIRECTION;
	if(sw)
		return 0x1;
	return 0x0;
}

//------------------------------getSpeed---------------------------------------------//
/*
  Cette fonction prend en entree l'etat des switchs et retourne
  un entier qui represente la vitesse du train.
  Elle utilise le switch de vitesse pour determiner la vitesse du
  train et combine cette valeur avec la direction retournee par la
  fonction getDirection() pour former une commande complete.
*/
u32 getSpeed(u32 sw_state) {
	type = 0;
	u32 speed = 0x00;
	u32 sw = sw_state & MASK_SW_SPEED;
	u32 cmd = (getDirection(sw_state) << 5) | 0x40;
	switch(sw) {
		case 0x0 : speed = 0x00; break; //arret
		case 0x1 : speed = 0x17; break;
		case 0x2 : speed = 0x1B; break;
		case 0x3 : speed = 0x1F; break;
	}
	return speed | cmd;
}

//---------------------------------getAdr------------------------------------------//
/*
Cette fonction prend en entree l'etat des switchs et
retourne un entier qui represente l'adresse du train.
Elle utilise le switch d'adresse pour determiner l'adresse et la renvoie.
*/
u32 getAdr(u32 sw_state) {
	u32 sw = sw_state & MASK_SW_ADR;
	return (sw >> 4);
}

//---------------------------------getLumiere------------------------------------------//
/*
 Cette fonction prend en entree l'etat des switchs et
 retourne un entier qui represente l'etat de la lumiere du train.
 Elle utilise le switch de la lumiere pour determiner l'etat et la renvoie.
*/
u32 getLumiere(u32 sw_state) {
	type = 2;
	u32 sw = sw_state & MASK_SW_LUMIERE;
	u32 lumiere = 0x10;
	lumiere |= (sw >> 7);
	return lumiere;
}

//-------------------------------getKlaxon--------------------------------------------//
/*
Cette fonction prend en entree l'etat des switchs et
retourne un entier qui represente l'etat du klaxon du train.
Elle utilise le switch du klaxon pour determiner l'etat et la renvoie.
*/
u32 getKlaxon(u32 sw_state) {
	type = 1;
	u32 bit = 0x0;
	u32 sw = sw_state & MASK_SW_KLAXON;
	u32 klaxon = 0x101;
	if(sw)
		bit = 0x4;
	klaxon |= bit;
	return klaxon;
}

//---------------------------------getAnnonce------------------------------------------//
/*
Cette fonction prend en entree l'etat des switchs et retourne
un entier qui represente l'etat de l'annonce du train.
Elle utilise le switch de l'annonce pour determiner l'etat et la renvoie.
*/
u32 getAnnonce(u32 sw_state) {
	type = 3;
	u32 sw = sw_state & MASK_SW_ANNONCE;
	if(sw)
		return 0xDC01;
	return 0xDC00;
}

//-----------------------------------main----------------------------------------//
/*
Dans le main, on initialise les GPIOs pour les boutons,
les LEDs et les switchs. Ensuite, on lit en permanence l'etat des
boutons et des switchs, en utilisant les fonctions ci-dessus pour generer les
trames appropriees et ecrit ces trames sur les registres de l'IP.
On ecrit egalement l'etat des LEDs pour afficher les donnees et les commandes actives.
*/

int main(void) {

// Initialisation de variables de type entier non signe a zero
	u32 sw = 0;
	u32 btn = 0;
	u32 adr = 0;

	// Initialisation des GPIO pour les boutons et les switchs
XGpio_Initialize(&boutons, XPAR_GPIO_0_DEVICE_ID); // Initialisation des GPIO boutons
XGpio_Initialize(&switchs, XPAR_GPIO_1_DEVICE_ID); // Initialisation des GPIO switchs

// Configuration des GPIO pour les boutons, les LEDs et les switchs
XGpio_SetDataDirection(&boutons, 1,1); // Le port 1 des boutons est en mode ecriture (entree)
XGpio_SetDataDirection(&switchs, 1,1); // Le port 1 des LEDs et des switchs est en mode ecriture (entree) (utilise pour les switchs)

	while(1) {
			sw = XGpio_DiscreteRead(&switchs, 1); // Lecture des switchs
			btn = XGpio_DiscreteRead(&boutons, 1); // Lecture des boutons poussoirs
			// Si le bouton BTNC est appuye
			if(btn & BTNC){
    			adr = getAdr(sw); // Recuperation de l'adresse en utilisant la valeur des switchs

    			switch(type){
        		case 0 : // Commande de la vitesse
					// Creation de la trame a envoyer pour la commande de la vitesse
					trame1 |= PREAMBULE1; // Ajout du preambule de la trame
					trame1 &= ~(STARTBIT_1_1o); // Ajout du bit de depart
					trame1 |= adr; // Ajout de l'adresse
					trame0 &= ~(STARTBIT_2_1o); // Ajout du bit de depart
					trame0 |= (getSpeed(sw)<<23); // Ajout de la vitesse
					trame0 &= ~(STARTBIT_3_1o); // Ajout du bit de depart
					trame0 |= ((adr^getSpeed(sw))<<14); // Ajout du bit de redondance
					trame0 |= STOPBIT_1o; // Ajout du bit d'arrêt

					// Envoi de la trame creee a la centrale DCC
					CENTRALE_DCC_mWriteReg(XPAR_CENTRALE_DCC_0_S00_AXI_BASEADDR, CENTRALE_DCC_S00_AXI_SLV_REG0_OFFSET, trame0);
					CENTRALE_DCC_mWriteReg(XPAR_CENTRALE_DCC_0_S00_AXI_BASEADDR, CENTRALE_DCC_S00_AXI_SLV_REG1_OFFSET, trame1);
					break;

				case 1 : // Commande du klaxon
					// Creation de la trame a envoyer pour la commande du klaxon
					trame1 |= PREAMBULE1; // Ajout du preambule de la trame
					trame1 &= ~(STARTBIT_1_1o); // Ajout du bit de depart
					trame1 |= adr; // Ajout de l'adresse
					trame0 &= ~(STARTBIT_2_1o); // Ajout du bit de depart
					trame0 |= (getKlaxon(sw)<<23); // Ajout de la commande du klaxon
					trame0 &= ~(STARTBIT_3_1o); // Ajout du bit de depart
					trame0 |= ((adr^getKlaxon(sw))<<14); // Ajout du bit de redondance
					trame0 |= STOPBIT_1o; // Ajout du bit d'arrêt

					// Envoi de la trame creee a la centrale DCC
					CENTRALE_DCC_mWriteReg(XPAR_CENTRALE_DCC_0_S00_AXI_BASEADDR, CENTRALE_DCC_S00_AXI_SLV_REG0_OFFSET, trame0);
					CENTRALE_DCC_mWriteReg(XPAR_CENTRALE_DCC_0_S00_AXI_BASEADDR, CENTRALE_DCC_S00_AXI_SLV_REG1_OFFSET, trame1);

					//Desactivation du klaxon
					trame1 |= PREAMBULE1;
					trame1 &= ~(STARTBIT_1_1o);
					trame1 |= adr;
					trame0 &= ~(STARTBIT_2_1o);
					trame0 |= (STOP_KLAXON<<23);
					trame0 &= ~(STARTBIT_3_1o);
					trame0 |= ((adr^STOP_KLAXON)<<14);
					trame0 |= STOPBIT_1o;

					// Envoi de la trame creee a la centrale DCC
					CENTRALE_DCC_mWriteReg(XPAR_CENTRALE_DCC_0_S00_AXI_BASEADDR, CENTRALE_DCC_S00_AXI_SLV_REG0_OFFSET, trame0);
					CENTRALE_DCC_mWriteReg(XPAR_CENTRALE_DCC_0_S00_AXI_BASEADDR, CENTRALE_DCC_S00_AXI_SLV_REG1_OFFSET, trame1);
					break;

				case 2 : // Allumer les phares
					trame1 |= PREAMBULE1;
					trame1 &= ~(STARTBIT_1_1o);
					trame1 |= adr;
					trame0 &= ~(STARTBIT_2_1o);
					trame0 |= (getLumiere(sw)<<23);
					trame0 &= ~(STARTBIT_3_1o);
					trame0 |= ((adr^getLumiere(sw))<<14);
					trame0 |= STOPBIT_1o;

					// Envoi de la trame creee a la centrale DCC
					CENTRALE_DCC_mWriteReg(XPAR_CENTRALE_DCC_0_S00_AXI_BASEADDR, CENTRALE_DCC_S00_AXI_SLV_REG0_OFFSET, trame0);
					CENTRALE_DCC_mWriteReg(XPAR_CENTRALE_DCC_0_S00_AXI_BASEADDR, CENTRALE_DCC_S00_AXI_SLV_REG1_OFFSET, trame1);

					//Desactivation des phares
					trame1 |= PREAMBULE1;
					trame1 &= ~(STARTBIT_1_1o);
					trame1 |= adr;
					trame0 &= ~(STARTBIT_2_1o);
					trame0 |= (getLumiere(sw)<<23);
					trame0 &= ~(STARTBIT_3_1o);
					trame0 |= ((adr^getLumiere(sw))<<14);
					trame0 |= STOPBIT_1o;

					// Envoi de la trame creee a la centrale DCC
					CENTRALE_DCC_mWriteReg(XPAR_CENTRALE_DCC_0_S00_AXI_BASEADDR, CENTRALE_DCC_S00_AXI_SLV_REG0_OFFSET, trame0);
					CENTRALE_DCC_mWriteReg(XPAR_CENTRALE_DCC_0_S00_AXI_BASEADDR, CENTRALE_DCC_S00_AXI_SLV_REG1_OFFSET, trame1);
					break;

				case 3 : // Annonce
					trame1 |= PREAMBULE2;
					trame1 &= ~(STARTBIT_1_2o);
					trame1 |= adr<<9;
					trame1 &= ~(STARTBIT_2_2o);
					trame1 |= ((getAnnonce(sw) & 0xFF00));
					trame0 &= ~(STARTBIT_3_2o);
					trame0 |= ((getAnnonce(sw) & 0x00FF)<<23);
					trame0 &= ~(STARTBIT_4_2o);
					trame0 |= ((adr^(getAnnonce(sw) & 0xFF00)^(getAnnonce(sw) & 0x00FF))<<14);
					trame0 |= STOPBIT_1o;

					// Envoi de la trame creee a la centrale DCC
					CENTRALE_DCC_mWriteReg(XPAR_CENTRALE_DCC_0_S00_AXI_BASEADDR, CENTRALE_DCC_S00_AXI_SLV_REG0_OFFSET, trame0);
					CENTRALE_DCC_mWriteReg(XPAR_CENTRALE_DCC_0_S00_AXI_BASEADDR, CENTRALE_DCC_S00_AXI_SLV_REG1_OFFSET, trame1);
					break;

					//Desactivation de l'annonce
					trame1 |= PREAMBULE2;
					trame1 &= ~(STARTBIT_1_2o);
					trame1 |= adr<<9;
					trame1 &= ~(STARTBIT_2_2o);
					trame1 |= ((0xDC00 & 0xFF00));
					trame0 &= ~(STARTBIT_3_2o);
					trame0 |= ((0xDC00 & 0x00FF)<<23);
					trame0 &= ~(STARTBIT_4_2o);
					trame0 |= ((adr^(0xDC00 & 0xFF00)^(0xDC00 & 0x00FF))<<14);
					trame0 |= STOPBIT_1o;

					// Envoi de la trame creee a la centrale DCC
					CENTRALE_DCC_mWriteReg(XPAR_CENTRALE_DCC_0_S00_AXI_BASEADDR, CENTRALE_DCC_S00_AXI_SLV_REG0_OFFSET, trame0);
					CENTRALE_DCC_mWriteReg(XPAR_CENTRALE_DCC_0_S00_AXI_BASEADDR, CENTRALE_DCC_S00_AXI_SLV_REG1_OFFSET, trame1);
					break;
				}
			}
	}
}
