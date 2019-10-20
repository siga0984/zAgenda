#include 'protheus.ch'
#include 'zlib.ch' 

/* ======================================================

Defini��o do Componente DADOSBANC

Dados Banc�rios dos contatos da Agenda

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
// Cria a defini��o do componente Agenda 

METHOD NEW(cContexto) CLASS ZDADOSBANCDEF
_Super:New("ZDADOSBANCDEF")

If cContexto = NIL 
	cContexto := "DEFAULT"
Endif

// Cria a defini��o do componente DADOSBANC

// Criar as defini��es extendidas de cada campo 
// Estas defini��es ser�o usadas pelos demais componentes

::oLogger := ZLOGGER():New("ZDADOSBANCDEF")
::oLogger:Write("NEW","Create Component Definition [ZDADOSBANCDEF]")

oFld := ::AddFieldDef("IDDADOSBAN"  ,"C",06,0)
oFld:SetLabel("Id","Identificador do Dado Banc�rio")
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
oFld:SetLabel("Apelido","Apelido da Conta Banc�ria")
oFld:SetRequired(.T.)

oFld := ::AddFieldDef("IDBANCO"  ,"C",05,0)
oFld:SetLabel("Banco","C�digo do Banco")
oFld:SetPicture("@!")
oFld:SetRequired(.T.)
oFld:SetLookUp("BANCO","ID","NOME")

::AddAuxDef("ZBANCODEF")

oFld := ::AddFieldDef("AGENCIA"  ,"C",08,0)
oFld:SetLabel("Ag�ncia","N�mero da Ag�ncia Banc�ria")
oFld:SetPicture("@!")
oFld:SetRequired(.T.)

oFld := ::AddFieldDef("CONTA"  ,"C",16,0)
oFld:SetLabel("Conta","N�mero da Conta Banc�ria")
oFld:SetPicture("@!")
oFld:SetRequired(.T.)

oFld := ::AddFieldDef("OBSERV"  ,"M",10,0)
oFld:SetLabel("Observa��es","Observa��es sobre esta Conta Banc�ria")

// Acrescenta Defini��o de �ndices
::AddIndex("IDAGENDA+APELIDO")   // Indice 01 por ID DA AGENDA + APELIDO 

// �ndice �nico pelo campo ID + BANCO + AGENCIA + CONTA 
::SetUnique("IDAGENDA+IDBANCO+AGENCIA+CONTA")

// Agora com a definicao montada, vamos acrescentar alguns eventos
// Os eventos recebem o modelo como parametro e s�o executados em 
// momemtos especificos durante a utiliza��o da defini��o pelo modelo  

::AddEvent( ZDEF_ONINSERT , { | oModel | self:OnInsert(oModel) } )
::AddEvent( ZDEF_ONSEARCH , { | oModel | self:OnSearch(oModel) } )

// Acrescenta a��es nomeadas DEFAULT 
// As a��es default possuem nome reservado 
// Por hora cadastro de pa�ses somente permite busca 

::AddAction("SEARCH","&Pesquisar")
::AddAction("INSERT","&Inserir")
::AddAction("UPDATE","&Alterar")

Return self


// ----------------------------------------------------------

METHOD TableName() CLASS ZDADOSBANCDEF
Return "DADOSBANC"


// ----------------------------------------------------------

METHOD GetTitle() CLASS ZDADOSBANCDEF 
Return "Dados Banc�rios"

// ----------------------------------------------------------
// M�todo chamado na inser��o , antes de gravar os dados 
// Se retornar .F. nao permite realizar a inser��o 

METHOD OnInsert(oModel) CLASS ZDADOSBANCDEF
Local cNewID

::oLogger:Write("OnInsert")

cNewID := StrZero(oModel:oObjectTable:LastRec()+1,6)
oModel:FieldPut("IDDADOSBAN",cNewID)

Return .T. 

// ----------------------------------------------------------
// M�todo chamado antes da busca, com a tabela aberta 

METHOD OnSearch(oModel) CLASS ZDADOSBANCDEF 

::oLogger:Write("OnSearch")

// J� que a tabela � TOPFILE, coloca uma ordem SQL 
oModel:oObjectTable:SetSQLOrderBy("IDAGENDA,APELIDO")

Return .T. 

