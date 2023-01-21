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
User Function ZHELPDESK()
Local oBrowse := FWLoadBrw("ZHELPDESK") //Indicates from which source code the BrowseDef is being pulled

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
Local oBrowse := FwMBrowse():New()

oBrowse:SetAlias("SZ2")
oBrowse:SetDescription("Cadastro de Chamados")

oBrowse:AddLegend("SZ2->Z2_STATUS == '1'","GREEN","Chamado Aberto")
oBrowse:AddLegend("SZ2->Z2_STATUS == '2'","RED","Chamado Finalizado")
oBrowse:AddLegend("SZ2->Z2_STATUS == '3'","YELLOW","Chamado em Andamento")


oBrowse:SetMenudef("ZHELPDESK")//Defines which source code the menu will come from

RestArea(aArea)

return oBrowse


/*/{Protheus.doc} MenuDef
Function that structure the Menu of the Routine
@type function
@version 1.0  
@author Josue Oliveira
@since 14/01/2023
/*/
Static Function MenuDef()
Local aMenu    := {}
Local n

Local aMenuAut := FwMVCMenu("ZHELPDESK")

ADD OPTION aMenu TITLE 'Legenda' ACTION 'u_SZ2LEGEND' OPERATION 6 ACCESS 0
ADD OPTION aMenu TITLE 'Sobre'   ACTION 'u_SZ2ABOUT'  OPERATION 6 ACCESS 0


For n:= 1 to Len(aMenuAut)
    aAdd(aMenu,aMenuAut[n])
Next n

return aMenu


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
Local oModel := MPFormModel():New("MVCZ2Z3M",/*bPre*/,  /*bPos*/,  /*bCommit*/,/*bCancel*/)
//Creates the structure of Parent table and Child table
Local oParentZ2 := FwFormStruct(1, "SZ2")
Local oChildZ3  := FwFormStruct(1, "SZ3")

oChildZ3:SetProperty("Z3_CHAMADO",MODEL_FIELD_INIT,FwBuildFeature(STRUCT_FEATURE_INIPAD,"SZ2->Z2_COD"))

aTrigUser := FwStruTrigger(;
"Z2_USUARIO",;
"Z2_USERNAM",;
"USRRETNAME(M->Z2_USUARIO)",;
.F.)


oParentZ2:AddTrigger(;
aTrigUser[1],;
aTrigUser[2],;
aTrigUser[3],;
aTrigUser[4])


//Creates the data model as header and itens
oModel:AddFields("SZ2MASTER",,oParentZ2) //header
oModel:AddGrid("SZ3DETAIL","SZ2MASTER",oChildZ3,,,,,)//itens

oModel:SetVldActivate({|oModel|VALIDATEUSR(oModel)})

//defines the relation between the parent-child tables
oModel:SetRelation("SZ3DETAIL",{{"Z3_FILIAL","xFilial('SZ2')"},{"Z3_CHAMADO","Z2_COD"}},SZ3->(Indexkey(1)))

oModel:SetPrimaryKey({"Z3_FILIAL","Z3_CHAMADO","Z3_CODIGO"})
oModel:GetModel("SZ3DETAIL"):SetUniqueLine({"Z3_CHAMADO","Z3_CODIGO"})

oModel:SetDescription("Sistema de chamados")
oModel:GetModel("SZ2MASTER"):SetDescription("CABECALHO DO CHAMADO")
oModel:GetModel("SZ3DETAIL"):SetDescription("COMENTARIOS DO CHAMADO")

return oModel


Static Function ViewDef()
Local oView := NIL

//Model of the function
Local oModel:= FwloadModel("ZHELPDESK")

Local oParentZ2 := FWFormStruct(2,"SZ2")
Local oChildZ3  := FWFormStruct(2,"SZ3")

oChildZ3:RemoveField("Z3_CHAMADO")

oChildZ3:SetProperty("Z3_CODIGO", MVC_VIEW_CANCHANGE, .F.)

oParentZ2:SetProperty("Z2_USUARIO", MVC_VIEW_LOOKUP, "USR")

oView := FwFormView():New()
oView:SetModel(oModel)

oView:AddField("VIEWSZ2",oParentZ2,"SZ2MASTER")
oView:AddGrid("VIEWSZ3",oChildZ3,"SZ3DETAIL")


oView:AddIncrementField("SZ3DETAIL","Z3_CODIGO")


oView:CreateHorizontalBox("CABEC",60)
oView:CreateHorizontalBox("GRID",40)

oView:SetOwnerView("VIEWSZ2","CABEC")
oView:SetOwnerView("VIEWSZ3","GRID")

oView:EnableTitleView("VIEWSZ2","Detalhes do Chamado")
oView:EnableTitleView("VIEWSZ3","Comentários do chamado")

return oView


/*/{Protheus.doc} SZ2LEGEND
Function that return the status legend of the ticket 
@type function
@version  1.0
@author Josue Oliveira
@since 14/01/2023
/*/
User Function SZ2LEGEND()
Local aLegend := {}

aAdd(aLegend,{"BR_VERDE",  "Chamado Aberto"})
aAdd(aLegend,{"BR_AMARELO","Chamado em Andamento"})
aAdd(aLegend,{"BR_VERMELHO",  "Chamado Finalizado"})

BrwLegenda("Status dos chamados",,aLegend)

return aLegend


/*/{Protheus.doc} SZ2ABOUT
Function that return about de routine
@type function
@version  1.0
@author Josue Oliveira
@since 14/01/2023
/*/
User Function SZ2ABOUT()
Local cAbout

cAbout := "-<b>Uma rotina utilizada para abrir tickets de suporte"

MsgInfo(cAbout,"Sobre esta rotina")

return cAbout

/*/{Protheus.doc} MActivVld
Function that validate if the user have permission to 
edit o user code who included the ticket. The validation 
is made trough the MV_XUSMVC parameter.
@type function
@version  1.0
@author Josue Oliveira
@since 18/01/2023
@see https://terminaldeinformacao.com/knowledgebase/supergetmv/
@see https://tecnologia.bynem.com.br/advpl-help/#:~:text=Esta%20fun%C3%A7%C3%A3o%20exibe%20a%20ajuda,texto%20em%20tempo%20de%20execu%C3%A7%C3%A3o.
@see https://centraldeatendimento.totvs.com/hc/pt-br/articles/360040694374-Cross-Segmento-TOTVS-Backoffice-Linha-Protheus-ADVPL-Bloquear-campos-por-ponto-MVC
/*/
Static function VALIDATEUSR(oModel)
Local lRet := .T.

Local cUserMVC := SUPERGETMV("MV_XUSMVC")
Local cCodUsers := RetCodUsr()

IF (cCodUsers$cUserMVC)
    oModel:GetModel("SZ2MASTER"):GetStruct():SetProperty("Z2_DATA",    MODEL_FIELD_WHEN, FwBuildFeature(STRUCT_FEATURE_WHEN,".T."))
    oModel:GetModel("SZ2MASTER"):GetStruct():SetProperty("Z2_USUARIO", MODEL_FIELD_WHEN, FwBuildFeature(STRUCT_FEATURE_WHEN,".T."))
ELSE
    oModel:GetModel("SZ2MASTER"):GetStruct():SetProperty("Z2_DATA",    MODEL_FIELD_WHEN, FwBuildFeature(STRUCT_FEATURE_WHEN,".F."))
    oModel:GetModel("SZ2MASTER"):GetStruct():SetProperty("Z2_USUARIO", MODEL_FIELD_WHEN, FwBuildFeature(STRUCT_FEATURE_WHEN,".F."))
ENDIF

Return lRet
