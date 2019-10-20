#include 'protheus.ch'
#include 'zlib.ch' 

/* ======================================================

Definição do Componente DADOSBANC

Dados Bancários dos contatos da Agenda

====================================================== */

CLASS ZDADOSBANCDEF FROM ZTABLEDEF

  DATA oLogger         // Objeto de log 

  METHOD NEW(cContexto)
  METHOD TableName()
  METHOD GetTitle()

  METHOD OnInsert()
  METHOD OnSearch() 
  
ENDCLASS 


// ------------------------------------------------------
// Cria a definição do componente Agenda 

METHOD NEW(cContexto) CLASS ZDADOSBANCDEF
_Super:New("ZDADOSBANCDEF")

If cContexto = NIL 
	cContexto := "DEFAULT"
Endif

// Cria a definição do componente DADOSBANC

// Criar as definições extendidas de cada campo 
// Estas definições serão usadas pelos demais componentes

::oLogger := ZLOGGER():New("ZDADOSBANCDEF")
::oLogger:Write("NEW","Create Component Definition [ZDADOSBANCDEF]")

oFld := ::AddFieldDef("IDDADOSBAN"  ,"C",06,0)
oFld:SetLabel("Id","Identificador do Dado Bancário")
oFld:SetPicture("999999")
oFld:SetRequired(.T.)
oFld:SetVisible(.F.)

oFld := ::AddFieldDef("IDAGENDA"    ,"C",06,0)
oFld:SetLabel("ID","Identificador do Contato da Agenda")
oFld:SetPicture("999999")
oFld:SetRequired(.T.)  
oFld:SetLookUp("AGENDA","ID","NOME")

::AddAuxDef("ZAGENDADEF")

If cContexto = 'AGENDA'
	oFld:SetVisible(.F.) 
Endif
 
oFld := ::AddFieldDef("APELIDO"  ,"C",30,0)
oFld:SetLabel("Apelido","Apelido da Conta Bancária")
oFld:SetRequired(.T.)

oFld := ::AddFieldDef("IDBANCO"  ,"C",05,0)
oFld:SetLabel("Banco","Código do Banco")
oFld:SetPicture("@!")
oFld:SetRequired(.T.)
oFld:SetLookUp("BANCO","ID","NOME")

::AddAuxDef("ZBANCODEF")

oFld := ::AddFieldDef("AGENCIA"  ,"C",08,0)
oFld:SetLabel("Agência","Número da Agência Bancária")
oFld:SetPicture("@!")
oFld:SetRequired(.T.)

oFld := ::AddFieldDef("CONTA"  ,"C",16,0)
oFld:SetLabel("Conta","Número da Conta Bancária")
oFld:SetPicture("@!")
oFld:SetRequired(.T.)

oFld := ::AddFieldDef("OBSERV"  ,"M",10,0)
oFld:SetLabel("Observações","Observações sobre esta Conta Bancária")

// Acrescenta Definição de índices
::AddIndex("IDAGENDA+APELIDO")   // Indice 01 por ID DA AGENDA + APELIDO 

// Índice único pelo campo ID + BANCO + AGENCIA + CONTA 
::SetUnique("IDAGENDA+IDBANCO+AGENCIA+CONTA")

// Agora com a definicao montada, vamos acrescentar alguns eventos
// Os eventos recebem o modelo como parametro e são executados em 
// momemtos especificos durante a utilização da definição pelo modelo  

::AddEvent( ZDEF_ONINSERT , { | oModel | self:OnInsert(oModel) } )
::AddEvent( ZDEF_ONSEARCH , { | oModel | self:OnSearch(oModel) } )

// Acrescenta ações nomeadas DEFAULT 
// As ações default possuem nome reservado 
// Por hora cadastro de países somente permite busca 

::AddAction("SEARCH","&Pesquisar")
::AddAction("INSERT","&Inserir")
::AddAction("UPDATE","&Alterar")

Return self


// ----------------------------------------------------------

METHOD TableName() CLASS ZDADOSBANCDEF
Return "DADOSBANC"


// ----------------------------------------------------------

METHOD GetTitle() CLASS ZDADOSBANCDEF 
Return "Dados Bancários"

// ----------------------------------------------------------
// Método chamado na inserção , antes de gravar os dados 
// Se retornar .F. nao permite realizar a inserção 

METHOD OnInsert(oModel) CLASS ZDADOSBANCDEF
Local cNewID

::oLogger:Write("OnInsert")

cNewID := StrZero(oModel:oObjectTable:LastRec()+1,6)
oModel:FieldPut("IDDADOSBAN",cNewID)

Return .T. 

// ----------------------------------------------------------
// Método chamado antes da busca, com a tabela aberta 

METHOD OnSearch(oModel) CLASS ZDADOSBANCDEF 

::oLogger:Write("OnSearch")

// Já que a tabela é TOPFILE, coloca uma ordem SQL 
oModel:oObjectTable:SetSQLOrderBy("IDAGENDA,APELIDO")

Return .T. 

