#include 'protheus.ch'
#include 'zlib.ch' 

#define RED_DESIGN 
// #define BLUE_DESIGN
// #define GREEN_DESIGN 
// #define OLD_DESIGN 

#include  'zmvcview.ch'

/* ======================================================

Defini��o do Componente AGENDA 

Herda da defini��o da tabela 

TODO : Rever este conceito, um componente pode usar varias tabelas 
TODO : Acoes deve ser especialistas, ou na declara��o ou 
       devem passar por uma etapa de registro 

====================================================== */

CLASS ZAGENDADEF FROM ZTABLEDEF

  DATA oLogger         // Objeto de log 

  METHOD NEW()
  METHOD TableName()
  METHOD GetTitle()
  
  METHOD OnInsert()
  METHOD OnSearch() 
  METHOD OnGetData() 
  
  METHOD OpenGMap()
  METHOD OpenGMail()
  METHOD Observ()
  METHOD Foto3x4()
  METHOD DadosBanc()
   
ENDCLASS 


// ------------------------------------------------------
// Cria a defini��o do componente 

METHOD NEW() CLASS ZAGENDADEF
_Super:New("ZAGENDADEF")

// Criar as defini��es extendidas de cada campo 
// Estas defini��es ser�o usadas pelos demais componentes

::oLogger := ZLOGGER():New("ZAGENDADEF")
::oLogger:Write("NEW","Create Component Definition [ZAGENDADEF]")

oFld := ::AddFieldDef("ID"    ,"C",06,0)
oFld:SetLabel("ID","N�mero identificador do Contato da Agenda")
oFld:SetPicture("999999")
oFld:SetRequired(.T.)
oFld:SetVisible(.F.)
 
oFld := ::AddFieldDef("NOME"  ,"C",50,0)
oFld:SetLabel("Nome","Nome do Contato da Agenda")
oFld:SetPicture("@!")
oFld:SetRequired(.T.)

oFld := ::AddFieldDef("APELIDO"  ,"C",30,0)
oFld:SetLabel("Apelido","Apelido do contato da Agenda")
oFld:SetPicture("@!")

oFld := ::AddFieldDef("ENDER" ,"C",50,0)
oFld:SetLabel("Endere�o","Endere�o ( Rua e Numero ) do Contato da Agenda")
oFld:SetPicture("@!")
 
oFld := ::AddFieldDef("COMPL" ,"C",20,0)
oFld:SetLabel("Complemento","Complemento do Endere�o ( Casa, Apto, Bloco, Sala ) do Contato da Agenda")
oFld:SetPicture("@!")
 
oFld := ::AddFieldDef("BAIRR" ,"C",30,0)
oFld:SetLabel("Bairro","Bairro do Endere�o do Contato da Agenda")
oFld:SetPicture("@!")
 
oFld := ::AddFieldDef("CIDADE","C",40,0)
oFld:SetLabel("Cidade","Cidade do Endere�o do Contato da Agenda")
oFld:SetPicture("@!")

oFld := ::AddFieldDef("UF"    ,"C",02,0)
oFld:SetLabel("UF","Estado (Unidade da Federa��o) do Endere�o do Contato da Agenda")
oFld:SetPicture("!!")
oFld:SetLookUp("ESTADO","UF","NOME")

::AddAuxDef("ZESTADODEF")
 
oFld := ::AddFieldDef("CEP"   ,"C",08,0)
oFld:SetLabel("CEP","C�digo de Endere�amento Postal do Endere�o do Contato da Agenda")
oFld:SetPicture("@R 99999-999")
 
oFld := ::AddFieldDef("NACION","C",3,0)
oFld:SetLabel("Nacionalidade","Pa�s de Origem / Nacionalidade do Contato da Agenda")
oFld:SetPicture("!!!")
oFld:SetLookUp("PAIS","ID","NOME")

::AddAuxDef("ZPAISDEF")

oFld := ::AddFieldDef("DTNASC"   ,"D",8,0)
oFld:SetLabel("Nascimento","Data de Nascimento do Contato da Agenda")
 
oFld := ::AddFieldDef("CPF"   ,"C",11,0)
oFld:SetLabel("CPF","N�mero do Cadastro de Pessoas F�sicas da Receita Federal")
oFld:SetPicture("@R 999.999.999-99")

