
/* ======================================================

		CADASTRO DE Bancos VIA SMARTCLIENT
		
	  UTILIZANDO MVC DINAMICO CRIADO A PARTIR 
	       DA DEFINICAO DO COMPONENTE 

====================================================== */

USER Function ZBanco(aCoords)
Local oApp := ZAUTOAPP():New()

// Roda o MVC baseado na definicao 
oApp:RunMVC("ZBANCODEF",aCoords)

Return

