
/* ======================================================

		CADASTRO DE Bancos VIA SMARTCLIENT
		
	  UTILIZANDO MVC DINAMICO CRIADO A PARTIR 
	       DA DEFINICAO DO COMPONENTE 

====================================================== */

USER Function ZBanco()
Local oEnv
Local oAppBanco
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

// Cria a aplica��o Client 
oAppBanco := ZAPP():New()

// Cria a defini��o do componente
// Futuramente ser� possivel obter a defini��o do dicion�rio de dados 
oDefinition := ZBancoDEF():New()

// Cria o objeto de Modelo da Banco
// Passa o nome da tabela e a defini��o 
// como parametros
oModel := ZMVCMODEL():New("Banco",oDefinition)

// Na inicializa��o precisa passar o ambiente 
If !oModel:Init( oEnv )
	MsgStop( oModel:GetErrorStr() , "Failed to Init Model" )
	Return
Endif

// Cria a View da Banco 
oView := ZMVCVIEW():New("Cadastro de Bancos")

// Cria o controle da Banco   
// Por enquanto ele faz a ponte direta entre a View e o Modelo 
// Os eventos atomicos da view ficam na View, apenas 
// os macro eventos sao repassados  

oControl := ZMVCCONTROL():New(oView)
oControl:AddModel(oModel)

// ============================================
// Roda a Aplica��o da Banco baseado na View 
//
oAppBanco:Run(oView)
//
// ============================================

// Encerra todos os contextos utilizados 
// -- Ordem inversa de cria��o -- 

// Encerra o control
oControl:Done()
FreeObj(oControl)

// Encerra o modelo 
oModel:Done()
FreeObj(oModel)

// Encerra a View
oView:Done()
FreeObj(oView)

// Encerra a defini��o 
oDefinition:Done()
FreeObj(oDefinition)

// Encerra a aplica��o 
oAppBanco:Done()
FreeObj(oAppBanco)

// Encerra o ambiente -- Junto com os objetos amarrados nele 
oEnv:Done()
FreeObj(oEnv)

Return

