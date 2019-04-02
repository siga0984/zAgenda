#include 'protheus.ch'
#include 'zlib.ch' 

/* ======================================================

Defini��o do Componente BANCOS

Este componente disponibiliza apenas consulta
A base de dados � importada de um arquicvo TXT 

TODO

- Criar conceito de tabela auto-contida com importa��o 
  autom�tica na cria��o ou por rotina de carga 

====================================================== */

CLASS ZBANCODEF FROM ZTABLEDEF

  DATA oLogger         // Objeto de log 

  METHOD NEW()

  METHOD OnSearch() 
  
ENDCLASS 


// ------------------------------------------------------
// Cria a defini��o do componente Agenda 

METHOD NEW() CLASS ZBANCODEF
_Super:New("DEF_BANCO")

// Cria a defini��o do componente Banco

// Criar as defini��es extendidas de cada campo 
// Estas defini��es ser�o usadas pelos demais componentes

::oLogger := ZLOGGER():New("ZBANCODEF")
::oLogger:Write("NEW","Create Component Definition [DEF_BANCO]")

oFld := ::AddFieldDef("ID"    ,"C",05,0)
oFld:SetLabel("ID","Identificador ou C�digo Alfanum�rico do Banco")
oFld:SetPicture("@!")
oFld:SetRequired(.T.)
 
oFld := ::AddFieldDef("NOME"  ,"C",60,0)
oFld:SetLabel("Nome","Nome do Banco")
oFld:SetRequired(.T.)

// Acrescenta Defini��o de �ndices
::AddIndex("ID")   // Indice 01 por ID 
::AddIndex("NOME") // Indice 02 por NOME

// �ndice �nico pelo campo ID 
::SetUnique("ID")

// Agora com a definicao montada, vamos acrescentar alguns eventos
// Os eventos recebem o modelo como parametro e s�o executados em 
// momemtos especificos durante a utiliza��o da defini��o pelo modelo  

::AddEvent( ZDEF_ONSEARCH , { | oModel | self:OnSearch(oModel) } )

// Acrescenta a��es nomeadas DEFAULT 
// As a��es default possuem nome reservado 
// Por hora cadastro de pa�ses somente permite busca 

::AddAction("SEARCH","&Pesquisar")

Return self

// ----------------------------------------------------------
// M�todo chamado antes da busca, com a tabela aberta 

METHOD OnSearch(oModel) CLASS ZBANCODEF 

::oLogger:Write("OnSearch")

// J� que a tabela � TOPFILE, coloca uma ordem SQL 
oModel:oObjectTable:SetSQLOrderBy("NOME")

Return .T. 








// --------------------------------------------------
// Importar arquivo de BAncos TXT
// Requer arquivo "Bancos_br.txt"
// 

User Function ImpBanco()
Local oEnv
Local oDBConn
Local cFile := 'BANCO'
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

// -- Deleta a Tabela
// TCDelFile(cFile)

// Obtem o Objeto da tabela atrav�s da conex�o 
oTable := oDBConn:GetTable(cFile)

If !oTable:Exists()  

	oDef := ZBANCODEF():New()
	oTable:Create( oDef:GetStruct() )
	MsgInfo("Tabela [BANCO] criada")
	
Endif

// Abre em modo exclusivo 
If !oTable:Open(.T.,.T.)
	UserException( oTable:GetErrorStr() )
Endif

If oTable:LastRec() > 0

	MsgInfo("A Tabela de pa�ses j� est� populada")
	
Else
	
	nH := fOpen('\import\Bancos_br.txt')
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

        cId := alltrim(aTok[1])
        If len(cId)<3
        	cId := Padl(cId,3,'0')
        Endif
		
		oTable:Insert()
		oTable:FieldPut(1,cId)
		oTable:FieldPut(2,alltrim(aTok[2]))
		oTable:Update()
		
	Next
	
	MsgInfo("Tabela de BAncos importada - "+cValToChar(len(aLines))+" Banco(s)")
	
Endif

oTable:Close()

// Desconecta do banco de dados
oDBConn:Disconnect()

// Encerra o ambiente -- Junto com os objetos amarrados nele 
oEnv:Done()
FreeObj(oEnv)


Return


