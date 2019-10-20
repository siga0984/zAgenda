
/* ======================================================

		CADASTRO DE PAISES VIA SMARTCLIENT
		
	  UTILIZANDO MVC DINAMICO CRIADO A PARTIR 
	       DA DEFINICAO DO COMPONENTE 

====================================================== */

USER Function ZPais(aCoords)
Local oApp := ZAUTOAPP():New()

// Roda o MVC baseado na definicao 
oApp:RunMVC("ZPAISDEF",aCoords)

Return

