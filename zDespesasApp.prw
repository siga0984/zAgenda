
/* ======================================================

		CADASTRO DE DEDSPESAS VIA SMARTCLIENT
		
	  UTILIZANDO MVC DINAMICO CRIADO A PARTIR 
	       DA DEFINICAO DO COMPONENTE 

====================================================== */

USER Function ZDespesas(aCoords)
Local oApp := ZAUTOAPP():New()

// Roda o MVC baseado na definicao 
oApp:RunMVC("ZDESPESASDEF",aCoords)

Return

