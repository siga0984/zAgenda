#include 'protheus.ch'
#include 'zlib.ch' 

/* -------------------------------
  #define ZDEF_ONNEWREC    1
  #define ZDEF_ONINSERT    2
  #define ZDEF_ONUPDATE    4
  #define ZDEF_ONDELETE    8
  #define ZDEF_ONSEARCH    16
  #define ZDEF_ONCANCEL    32
  #define ZDEF_ONGETDATA   64
------------------------------- */

/* ======================================================

Definição do Componente ESTADOI ( UF ) 

Este componente disponibiliza apenas consulta
A base de dados é importada de um arquicvo TXT 

TODO

- Criar conceito de tabela auto-contida com importação 
  automática na criação ou por rotina de carga 

====================================================== */

CLASS ZESTADODEF FROM ZTABLEDEF

  DATA oLogger         // Objeto de log 

  METHOD NEW()

  METHOD OnNewRec()
  METHOD OnInsert()
  METHOD OnSearch() 
  METHOD OnUpdate() 
  
ENDCLASS 


// ------------------------------------------------------
// Cria a definição do componente Agenda 

METHOD NEW() CLASS ZESTADODEF
_Super:New("DEF_ESTADO")

// Cria a definição do componente Estado

// Criar as definições extendidas de cada campo 
// Estas definições serão usadas pelos demais componentes

::oLogger := ZLOGGER():New("ZESTADODEF")
::oLogger:Write("NEW","Create Component Definition [DEF_ESTADO]")

oFld := ::AddFieldDef("UF"    ,"C",2,0)
oFld:SetLabel("UF","Sigla identificadora do Estado (UF)")
oFld:SetPicture("!!")
oFld:SetRequired(.T.)
 
oFld := ::AddFieldDef("NOME"  ,"C",20,0)
oFld:SetLabel("Nome","Nome do Estado Brasileiro")
oFld:SetRequired(.T.)

oFld := ::AddFieldDef("CODIBGE"    ,"C",2,0)
oFld:SetLabel("Cód. IBGE","Número do Estado segundo o IBGE")
oFld:SetPicture("!!")
oFld:SetRequired(.T.)

// Acrescenta Definição de índices
::AddIndex("UF")   // Indice 01 por ID 
::AddIndex("NOME") // Indice 02 por NOME

// Índice único pelo campo ID 
::SetUnique("UF")

// Agora com a definicao montada, vamos acrescentar alguns eventos
// Os eventos recebem o modelo como parametro e são executados em 
// momemtos especificos durante a utilização da definição pelo modelo  

::AddEvent( ZDEF_ONNEWREC , { | oModel | self:OnNewRec(oModel) } )
::AddEvent( ZDEF_ONINSERT , { | oModel | self:OnInsert(oModel) } )
::AddEvent( ZDEF_ONSEARCH , { | oModel | self:OnSearch(oModel) } )
::AddEvent( ZDEF_ONUPDATE , { | oModel | self:OnUpdate(oModel) } )

// Acrescenta ações nomeadas DEFAULT 
// As ações default possuem nome reservado 
// Por hora cadastro de estados somente permite busca 

::AddAction("SEARCH","Pesquisar")

Return self


// ----------------------------------------------------------
// Método chamado na inserção , na criação 
// de um novo registro em branco para inserção
// Se retornar .F. nao permite iniciar a operação 

METHOD OnNewRec() CLASS ZESTADODEF 
::oLogger:Write("OnNewRec")
Return .T. 


// ----------------------------------------------------------
// Método chamado na inserção , antes de gravar os dados 
// Se retornar .F. nao permite realizar a inserção 

METHOD OnInsert(oModel) CLASS ZESTADODEF

::oLogger:Write("OnInsert")

Return .T. 

// ----------------------------------------------------------
// Método chamado antes da busca, com a tabela aberta 

METHOD OnSearch(oModel) CLASS ZESTADODEF 

::oLogger:Write("OnSearch")

// Já que a tabela é TOPFILE, coloca uma ordem SQL 
oModel:oObjectTable:SetSQLOrderBy("NOME")

Return .T. 


// ----------------------------------------------------------
// Metodo chamado antes do update do registro
// Permite consultar ou alterar os valores dos 
// campos usando FieldGet / FieldPut do Modelo

METHOD OnUpdate() CLASS ZESTADODEF 

::oLogger:Write("OnUpdate")

Return .T. 



// --------------------------------------------------
// Importar arquivo de Estados Brasileiros  
// http://www.lgncontabil.com.br/icms/Tabela-Codigo-de-UF-do-IBGE.pdf
// Rotina depende do arquivo \import\estados-br.txt

User Function ImpUF()
Local oEnv
Local oDBConn
Local cFile := 'ESTADO'
Local oTable
Local oDef

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

If !oTable:Exists()
	oDef := ZESTADODEF():New()
	oTable:Create( oDef:GetStruct() )
	MsgInfo("TAbela [ESTADOS] criada")
	
Endif

// Abre em modo exclusivo 
If !oTable:Open(.T.,.T.)
	UserException( oTable:GetErrorStr() )
Endif

If oTable:LastRec() > 0

	MsgInfo("A Tabela de estados já está populada")
	
Else
	
	nH := fOpen('\import\estados-br.txt')
	nTam := fSeek(nH,0,2)
	fSeek(nH,0)
	cBuffer := space(nTam)
	fRead(nH,@cBuffer,nTam)
	fClose(nH)
	
	cBuffer := StrTran( cBuffer , CRLF , chr(10) )
	aLines := strtokarr2( cBuffer , chr(10)  )
	
	For nI := 1 to len(aLines)

		cLine := alltrim(aLines[nI])
		aTok := strtokarr2(cLine,'-')
		
		oTable:Insert()
		oTable:FieldPut(1,alltrim(aTok[3]))
		oTable:FieldPut(2,alltrim(aTok[2]))
		oTable:FieldPut(3,alltrim(aTok[1]))
		oTable:Update()
		
	Next
	
	MsgInfo("Tabela de estados importada - "+cValToChar(len(aLines))+" estados")
	
Endif

oTable:Close()

// Desconecta do banco de dados
oDBConn:Disconnect()

// Encerra o ambiente -- Junto com os objetos amarrados nele 
oEnv:Done()
FreeObj(oEnv)


Return


