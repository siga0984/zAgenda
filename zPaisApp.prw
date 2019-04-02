
/* ======================================================

		CADASTRO DE PAISES VIA SMARTCLIENT
		
	  UTILIZANDO MVC DINAMICO CRIADO A PARTIR 
	       DA DEFINICAO DO COMPONENTE 

====================================================== */

USER Function ZPais(aCoords)
Local oEnv
Local oAppPais
Local oDefinition
Local oModel
Local oView
Local oControl
Local oMemCache

// Cria o ambiente 
oEnv := ZLIBENV():New()
oEnv:SetEnv()

// Cria a conexao DEFAULT com o banco de dados 
// Seta uso de pool nomeado de conexoes 
oDBConn  := ZDBACCESS():New()
oDBConn:SETPOOL(.T. , "DB_POOL")

// Guarda a conexao DEFAULT no ambiente
oEnv:SetObject("DBCONN",oDBConn)

// Cria um objeto de cache em memoria 
// e guarda no environment
IF Val(GetSrvProfString("UseMemCache","0")) > 0 
	oMemCache := ZMEMCACHED():New( "127.0.0.1" , 11211 )
	oEnv:SetObject("MEMCACHED",oMemCache)
Endif

// Cria a aplicação Client 
oAppPais := ZAPP():New()

// Cria a definição do componente
// Futuramente será possivel obter a definição do dicionário de dados 
oDefinition := ZPaisDEF():New()

// Cria o objeto de Modelo da Pais
// Passa o nome da tabela e a definição 
// como parametros
oModel := ZMVCMODEL():New("PAIS",oDefinition)

// Na inicialização precisa passar o ambiente 
If !oModel:Init( oEnv )
	MsgStop( oModel:GetErrorStr() , "Failed to Init Model" )
	Return
Endif

// Cria a View da Pais 
oView := ZMVCVIEW():New("Cadastro de Países")

IF aCoords != NIL
	// Top, left, bottom, right
	oView:SetCoords(aCoords)
Endif

// Cria o controle da Pais   
// Por enquanto ele faz a ponte direta entre a View e o Modelo 
// Os eventos atomicos da view ficam na View, apenas 
// os macro eventos sao repassados  

oControl := ZMVCCONTROL():New(oView)
oControl:AddModel(oModel)

// ============================================
// Roda a Aplicação da Pais baseado na View 
//
oAppPais:Run(oView)
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
oAppPais:Done()
FreeObj(oAppPais)

// Encerra o ambiente -- Junto com os objetos amarrados nele 
oEnv:Done()
FreeObj(oEnv)

Return

