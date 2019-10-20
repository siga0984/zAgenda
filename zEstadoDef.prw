#include 'protheus.ch'
#include 'zlib.ch' 

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
  METHOD TableName()
  METHOD GetTitle()

  METHOD OnSearch() 
  
ENDCLASS 


// ------------------------------------------------------
// Cria a definição do componente 

METHOD NEW() CLASS ZESTADODEF
_Super:New("ZESTADODEF")

// Cria a definição do componente Estado

// Criar as definições extendidas de cada campo 
// Estas definições serão usadas pelos demais componentes

::oLogger := ZLOGGER():New("ZESTADODEF")
::oLogger:Write("NEW","Create Component Definition [ZESTADODEF]")

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

// Seta que esta tabela pode entrar inteira em CACHE 
::SetUseCache(.T.)

// Agora com a definicao montada, vamos acrescentar alguns eventos
// Os eventos recebem o modelo como parametro e são executados em 
// momemtos especificos durante a utilização da definição pelo modelo  

::AddEvent( ZDEF_ONSEARCH , { | oModel | self:OnSearch(oModel) } )

// Acrescenta ações nomeadas DEFAULT 
// As ações default possuem nome reservado 
// Por hora cadastro de estados somente permite busca 

::AddAction("SEARCH","&Pesquisar")

Return self
            
// ----------------------------------------------------------

METHOD TableName() CLASS ZESTADODEF 
Return "ESTADO"

// ----------------------------------------------------------

METHOD GetTitle() CLASS ZESTADODEF 
Return "Cadastro de Estados Brasileiros"


// ----------------------------------------------------------
// Método chamado antes da busca, com a tabela aberta 

METHOD OnSearch(oModel) CLASS ZESTADODEF 

::oLogger:Write("OnSearch")

// Já que a tabela é TOPFILE, coloca uma ordem SQL 
oModel:oObjectTable:SetSQLOrderBy("NOME")

Return .T. 






// --------------------------------------------------
// Importar arquivo de Estados Brasileiros  
// http://www.lgncontabil.com.br/icms/Tabela-Codigo-de-UF-do-IBGE.pdf
// Rotina depende do arquivo \import\estados-br.txt

User Function ImpUF()
Local oEnv
Local cFile := 'ESTADO'
Local oTable
Local oEstadoDef
Local oDBConn
Local oDefFactory

// Cria o ambiente 
oEnv := ZLIBENV():New()
oEnv:SetEnv()

// Cria e Guarda o FACTORY de Definições no ambiente
oDefFactory := ZDEFFACTORY():New()
oEnv:SetObject("ZDEFFACTORY",oDefFactory)

// Cria a conexao com o banco de dados
// Guarda a conexao DEFAULT no ambiente
oDBConn  := ZDBACCESS():New()
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
	oEstadoDef := oDefFactory:GetNewDef("ZESTADODEF")
	oTable:Create( oEstadoDef:GetStruct() )
	MsgInfo("Tabela [ESTADOS] criada")
	
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