oFld := ::AddFieldDef("RG"    ,"C",20,0)
oFld:SetLabel("RG","N�mero do Registro Geral / Identidade + Org�o Emissor / Estado ")
oFld:SetPicture("@!")
 
oFld := ::AddFieldDef("CNH"   ,"C",12,0)
oFld:SetLabel("CNH","N�mero da Carteira Nacional de HAbilita��o")
oFld:SetPicture("@!")
 
oFld := ::AddFieldDef("PASSID","C",15,0)
oFld:SetLabel("Passaporte","N�mero ou C�digo identificador do Passaporte")
oFld:SetPicture("@!")

oFld := ::AddFieldDef("PASSNAC","C",3,0)
oFld:SetLabel("Pa�s","Nacionalidade de emiss�o do Passaporte")
oFld:SetPicture("!!!")
oFld:SetLookUp("PAIS","ID","NOME")

oFld := ::AddFieldDef("FONE1" ,"C",20,0)
oFld:SetLabel("Telefone 1","PRimeiro telefone do Contato da Agenda")
oFld:SetPicture("@!")

oFld := ::AddFieldDef("FONE2" ,"C",20,0)
oFld:SetLabel("Telefone 2","Segundo telefone do Contato da Agenda")
oFld:SetPicture("@!")
 
oFld := ::AddFieldDef("EMAIL" ,"C",60,0)
oFld:SetLabel("e-Mail","Endere�o de correspond�ncia eletr�nica do Contato da Agenda")
oFld:SetPicture("@!")

oFld := ::AddFieldDef("SKYPE" ,"C",60,0)
oFld:SetLabel("Skype","ID de Usu�rio do contato no Aplicativo Skype")
oFld:SetPicture("@!")
 
oFld := ::AddFieldDef("FACEB" ,"C",60,0)
oFld:SetLabel("Facebook","URL ou usu�rio da rede social FaceBook")
oFld:SetPicture("@!")

oFld := ::AddFieldDef("LINKEDIN" ,"C",60,0)
oFld:SetLabel("LinkedIn","URL ou usu�rio da rede profissional de contatos LinkedIN")
oFld:SetPicture("@!")

oFld := ::AddFieldDef("OBSERV" ,"M",10,0)
oFld:SetLabel("Observa��es","Campo de texto livre com informa��es adicionais do Contato da Agenda")
oFld:SetVisible(.F.)

oFld := ::AddFieldDef("IMAGE" ,"M",10,0)
oFld:SetLabel("Imagem","Imagem com a foto do contato")
oFld:SetVisible(.F.)

// Acrescenta Defini��o de �ndices
::AddIndex("ID")   // Indice 01 por ID 
::AddIndex("NOME") // Indice 02 por NOME

// �ndice �nico pelo campo ID 
::SetUnique("ID")

// Agora com a definicao montada, vamos acrescentar alguns eventos
// Os eventos recebem o modelo como parametro e s�o executados em 
// momemtos especificos durante a utiliza��o da defini��o pelo modelo  

::AddEvent( ZDEF_ONINSERT  , { | oModel | self:OnInsert(oModel) } )
::AddEvent( ZDEF_ONSEARCH  , { | oModel | self:OnSearch(oModel) } )
::AddEvent( ZDEF_ONGETDATA , { | oModel | self:OnGetData(oModel) } )

// Acrescenta a��es nomeadas DEFAULT 
// As a��es default possuem nome reservado 

::AddAction("SEARCH","&Pesquisar")
::AddAction("INSERT","&Inserir")
::AddAction("UPDATE","&Alterar")

// Opera��o ainda n�o implementada
// ::AddAction("DELETE","Excluir")

// Acrescenta a��es que podem ser disparadas para este componente
// Nome da a��o, Label, CodeBlock
::AddAction("DADOSB" ,"&Bancos"        , { | oModel | self:DadosBanc(oModel) })
::AddAction("GMAPS"  ,"Google &Maps"   , { | oModel | self:OpenGMap(oModel) })
::AddAction("GMAIL"  ,"&Google Mail"   , { | oModel | self:OpenGMail(oModel) })
::AddAction("OBSERV" ,"&Observa��es"   , { | oModel | self:Observ(oModel) })
::AddAction("FOTO"   ,"&Foto 3x4"      , { | oModel | self:Foto3x4(oModel) })

