
/* ======================================================

		CADASTRO DE Dados Bancários VIA SMARTCLIENT
		
	  UTILIZANDO MVC DINAMICO CRIADO A PARTIR 
	       DA DEFINICAO DO COMPONENTE 

====================================================== */

USER Function ZDadosBanc(aCoords)
Local oEnv
Local oAppBanco
Local oDefDadosB
Local oDefBancos
Local oAgendaDef
Local oModelDadosB
Local oModelAgenda
Local oModelBancos
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
oAppBanco := ZAPP():New()

// Cria a definição do componente
// Futuramente será possivel obter a definição do dicionário de dados 
oDefDadosB := ZDadosBAncDef():New()

// Cria o objeto de Modelo da Banco
// Passa o nome da tabela e a definição 
// como parametros
oModelDadosB := ZMVCMODEL():New("DADOSBANC",oDefDadosB)

// Na inicialização precisa passar o ambiente 
If !oModelDadosB:Init( oEnv )
	MsgStop( oModelDadosB:GetErrorStr() , "Failed to Init Model" )
	Return
Endif


// Cria a definição do componente
// Futuramente será possivel obter a definição do dicionário de dados 
oDefBancos := ZBAncoDef():New()

// Cria o objeto de Modelo da Banco
// Passa o nome da tabela e a definição 
// como parametros
oModelBancos := ZMVCMODEL():New("BANCO",oDefBancos)

// Na inicialização precisa passar o ambiente 
If !oModelBancos:Init( oEnv )
	MsgStop( oModelBancos:GetErrorStr() , "Failed to Init Model" )
	Return
Endif

// Cria a definição do componente
// Futuramente será possivel obter a definição do dicionário de dados 
oAgendaDef := ZAGENDADEF():New()

// Cria o objeto de Modelo da Agenda
// Passa o nome da tabela e a definição 
// como parametros
oModelAgenda := ZMVCMODEL():New("AGENDA",oAgendaDef)

// Na inicialização precisa passar o ambiente 
If !oModelAgenda:Init( oEnv )
	MsgStop( oModelAgenda:GetErrorStr() , "Failed to Init Model [AGENDA]" )
	Return
Endif


// Cria a View da Banco 
oView := ZMVCVIEW():New("Dados Bancários ")

IF aCoords != NIL
	// Top, left, bottom, right
	oView:SetCoords(aCoords)
Endif

// Cria o controle da Banco   
// Por enquanto ele faz a ponte direta entre a View e o Modelo 
// Os eventos atomicos da view ficam na View, apenas 
// os macro eventos sao repassados  

oControl := ZMVCCONTROL():New(oView)
oControl:AddModel(oModelDadosB)
oControl:AddModel(oModelBancos)
oControl:AddModel(oModelAgenda)


// ============================================
// Roda a Aplicação da Banco baseado na View 
//
oAppBanco:Run(oView)
//
// ============================================

// Encerra todos os contextos utilizados 
// -- Ordem inversa de criação -- 

// Encerra o control
oControl:Done()
FreeObj(oControl)

// Encerra o modelo 
oModelDadosB:Done()
FreeObj(oModelDadosB)

// Encerra a View
oView:Done()
FreeObj(oView)

// Encerra a definição 
oDefDadosB:Done()
FreeObj(oDefDadosB)

// Encerra a aplicação 
oAppBanco:Done()
FreeObj(oAppBanco)

// Encerra o ambiente -- Junto com os objetos amarrados nele 
oEnv:Done()
FreeObj(oEnv)

Return

