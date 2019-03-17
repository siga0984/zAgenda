
/* ======================================================

		APLICA��O DA AGENDA VIA SMARTCLIENT 
		
	  UTILIZANDO MVC DINAMICO CRIADO A PARTIR 
	       DA DEFINICAO DO COMPONENTE 

-- A agenda depende de outros tabelas/modelos (LookUp):
   PAIS 
   ESTADO

====================================================== */

USER Function ZAgenda(aCoords)
Local oAppAgenda
Local oAgendaDef
Local oPaisDef
Local oEstadoDef
Local oModelAgenda
Local oModelPais
Local oModelEstado
Local oView
Local oControl
Local oEnv

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
oAppAgenda := ZAPP():New()

// Cria a defini��o do componente
// Futuramente ser� possivel obter a defini��o do dicion�rio de dados 
oAgendaDef := ZAGENDADEF():New()

// Cria o objeto de Modelo da Agenda
// Passa o nome da tabela e a defini��o 
// como parametros
oModelAgenda := ZMVCMODEL():New("AGENDA",oAgendaDef)

// Na inicializa��o precisa passar o ambiente 
If !oModelAgenda:Init( oEnv )
	MsgStop( oModelAgenda:GetErrorStr() , "Failed to Init Model [AGENDA]" )
	Return
Endif

// Como a agenda agora depende do cadastro de pa�ses, 
// cria a defini��o do componente PAIS
oPaisDef := ZPAISDEF():New()

// Cria o modelo para trabalhar com os pa�ses 
oModelPais := ZMVCMODEL():New("PAIS",oPaisDef)

// Na inicializa��o precisa passar o ambiente 
If !oModelPais:Init( oEnv )
	MsgStop( oModelPais:GetErrorStr() , "Failed to Init Model [PAIS]" )
	Return
Endif

// Como a agenda agora depende do cadastro de estados
// cria a defini��o do componente ESTADO
oEstadoDef := ZESTADODEF():New()

// Cria o modelo para trabalhar com os pa�ses 
oModelEstado := ZMVCMODEL():New("ESTADO",oEstadoDef)

// Na inicializa��o precisa passar o ambiente 
If !oModelEstado:Init( oEnv )
	MsgStop( oModelEstado:GetErrorStr() , "Failed to Init Model [ESTADO]" )
	Return
Endif

// Cria a View da agenda 
oView := ZMVCVIEW():New("Agenda de Contatos")  

IF aCoords != NIL
	// Top, left, bottom, right
	oView:SetCoords(aCoords)
Endif

// Cria o controle da agenda   
// Por enquanto ele faz a ponte direta entre a View e o Modelo 
// Os eventos atomicos da view ficam na View, apenas 
// os macro eventos sao repassados  

oControl := ZMVCCONTROL():New(oView)
oControl:AddModel(oModelAgenda)
oControl:AddModel(oModelPais)
oControl:AddModel(oModelEstado)

// ============================================
// Roda a View da Agenda
oAppAgenda:Run(oView)
// ============================================

// Encerra todos os contextos utilizados 
// -- Ordem inversa de cria��o -- 

// Encerra o control
oControl:Done()
FreeObj(oControl)

// Encerra o modelo de paises
oModelPais:Done()
FreeObj(oModelPais)

// Encerra o modelo da Agenda
oModelAgenda:Done()
FreeObj(oModelAgenda)

// Encerra a View
oView:Done()
FreeObj(oView)

// Encerra a definicao do pais                    
oPaisDef:Done()
FreeObj(oPaisDef)

// Encerra a defini��o da Agenda
oAgendaDef:Done()
FreeObj(oAgendaDef)

// Encerra a aplica��o 
oAppAgenda:Done()
FreeObj(oAppAgenda)

// Encerra o ambiente -- Junto com os objetos amarrados nele 
oEnv:Done()
FreeObj(oEnv)

Return

