#include 'protheus.ch'
#include 'zlib.ch' 

/* ======================================================

Definição do Componente PAISES

Este componente disponibiliza apenas consulta
A base de dados é importada de um arquicvo TXT 

TODO

- Criar conceito de tabela auto-contida com importação 
  automática na criação ou por rotina de carga 

====================================================== */

CLASS ZPAISDEF FROM ZTABLEDEF

  DATA oLogger         // Objeto de log 

  METHOD NEW()
  METHOD TableName()
  METHOD GetTitle()

  METHOD OnSearch() 
  
ENDCLASS 


// ------------------------------------------------------
// Cria a definição do componente 

METHOD NEW() CLASS ZPAISDEF
_Super:New("ZPAISDEF")

// Cria a definição do componente Pais

// Criar as definições extendidas de cada campo 
// Estas definições serão usadas pelos demais componentes

::oLogger := ZLOGGER():New("ZPAISDEF")
::oLogger:Write("NEW","Create Component Definition [ZPAISDEF]")

oFld := ::AddFieldDef("ID"    ,"C",03,0)
oFld:SetLabel("ID","Identificador de ttês letras do país -- Especificação ISO 3166-1 alfa-3")
oFld:SetPicture("!!!")
oFld:SetRequired(.T.)
 
oFld := ::AddFieldDef("NOME"  ,"C",50,0)
oFld:SetLabel("Nome","Nome do País (em Inglês)")
oFld:SetRequired(.T.)

// Acrescenta Definição de índices
::AddIndex("ID")   // Indice 01 por ID 
::AddIndex("NOME") // Indice 02 por NOME

// Índice único pelo campo ID 
::SetUnique("ID")

// Seta que esta tabela pode entrar inteira em CACHE 
::SetUseCache(.T.)

// Agora com a definicao montada, vamos acrescentar alguns eventos
// Os eventos recebem o modelo como parametro e são executados em 
// momemtos especificos durante a utilização da definição pelo modelo  

::AddEvent( ZDEF_ONSEARCH , { | oModel | self:OnSearch(oModel) } )

// Acrescenta ações nomeadas DEFAULT 
// As ações default possuem nome reservado 
// Por hora cadastro de países somente permite busca 

::AddAction("SEARCH","&Pesquisar")

Return self

// ----------------------------------------------------------

METHOD TableName() CLASS ZPAISDEF 
Return "PAIS"

// ----------------------------------------------------------

METHOD GetTitle() CLASS ZPAISDEF 
Return "Cadastro de Países"

// ----------------------------------------------------------
// Método chamado antes da busca, com a tabela aberta 

METHOD OnSearch(oModel) CLASS ZPAISDEF 

::oLogger:Write("OnSearch")

// Já que a tabela é TOPFILE, coloca uma ordem SQL 
oModel:oObjectTable:SetSQLOrderBy("NOME")

Return .T. 







// --------------------------------------------------
// Importar arquivo de paises 
// Requer arquivo "iso-3166-1.txt"
// 

User Function ImpPAis()
Local oEnv
Local oDBConn
Local cFile := 'PAIS'
Local oTable

// Cria o ambiente 
oEnv := ZLIBENV():New()
oEnv:SetEnv()

// Cria a conexao com o banco de dados
oDBConn  := ZDBACCESS():New()

// Guarda a conexao DEFAULT no ambiente
oEnv:SetObject("DBCONN",oDBConn)

// Conecta no DBAccess
lOk := oDBConn:Connect()

If !lOk   
	MsgStop( oDBConn:GetErrorStr() )
	Return
Endif

// Obtem o Objeto da tabela através da conexão 
oTable := oDBConn:GetTable(cFile)

// Abre em modo exclusivo 
If !oTable:Open(.T.,.T.)
	UserException( oTable:GetErrorStr() )
Endif

If oTable:LastRec() > 0

	MsgInfo("A Tabela de países já está populada")
	
Else
	
	nH := fOpen('\import\iso-3166-1.txt')
	nTam := fSeek(nH,0,2)
	fSeek(nH,0)
	cBuffer := space(nTam)
	fRead(nH,@cBuffer,nTam)
	fClose(nH)
	
	cBuffer := StrTran( cBuffer , CRLF , chr(10) )
	aLines := strtokarr2( cBuffer , chr(10)  )
	
	For nI := 1 to len(aLines)

		cLine := alltrim(aLines[nI])
		aTok := strtokarr2(cLine,chr(9))
		
		oTable:Insert()
		oTable:FieldPut(1,alltrim(aTok[1]))
		oTable:FieldPut(2,alltrim(aTok[2]))
		oTable:Update()
		
	Next
	
	MsgInfo("Tabela de países importada - "+cValToChar(len(aLines))+" Países")
	
Endif

oTable:Close()

// Desconecta do banco de dados
oDBConn:Disconnect()

// Encerra o ambiente -- Junto com os objetos amarrados nele 
oEnv:Done()
FreeObj(oEnv)


Return


