/* -------------------------------------------------------------------------------------------

Copyright 2015-2019 Júlio Wittwer ( siga0984@gmail.com | http://siga0984.wordpress.com/ )

É permitido, gratuitamente, a qualquer pessoa que obtenha uma cópia deste software 
e dos arquivos de documentação associados (o "Software"), para negociar o Software 
sem restrições, incluindo, sem limitação, os direitos de uso, cópia, modificação, fusão,
publicação, distribuição, sublicenciamento e/ou venda de cópias do Software, 
SEM RESTRIÇÕES OU LIMITAÇÕES. 

O SOFTWARE É FORNECIDO "TAL COMO ESTÁ", SEM GARANTIA DE QUALQUER TIPO, EXPRESSA OU IMPLÍCITA,
INCLUINDO MAS NÃO SE LIMITANDO A GARANTIAS DE COMERCIALIZAÇÃO, ADEQUAÇÃO A UMA FINALIDADE
ESPECÍFICA E NÃO INFRACÇÃO. EM NENHUM CASO OS AUTORES OU TITULARES DE DIREITOS AUTORAIS
SERÃO RESPONSÁVEIS POR QUALQUER REIVINDICAÇÃO, DANOS OU OUTRA RESPONSABILIDADE, SEJA 
EM AÇÃO DE CONTRATO OU QUALQUER OUTRA FORMA, PROVENIENTE, FORA OU RELACIONADO AO SOFTWARE. 

                    *** USE A VONTADE, POR SUA CONTA E RISCO ***

Permission is hereby granted, free of charge, to any person obtaining a copy of this software
and associated documentation files (the "Software"), to deal in the Software without 
restriction, including without limitation the rights to use, copy, modify, merge, publish, 
distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom 
the Software is furnished to do so, WITHOUT RESTRICTIONS OR LIMITATIONS. 

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR 
PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE 
FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT 
OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE. 

                    *** USE AS YOU WISH , AT YOUR OWN RISK ***

------------------------------------------------------------------------------------------- */



#include 'protheus.ch'
#include 'zlib.ch' 

/* ======================================================

Definição do Componente BANCOS

Este componente disponibiliza apenas consulta
A base de dados é importada de um arquicvo TXT 

TODO

- Criar conceito de tabela auto-contida com importação 
  automática na criação ou por rotina de carga 

====================================================== */

CLASS ZBANCODEF FROM ZTABLEDEF

  DATA oLogger         // Objeto de log 

  METHOD NEW()
  METHOD TableName()
  METHOD GetTitle()

  METHOD OnSearch() 
  
ENDCLASS 


// ------------------------------------------------------
// Cria a definição do componente Agenda 

METHOD NEW() CLASS ZBANCODEF
_Super:New("ZBANCODEF")

// Cria a definição do componente Banco

// Criar as definições extendidas de cada campo 
// Estas definições serão usadas pelos demais componentes

::oLogger := ZLOGGER():New("ZBANCODEF")
::oLogger:Write("NEW","Create Component Definition [ZBANCODEF]")

oFld := ::AddFieldDef("ID"    ,"C",05,0)
oFld:SetLabel("ID","Identificador ou Código Alfanumérico do Banco")
oFld:SetPicture("@!")
oFld:SetRequired(.T.)
 
oFld := ::AddFieldDef("NOME"  ,"C",60,0)
oFld:SetLabel("Nome","Nome do Banco")
oFld:SetRequired(.T.)

// Acrescenta Definição de índices
::AddIndex("ID")   // Indice 01 por ID 
::AddIndex("NOME") // Indice 02 por NOME

// Índice único pelo campo ID 
::SetUnique("ID")

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

METHOD TableName() CLASS ZBANCODEF 
Return "BANCO"

// ----------------------------------------------------------

METHOD GetTitle() CLASS ZBANCODEF 
Return "Cadastro de Bancos"

// ----------------------------------------------------------
// Método chamado antes da busca, com a tabela aberta 

METHOD OnSearch(oModel) CLASS ZBANCODEF 

::oLogger:Write("OnSearch")

// Já que a tabela é TOPFILE, coloca uma ordem SQL 
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
Local oDefFactory
Local oBancoDef
Local nI

// Cria o ambiente 
oEnv := ZLIBENV():New()
oEnv:SetEnv()

// Cria e Guarda o FACTORY de Definições no ambiente
oDefFactory := ZDEFFACTORY():New()
oEnv:SetObject("ZDEFFACTORY",oDefFactory)

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

// Obtem o Objeto da tabela através da conexão 
oTable := oDBConn:GetTable(cFile)

If !oTable:Exists()  

	oBancoDef := oDefFactory:GetNewDef("ZBANCODEF")
	oTable:Create( oBancoDef:GetStruct() )
	MsgInfo("Tabela [BANCO] criada")
	
Endif

// Abre em modo exclusivo 
If !oTable:Open(.T.,.T.)
	UserException( oTable:GetErrorStr() )
Endif

If oTable:LastRec() > 0

	MsgInfo("A Tabela de países já está populada")
	
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


