#include 'protheus.ch'
#include 'zlib.ch' 

/* ======================================================

Defini��o do Componente ESTADOI ( UF ) 

Este componente disponibiliza apenas consulta
A base de dados � importada de um arquicvo TXT 

TODO

- Criar conceito de tabela auto-contida com importa��o 
  autom�tica na cria��o ou por rotina de carga 

====================================================== */

CLASS ZESTADODEF FROM ZTABLEDEF

  DATA oLogger         // Objeto de log 

  METHOD NEW()

  METHOD OnSearch() 
  
ENDCLASS 


// ------------------------------------------------------
// Cria a defini��o do componente Agenda 

METHOD NEW() CLASS ZESTADODEF
_Super:New("DEF_ESTADO")

// Cria a defini��o do componente Estado

// Criar as defini��es extendidas de cada campo 
// Estas defini��es ser�o usadas pelos demais componentes

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
oFld:SetLabel("C�d. IBGE","N�mero do Estado segundo o IBGE")
oFld:SetPicture("!!")
oFld:SetRequired(.T.)

// Acrescenta Defini��o de �ndices
::AddIndex("UF")   // Indice 01 por ID 
::AddIndex("NOME") // Indice 02 por NOME

// �ndice �nico pelo campo ID 
::SetUnique("UF")

// Seta que esta tabela pode entrar inteira em CACHE 
::SetUseCache(.T.)

// Agora com a definicao montada, vamos acrescentar alguns eventos
// Os eventos recebem o modelo como parametro e s�o executados em 
// momemtos especificos durante a utiliza��o da defini��o pelo modelo  

::AddEvent( ZDEF_ONSEARCH , { | oModel | self:OnSearch(oModel) } )

// Acrescenta a��es nomeadas DEFAULT 
// As a��es default possuem nome reservado 
// Por hora cadastro de estados somente permite busca 

::AddAction("SEARCH","&Pesquisar")

Return self

// ----------------------------------------------------------
// M�todo chamado antes da busca, com a tabela aberta 

METHOD OnSearch(oModel) CLASS ZESTADODEF 

::oLogger:Write("OnSearch")

// J� que a tabela � TOPFILE, coloca uma ordem SQL 
oModel:oObjectTable:SetSQLOrderBy("NOME")

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

// Obtem o Objeto da tabela atrav�s da conex�o 
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

	MsgInfo("A Tabela de estados j� est� populada")
	
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


