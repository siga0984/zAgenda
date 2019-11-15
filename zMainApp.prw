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

USER Function ZMainApp()
Local oSmartApp 
Local aMenus := {}
Local aProgs := {}
Local aAjuda := {}

oSmartApp := ZSMARTAPP():New("Agenda - Sistema de Controle")

aadd(aProgs,{"&Contatos da Agenda"    ,{ || oSmartApp:CallZApp("U_ZAGENDA") }} )
aadd(aProgs,{"Controle de Des&pesas"  ,{ || oSmartApp:CallZApp("U_ZDESPESAS") }} )
aadd(aProgs,{"&Dados Banc�rios"       ,{ || oSmartApp:CallZApp("U_ZDADOSBANC") }} )
aadd(aProgs,{"-" , NIL } )
aadd(aProgs,{"Cadastro de &Pa�ses"    ,{ || oSmartApp:CallZApp("U_ZPAIS")   }} )
aadd(aProgs,{"Cadastro de &Estados"   ,{ || oSmartApp:CallZApp("U_ZESTADO") }} )
aadd(aProgs,{"Cadastro de &Bancos"    ,{ || oSmartApp:CallZApp("U_ZBANCO") }} )
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

