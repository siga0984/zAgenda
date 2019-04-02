#include 'protheus.ch'
#include 'zlib.ch' 

USER Function ZMainApp()
Local oSmartApp 
Local aMenus := {}
Local aProgs := {}
Local aAjuda := {}

oSmartApp := ZSMARTAPP():New("Agenda - Sistema de Controle")

aadd(aProgs,{"&Contatos da Agenda"   ,{ || oSmartApp:CallZApp("U_ZAGENDA") }} )
aadd(aProgs,{"&Dados Bancários"      ,{ || oSmartApp:CallZApp("U_ZDADOSBANC") }} )
aadd(aProgs,{"Cadastro de &Países"   ,{ || oSmartApp:CallZApp("U_ZPAIS")   }} )
aadd(aProgs,{"Cadastro de &Estados"  ,{ || oSmartApp:CallZApp("U_ZESTADO") }} )
aadd(aProgs,{"Cadastro de &Bancos"   ,{ || oSmartApp:CallZApp("U_ZBANCO") }} )
aadd(aProgs,{"-" , NIL } )
aadd(aProgs,{"Sai&r"     ,{ || oSmartApp:Close() }} )

aadd(aMenus , {"&Programas" , aProgs } )

aadd(aAjuda,{"&Sobre"   ,{ || MsgInfo("<html><b>ZLIB Main App</b><br>Aplicativo em Desenvolvimento","*** ZLIB ***") }} )
aadd(aMenus , {"&Ajuda" , aAjuda } )

oSmartApp:SetMenu(aMenus)
oSmartApp:Run()   

oSmartApp:Done()

FreeObj(oSmartApp)

Return



