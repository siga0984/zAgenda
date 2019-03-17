
/* ======================================================

		CADASTRO DE ESTADOS VIA SMARTCLIENT
		
	  UTILIZANDO MVC DINAMICO CRIADO A PARTIR 
	       DA DEFINICAO DO COMPONENTE 

====================================================== */

USER Function ZEstado(aCoords)
Local oEnv
Local oAppEstado
Local oDefinition
Local oModel
Local oView
Local oControl

// Cria o ambiente 
oEnv := ZLIBENV():New()
oEnv:SetEnv()

// Cria a conexao DEFAULT com o banco de dados 
// Seta uso de pool nomeado de conexoes 
oDBConn  := ZDBACCESS():New()
oDBConn:SETPOOL(.T. , "DB_POOL")

// Guarda a conexao DEFAULT no ambiente
oEnv:SetObject("DBCONN",oDBConn)

// Cria a aplicação Client 
oAppEstado := ZAPP():New()

// Cria a definição do componente
// Futuramente será possivel obter a definição do dicionário de dados 
oDefinition := ZEstadoDEF():New()

// Cria o objeto de Modelo da Estado
// Passa o nome da tabela e a definição 
// como parametros
oModel := ZMVCMODEL():New("ESTADO",oDefinition)

// Na inicialização precisa passar o ambiente 
If !oModel:Init( oEnv )
	MsgStop( oModel:GetErrorStr() , "Failed to Init Model" )
	Return
Endif

// Cria a View da Estado 
oView := ZMVCVIEW():New("Cadastro de Estados Brasileiros")

IF aCoords != NIL
	// Top, left, bottom, right
	oView:SetCoords(aCoords)
Endif

// Cria o controle da Estado   
// Por enquanto ele faz a ponte direta entre a View e o Modelo 
// Os eventos atomicos da view ficam na View, apenas 
// os macro eventos sao repassados  

oControl := ZMVCCONTROL():New(oView)
oControl:AddModel(oModel)

// ============================================
// Roda a Aplicação da Estado baseado na View 
//
oAppEstado:Run(oView)
//
// ============================================

// Encerra todos os contextos utilizados 
// -- Ordem inversa de criação -- 

// Encerra o control
oControl:Done()
FreeObj(oControl)

// Encerra o modelo 
oModel:Done()
FreeObj(oModel)

// Encerra a View
oView:Done()
FreeObj(oView)

// Encerra a definição 
oDefinition:Done()
FreeObj(oDefinition)

// Encerra a aplicação 
oAppEstado:Done()
FreeObj(oAppEstado)

// Encerra o ambiente -- Junto com os objetos amarrados nele 
oEnv:Done()
FreeObj(oEnv)

Return