Return self

// ----------------------------------------------------------

METHOD TableName() CLASS ZAGENDADEF 
Return "AGENDA"

// ----------------------------------------------------------

METHOD GetTitle() CLASS ZAGENDADEF 
Return "Agenda de Contatos"


// ----------------------------------------------------------
// M�todo chamado na inser��o , antes de gravar os dados 
// Se retornar .F. nao permite realizar a inser��o 

METHOD OnInsert(oModel) CLASS ZAGENDADEF
Local cNewID  

::oLogger:Write("OnInsert")

// Cria um novo ID sequencial para gravar este contato 
// Por hora, pega o numero do ultimo registro e soma 1 
// TODO -- Fazer algo mais elegante para multi-thread 
// Como por exemplo usar um sequenciador

cNewID := StrZero(oModel:oObjectTable:LastRec()+1,6)
oModel:FieldPut("ID",cNewID)

Return .T. 

// ----------------------------------------------------------
// M�todo chamado antes da busca, com a tabela aberta 

METHOD OnSearch(oModel) CLASS ZAGENDADEF 

::oLogger:Write("OnSearch")

// J� que a tabela � TOPFILE, coloca uma ordem SQL 
oModel:oObjectTable:SetSQLOrderBy("NOME")

Return .T. 

// ----------------------------------------------------------

METHOD OnGetData(oModel)  CLASS ZAGENDADEF 

::oLogger:Write("OnGetData")

// J� que a tabela � TOPFILE, coloca uma ordem SQL 
// TODO -- Fazer o GetData usar esta ordem 
oModel:oObjectTable:SetSQLOrderBy("NOME")

Return .T. 


// ----------------------------------------------------------
// A��o do componente -- Especifica para interface com SmartClient
// Abre uma URL do Google Maps pesquisando o endere�o 
// usando os dados do contato atual 
// Usando o navegador padr�o da m�quina cliente

METHOD OpenGMap(oModel) CLASS ZAGENDADEF 

Local cEndereco
Local cCidade
Local cUF
Local cCEP
Local cMapsURL := 'https://www.google.com/maps/search/?api=1&query='
Local cUrlQry := ''

::oLogger:Write("OpenGMap")

cEndereco := alltrim(oModel:FieldGet("ENDER"))

If !empty(cEndereco)
	cUrlQry += UrlEscape(cEndereco+',')
Endif
				
cCidade := alltrim(oModel:FieldGet("CIDADE"))
If !empty(cCidade)
	cUrlQry += UrlEscape(cCidade+',')
Endif

cUF := oModel:FieldGet("UF")
If !empty(cUF)
	cUrlQry += UrlEscape(cUF+',')
Endif

cCep := oModel:FieldGet("CEP")
If !empty(cCEP)
	cUrlQry += UrlEscape(cCEP)
Endif
          
If Empty(cUrlQry)
	oModel:SetError("Nao h� dados de endere�o suficientes para a busca no mapa.")
	Return .F. 
Endif

shellExecute("Open", cMapsURL+cUrlQry, "", "", 1 )

Return .T. 

/* -----------------------------------------------------------
Funcao de Escape de caracteres b�sica para informar 
valores de campos via URL 
----------------------------------------------------------- */

STATIC Function UrlEscape(cInfo)
cInfo := strtran(cInfo,'%',"%25")
cInfo := strtran(cInfo,'&',"%26")
cInfo := strtran(cInfo," ","+")
cInfo := strtran(cInfo,'"',"%22")
cInfo := strtran(cInfo,'#',"%23")
cInfo := strtran(cInfo,",","%2C")
cInfo := strtran(cInfo,'<',"%3C")
cInfo := strtran(cInfo,'>',"%3E")
cInfo := strtran(cInfo,"|","%7C")
Return cInfo

// ----------------------------------------------------------
// A��o do componente -- Especifica para interface com SmartClient
// Abre uma URL do Google Mail para enviar um email 
// usando os dados do contato atual 
// Usando o navegador padr�o da m�quina cliente

METHOD OpenGMail(oModel) CLASS ZAGENDADEF 

Local cMailURL := 'https://mail.google.com/mail/?view=cm&fs=1&tf=1&to='
Local cEmail

