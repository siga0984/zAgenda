
/* ======================================================

		CADASTRO DE ESTADOS VIA SMARTCLIENT
		
	  UTILIZANDO MVC DINAMICO CRIADO A PARTIR 
	       DA DEFINICAO DO COMPONENTE 

====================================================== */

USER Function ZEstado(aCoords)
Local oApp := ZAUTOAPP():New()

// Roda o MVC baseado na definicao 
oApp:RunMVC("ZESTADODEF",aCoords)

Return

