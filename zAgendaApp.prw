
/* ======================================================

		APLICAÇÃO DA AGENDA VIA SMARTCLIENT 
		
	  UTILIZANDO MVC DINAMICO CRIADO A PARTIR 
	       DA DEFINICAO DO COMPONENTE 

-- A agenda depende de outros tabelas/modelos (LookUp):
   PAIS 
   ESTADO

====================================================== */

USER Function ZAgenda(aCoords)
Local oApp := ZAUTOAPP():New()

// Roda o MVC baseado na definicao 
oApp:RunMVC("ZAGENDADEF",aCoords)

Return