::oLogger:Write("OpenGMail")

cEMAIL := oModel:FieldGet("EMAIL")

If Empty(cEMAIL)
	oModel:SetError("N�o � poss�vel enviar um e-mail. E-Mail n�o preenchido.")
	Return .F. 
Endif

shellExecute("Open", cMailURL+lower(cEMAIL), "", "", 1 )

Return .T. 


// ----------------------------------------------------------
// A��o do componente -- Especifica para interface com SmartClient
// Abre uma janela de edi��o de texto de comentario 
// O coment�rio � lido e salvo no campo memo "OBSERV"

METHOD Observ(oModel) CLASS ZAGENDADEF 
Local oDlg  
Local oPanelObs, oPanelBtn
Local oGet 
Local oBtnCanc , oBtnOk
Local lSaveObs := .F. 
Local aRecord
Local cObs

::oLogger:Write("Observ")

  
cObs := oModel:FieldGet("OBSERV")

DEFINE DIALOG oDlg TITLE "Observa��es" FROM 0,0 TO 600,800 COLOR VIEW_FR_COLOR,VIEW_BG_COLOR PIXEL
oDlg:lEscClose := .T.

@ 0,0 MSPANEL oPanelObs OF oDlg SIZE 800,20 
oPanelObs:ALIGN := CONTROL_ALIGN_ALLCLIENT

@ 0,0 MSPANEL oPanelBtn OF oDlg SIZE 800,20 COLOR VIEW_FR_COLOR,VIEW_BG_COLOR
oPanelBtn:ALIGN := CONTROL_ALIGN_BOTTOM

@   0,0 GET oGet VAR cObs MULTILINE ;
	SIZE 800 ,600 COLOR VIEW_GETFR_COLOR,VIEW_GETBG_COLOR OF oPanelObs PIXEL

oGet:ALIGN := CONTROL_ALIGN_ALLCLIENT
oGet:L3DLOOK := .T.
                             
@ 2,230  BUTTON oBtnOk PROMPT "Confirmar" SIZE 60,15 ;
	ACTION ( lSaveObs := .T. ,oDlg:End() ) OF oPanelBtn PIXEL
oBtnOk:SetColor(VIEW_BTNFR_COLOR,VIEW_BTNBG_COLOR)

@ 2,330  BUTTON oBtnCanc PROMPT "Voltar" SIZE 60,15 ;
	ACTION ( oDlg:End() ) OF oPanelBtn PIXEL
oBtnCanc:SetColor(VIEW_BTNFR_COLOR,VIEW_BTNBG_COLOR)

ACTIVATE DIALOG oDlg CENTER

If lSaveObs
	::oLogger:Write("Observ","Update Contact Information")
	oModel:FieldPut("OBSERV",cObs)
	aRecord := aClone(oModel:aRecord)
	If !oModel:Update(aRecord)
		MsgStop(oModel:GetErrorStr(),"Observa��es")
	Endif
Endif

Return .T.

// ----------------------------------------------------------
// A��o do componente -- Especifica para interface com SmartClient
// Abre uma janela de visualiza��o da Foto 3x4 da Agenda
// A imagem � lida e salva no campo memo "IMAGE"\
//
// TODO : Permitir inserir, alterar e remover a imagem 
//


METHOD Foto3x4(oModel) CLASS ZAGENDADEF 

Local oDlg  
Local oBmpFoto
Local cImage
Local cId
Local nCRC

::oLogger:Write("Foto3x4")

cId     := oModel:FieldGet("ID")
cImage  := oModel:FieldGet("IMAGE")
nCRC    := MSCRC32(cImage)

DEFINE DIALOG oDlg TITLE "Foto 3x4" FROM 0,0 TO 320,240 PIXEL
oDlg:lEscClose := .T.

@ 00,00 BITMAP oBmpFoto OF oDlg PIXEL 
  
oBmpFoto:nWidth := 240 // 120
oBmpFoto:nHeight := 320 // 160
oBmpFoto:lStretch := .T.
oBmpFoto:SENDBUFFER(cImage, len(cImage), "AGENDA_"+cID , nCRC , .F. )

ACTIVATE DIALOG oDlg CENTER

Return .T.

// ----------------------------------------------------------
//

