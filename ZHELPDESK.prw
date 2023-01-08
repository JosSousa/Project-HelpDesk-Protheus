#INCLUDE 'Protheus.ch'
#INCLUDE 'FwMvcDef.ch'


/*/{Protheus.doc} ZHELPDESK
Function that creates a helpdesk routine using MVC model 3.
@type function
@version  1.0
@author Josue Oliveira
@since 07/01/2023
@see https://tdn.totvs.com/display/public/framework/FWLoadBrw
/*/
User Function ZHELPDESK
Local oBrowse := FwLoadBr("ZHELPDESK") //Indicates from which source code the BrowseDef is being pulled

oBrowse:Activate() 

return

/*/{Protheus.doc} BrowseDef
Function responsible for creating the Browser and returning it
@type function
@version 1.0 
@author Josue Oliveira
@since 08/01/2023
@see https://centraldeatendimento.totvs.com/hc/pt-br/articles/360016740431-MP-ADVPL-Estrutura-MVC-Pai-Filho-Neto
@see https://tdn.totvs.com/pages/releaseview.action?pageId=24346925
@see https://tdn.totvs.com/display/public/framework/FwBrowse
@see https://tdn.totvs.com/pages/releaseview.action?pageId=24347058
/*/
Static Function BrowseDef()
Local aArea := GetArea()
Local oBrowse := FwmBrowse():New()

oBrowse:SetAlias("SZ2")
oBrowse:SetDescription("Cadastro de Chamados")

oBrowse:AddLegend("SZ2->Z2_STATUS == '1'","GREEN","Chamado Aberto")
oBrowse:AddLegend("SZ2->Z2_STATUS == '2'","RED","Chamado Finalizado")
oBrowse:AddLegend("SZ2->Z2_STATUS == '3'","YELLOW","Chamado em Andamento")


oBrowse:SetMenudef("ZHELPDESK")//Defines which source code the menu will come from

RestArea(aArea)

return oBrowse
