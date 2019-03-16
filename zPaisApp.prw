
/* ======================================================

		CADASTRO DE PAISES VIA SMARTCLIENT
		
	  UTILIZANDO MVC DINAMICO CRIADO A PARTIR 
	       DA DEFINICAO DO COMPONENTE 

====================================================== */

USER Function ZPais()
Local oEnv
Local oAppPais
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
oAppPais := ZAPP():New()

// Cria a defini��o do componente
// Futuramente ser� possivel obter a defini��o do dicion�rio de dados 
oDefinition := ZPaisDEF():New()

// Cria o objeto de Modelo da Pais
// Passa o nome da tabela e a defini��o 
// como parametros
oModel := ZMVCMODEL():New("PAIS",oDefinition)

// Na inicializa��o precisa passar o ambiente 
If !oModel:Init( oEnv )
	MsgStop( oModel:GetErrorStr() , "Failed to Init Model" )
	Return
Endif

// Cria a View da Pais 
oView := ZMVCVIEW():New("Cadastro de Pa�ses")

// Cria o controle da Pais   
// Por enquanto ele faz a ponte direta entre a View e o Modelo 
// Os eventos atomicos da view ficam na View, apenas 
// os macro eventos sao repassados  

oControl := ZMVCCONTROL():New(oView)
oControl:AddModel(oModel)

// ============================================
// Roda a Aplica��o da Pais baseado na View 
//
oAppPais:Run(oView)
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
oAppPais:Done()
FreeObj(oAppPais)

// Encerra o ambiente -- Junto com os objetos amarrados nele 
oEnv:Done()
FreeObj(oEnv)

Return
