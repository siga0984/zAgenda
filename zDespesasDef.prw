#include 'protheus.ch'
#include 'zlib.ch' 

/* ======================================================

Definição do Componente DESPESAS

===================================================== */

CLASS ZDESPESASDEF FROM ZTABLEDEF

  DATA oLogger         // Objeto de log 

  METHOD NEW()
  METHOD TableName()
  METHOD GetTitle()

  METHOD OnInsert()
  METHOD OnSearch() 
  
ENDCLASS 


// ------------------------------------------------------
// Cria a definição do componente 

METHOD NEW() CLASS ZDESPESASDEF
_Super:New("ZDESPESASDEF")

// Cria a definição do componente DESPESAS

// Criar as definições extendidas de cada campo 
// Estas definições serão usadas pelos demais componentes

::oLogger := ZLOGGER():New("ZDESPESASDEF")
::oLogger:Write("NEW","Create Component Definition [ZDESPESASDEF]")

oFld := ::AddFieldDef("ID"    ,"C",08,0)
oFld:SetLabel("ID","ID da Despesa")
oFld:SetPicture("99999999")
oFld:SetRequired(.T.)
oFld:SetVisible(.F.)
 
/*
oFld := ::AddFieldDef("TIPODESP"  ,"C",6,0)
oFld:SetLabel("Tipo" ,"Tipo da Despesa")
oFld:SetPicture("999999")
oFld:SetLookUp("TIPODESP","ID","DESCR")

::AddAuxDef("ZTIPODESPDEF")
*/

oFld := ::AddFieldDef("DESCR"  ,"C",60,0)
oFld:SetLabel("Descrição" ,"Descrição Resumida da Despesa")

oFld := ::AddFieldDef("DTVENC"  ,"D",08,0)
oFld:SetLabel("Vencimento"  ,"Data do Vencimento")

oFld := ::AddFieldDef("VLVENC"  ,"N",12,2)
oFld:SetLabel("Valor" ,"Valor da Despesa")
oFld:SetPicture("@E 999,999,999.99")

oFld := ::AddFieldDef("DTPAGTO"  ,"D",08,0)
oFld:SetLabel("Pagamento"  ,"Data do Pagamento / Movimentação")

oFld := ::AddFieldDef("VLPGTO"  ,"N",12,2)
oFld:SetLabel("Valor Pago" ,"Valor do Pagamento")
oFld:SetPicture("@E 999,999,999.99")

// Acrescenta Definição de índices
::AddIndex("ID")        // Indice 01 por ID 
::AddIndex("DESCR")     // Indice 02 por Descrição
::AddIndex("DTVENC")    // Indice 03 por Vencimento
::AddIndex("DTPAGTO")   // Indice 04 por Pagamento

// Índice único pelo campo ID 
::SetUnique("ID")

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

METHOD TableName() CLASS ZDESPESASDEF 
Return "DESPESAS"

// ----------------------------------------------------------

METHOD GetTitle() CLASS ZDESPESASDEF 
Return "Registro de Despesas"

// ----------------------------------------------------------
// Método chamado na inserção , antes de gravar os dados 
// Se retornar .F. nao permite realizar a inserção 

METHOD OnInsert(oModel) CLASS ZDESPESASDEF 
Local cNewID  

::oLogger:Write("OnInsert")

// Cria um novo ID sequencial para gravar este contato 
// Por hora, pega o numero do ultimo registro e soma 1 
// TODO -- Fazer algo mais elegante para multi-thread 
// Como por exemplo usar um sequenciador

cNewID := StrZero(oModel:oObjectTable:LastRec()+1,8)
oModel:FieldPut("ID",cNewID)

Return .T. 

// ----------------------------------------------------------
// Método chamado antes da busca, com a tabela aberta 

METHOD OnSearch(oModel) CLASS ZDESPESASDEF 

::oLogger:Write("OnSearch")

// Já que a tabela é TOPFILE, coloca uma ordem SQL 
oModel:oObjectTable:SetSQLOrderBy("DESCR")

Return .T. 