METHOD DadosBanc(oModel) CLASS ZAGENDADEF 
Local oDBancControl
Local oDBancDef
Local oDBancModel
Local oBancoDef
LOcal oBancoModel
Local oEnv
     
// Pega o enviroment o modelo 
oEnv := oModel:GetZLIBEnv()

// Pega os factories de definicao e modelo do ambiente  
oDefFactory := oEnv:GetObject("ZDEFFACTORY")
oModelFactory := oEnv:GetObject("ZMODELFACTORY")
oViewFactory := oEnv:GetObject("ZVIEWFACTORY")
oCtrlFactory := oEnv:GetObject("ZCONTROLFACTORY")
     
// Cria a defini��o do componente
// Futuramente ser� possivel obter a defini��o do dicion�rio de dados 
// A definicao de dados bancarios vai ser criada para ser executada no 
// conexto da agenda

oDBancDef := oDefFactory:GetNewDef("ZDADOSBANCDEF","AGENDA")
oBancoDef := oDefFactory:GetNewDef("ZBANCODEF")

// Cria o objeto de Modelo da Banco
// Passa a defini��o como par�metro

oDBancModel := oModelFactory:GetNewModel(oDBancDef)

// Na inicializa��o precisa passar o ambiente 
If !oDBancModel:Init( oEnv )
	MsgStop( oDBancModel:GetErrorStr() , "Failed to Init Model DADOSBANC" )
	Return
Endif

oBancoModel := oModelFactory:GetNewModel(oBancoDef)

If !oBancoModel:Init( oEnv )
	MsgStop( oBancoModel:GetErrorStr() , "Failed to Init Model BANCO" )
	Return
Endif

// TODO 
// Aqui precisa aconteccer uma m�gica 
// A defini��o original dos dados bancarios 
// � uma tabela que relaciona um contato da agenda a uma ou mais 
// contas bancarias, de modo que o contato da agenda � um campo 
// de LookUp. Porem, como eu estou acessando os dados bancarios a 
// partir de um dos contatos, o campo do codigo do agendado 
// deve estar preenchido com o codigo atual, e escondido, para as funcionalidades
// de busca, insercao e alteracao funcionem. Como a view � montada sobre a defini��o, 
// ou eu poderia alterar a definicao antes de chamar este componente -- o que nao 
// seria nem elegante nem seguro -- oueu crio um definition factory, onde o proprio 
// componente poderia retornar uma defini��o adequada para uso com este componente 
// Isto tambem poderia ser um parametro adicional no construtor do componente
  
// Recupera a defini��o do campo de contato da agenda dos dados 
// bancarios e seta o valor default para o contato atual 
oFldId := oDBancDef:GetFieldDef("IDAGENDA")
oFldId:SetDefault( oModel:FieldGet("ID") )

// TODO 
// Estudar uma forma de criar um browse nativo com os campos e dados da tabela 
// dentro da view padrao, como uma opcao da propria view 
 

// Cria a View de Dados Bancarios 
oDBancView := oViewFactory:GetNewView(oDBancDef)

// Cria o controler dos dados bancarios 
// e coloca nele os modelos necessarios para uso 

// TODO
// O modelo de dados bancarios usa o modelo da agenda como lookup 
// e tamnem usa o modelo de BANCOS, que 

oDBancControl := oCtrlFactory:GetNewControl(oDBancView)
oDBancControl:AddModel(oDBancModel)           // Acrescenta o modelo de dados bancarios 
oDBancControl:AddModel(oModel)                // Acrescenta tambem o modelo da agenda
oDBancControl:AddModel(oBancoModel)           // Acrescenta o modelo de dados bancarios 

// Roda a view de dados bancarios 
oDBancView:Run()

// Encerra todos os contextos utilizados 
// -- Ordem inversa de cria��o -- 

// Encerra o control
oDBancControl:Done()
FreeObj(oDBancControl)

// Encerra o modelo 
oDBancModel:Done()
FreeObj(oDBancModel)

// Encerra o modelo 
oBancoModel:Done()
FreeObj(oBancoModel)

// Encerra a View
oDBancView:Done()
FreeObj(oDBancView)

// Encerra a defini��o 
oDBancDef:Done()
FreeObj(oDBancDef)

oBancoDef:Done()
FreeObj(oBancoDef)

Return

