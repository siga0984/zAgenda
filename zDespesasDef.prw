/* -------------------------------------------------------------------------------------------

Copyright 2015-2019 J�lio Wittwer ( siga0984@gmail.com | http://siga0984.wordpress.com/ )

� permitido, gratuitamente, a qualquer pessoa que obtenha uma c�pia deste software 
e dos arquivos de documenta��o associados (o "Software"), para negociar o Software 
sem restri��es, incluindo, sem limita��o, os direitos de uso, c�pia, modifica��o, fus�o,
publica��o, distribui��o, sublicenciamento e/ou venda de c�pias do Software, 
SEM RESTRI��ES OU LIMITA��ES. 

O SOFTWARE � FORNECIDO "TAL COMO EST�", SEM GARANTIA DE QUALQUER TIPO, EXPRESSA OU IMPL�CITA,
INCLUINDO MAS N�O SE LIMITANDO A GARANTIAS DE COMERCIALIZA��O, ADEQUA��O A UMA FINALIDADE
ESPEC�FICA E N�O INFRAC��O. EM NENHUM CASO OS AUTORES OU TITULARES DE DIREITOS AUTORAIS
SER�O RESPONS�VEIS POR QUALQUER REIVINDICA��O, DANOS OU OUTRA RESPONSABILIDADE, SEJA 
EM A��O DE CONTRATO OU QUALQUER OUTRA FORMA, PROVENIENTE, FORA OU RELACIONADO AO SOFTWARE. 

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

Defini��o do Componente DESPESAS

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
// Cria a defini��o do componente 

METHOD NEW() CLASS ZDESPESASDEF
_Super:New("ZDESPESASDEF")

// Cria a defini��o do componente DESPESAS

// Criar as defini��es extendidas de cada campo 
// Estas defini��es ser�o usadas pelos demais componentes

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
oFld:SetLabel("Descri��o" ,"Descri��o Resumida da Despesa")

oFld := ::AddFieldDef("DTVENC"  ,"D",08,0)
oFld:SetLabel("Vencimento"  ,"Data do Vencimento")

oFld := ::AddFieldDef("VLVENC"  ,"N",12,2)
oFld:SetLabel("Valor" ,"Valor da Despesa")
oFld:SetPicture("@E 999,999,999.99")

oFld := ::AddFieldDef("DTPAGTO"  ,"D",08,0)
oFld:SetLabel("Pagamento"  ,"Data do Pagamento / Movimenta��o")

oFld := ::AddFieldDef("VLPGTO"  ,"N",12,2)
oFld:SetLabel("Valor Pago" ,"Valor do Pagamento")
oFld:SetPicture("@E 999,999,999.99")

// Acrescenta Defini��o de �ndices
::AddIndex("ID")        // Indice 01 por ID 
::AddIndex("DESCR")     // Indice 02 por Descri��o
::AddIndex("DTVENC")    // Indice 03 por Vencimento
::AddIndex("DTPAGTO")   // Indice 04 por Pagamento

// �ndice �nico pelo campo ID 
::SetUnique("ID")

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

METHOD TableName() CLASS ZDESPESASDEF 
Return "DESPESAS"

// ----------------------------------------------------------

METHOD GetTitle() CLASS ZDESPESASDEF 
Return "Registro de Despesas"

// ----------------------------------------------------------
// M�todo chamado na inser��o , antes de gravar os dados 
// Se retornar .F. nao permite realizar a inser��o 

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
// M�todo chamado antes da busca, com a tabela aberta 

METHOD OnSearch(oModel) CLASS ZDESPESASDEF 

::oLogger:Write("OnSearch")

// J� que a tabela � TOPFILE, coloca uma ordem SQL 
oModel:oObjectTable:SetSQLOrderBy("DESCR")

Return .T. 


