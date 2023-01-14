#INCLUDE 'Protheus.ch'
#INCLUDE 'FwMvcDef.ch'


/*/{Protheus.doc} ZHELPDESK
Function that creates a helpdesk routine using MVC model 3.
@type function
@version  1.0
@author Josue Oliveira
@since 07/01/2023
@see https://medium.com/totvsdevelopers/protheus-mvc-72901b7efc8a
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


/*/{Protheus.doc} ModelDef
Function responsible for creating the data structure and returning it
@type function
@version 1.0
@author Josue Oliveira
@since 08/01/2023
@see https://tdn.totvs.com/display/public/framework/FWFormStruct
@see https://tdn.totvs.com/display/public/framework/FWFormView
/*/
Static Function ModelDef()

//Defines the data model
Local oModel := MPFormModel():New("ZHELPDESKM",,,,)

//Creates the structure of Parent table and Child table
Local oParentZ2 := FwFormtStruct(1, "SZ2")
Local oChildZ3  := FwFormtStruct(1, "SZ3")

//Creates the data model as header and itens
oModel:AddFields("SZ2MASTER",,oParentZ2) //header
oModel:AddGrid("SZ3DETAIL","SZ2MASTER",oChildZ3,,,,,)//itens

//defines the relation between the parent-child tables
oModel:SetRelation("SZ3DETAIL",{{"Z3_FILIAL","xFilial('SZ1')"}},{{"Z3_CHAMADO","Z2_COD"}},SZ3->(Indicekey(1)))

oModel:SetPrimaryKey({"Z3_FILIAL","Z3_CHAMADO","Z3_CODIGO"})
oModel:GetModel("SZ3DETAIL"):SetUniqueLine({"Z3_CHAMADO","Z3_CODIGO"})

oModel:SetDescription("Sistema de chamados")
oModel:GetModel("SZ2MASTER"):SetDescption("CABECALHO DO CHAMADO")
oModel:GetModel("SZ3DETAIL"):SetDescption("COMENTARIOS DO CHAMADO")

return oModel


Static Function ViewDef()
Local oView := NIL

//Model of the function
Local oModel:= FwloadModel("ZHELPDESK")

Local oParentZ2 := FWFormStruct(2,"SZ2")
Local oChildZ3  := FWFormStruct(2,"SZ3")

oView :=FWFormView():New()
oView:SetModel(oModel)

oView:AddField("VIEWSZ2",oParentZ2,"SZ2MASTER")
oView:AddGrid("VIEWSZ3",oChildZ3,"SZ3DETAIL")

oView:CreateHorizontalBox("HEAD",60)
oView:CreateHorizontalBox("GRID",40)

oView:SetOwnerView("VIEWSZ2","HEAD")
oView:SetOwnerView("VIEWSZ3","GRID")

oView:EnableTitleView("VIEWSZ2","Detalhes do Chamado")
oView:EnableTitleView("VIEWSZ3","Comentários do chamado")

return oView
