
/* ======================================================

		CADASTRO DE Bancos VIA SMARTCLIENT
		
	  UTILIZANDO MVC DINAMICO CRIADO A PARTIR 
	       DA DEFINICAO DO COMPONENTE 

====================================================== */

USER Function ZBanco(aCoords)
Local oEnv
Local oAppBanco
Local oBancoDef
Local oBancoModel
Local oBancoView
Local oBancoControl
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

// Cria a aplica��o Client 
oAppBanco := ZAPP():New()

// Cria a defini��o do componente
// Futuramente ser� possivel obter a defini��o do dicion�rio de dados 
oBancoDef := ZBancoDEF():New()

// Cria o objeto de Modelo da Banco
// Passa o nome da tabela e a defini��o 
// como parametros
oBancoModel := ZMVCMODEL():New("BANCO",oBancoDef)

// Na inicializa��o precisa passar o ambiente 
If !oBancoModel:Init( oEnv )
	MsgStop( oBancoModel:GetErrorStr() , "Failed to Init Model" )
	Return
Endif

// Cria a View da Banco 
oBancoView := ZMVCVIEW():New("Cadastro de Bancos")

IF aCoords != NIL
	// Top, left, bottom, right
	oBancoView:SetCoords(aCoords)
Endif

// Cria o controle da Banco   
// Por enquanto ele faz a ponte direta entre a View e o Modelo 
// Os eventos atomicos da view ficam na View, apenas 
// os macro eventos sao repassados  

oBancoControl := ZMVCCONTROL():New(oBancoView)
oBancoControl:AddModel(oBancoModel)

// ============================================
// Roda a Aplica��o da Banco baseado na View 
//
oAppBanco:Run(oBancoView)
//
// ============================================

// Encerra todos os contextos utilizados 
// -- Ordem inversa de cria��o -- 

// Encerra o control
oBancoControl:Done()
FreeObj(oBancoControl)

// Encerra o modelo 
oBancoModel:Done()
FreeObj(oBancoModel)

// Encerra a View
oBancoView:Done()
FreeObj(oBancoView)

// Encerra a defini��o 
oBancoDef:Done()
FreeObj(oBancoDef)

// Encerra a aplica��o 
oAppBanco:Done()
FreeObj(oAppBanco)

// Encerra o ambiente -- Junto com os objetos amarrados nele 
oEnv:Done()
FreeObj(oEnv)

Return

