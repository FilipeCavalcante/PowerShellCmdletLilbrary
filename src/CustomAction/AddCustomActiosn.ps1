    Param(
    [Parameter(Mandatory=$true)]
    [string]$ListTitle,

    [Parameter(Mandatory=$true)]
    [string]$SiteUrl

)


$fornecedorNewFormCUIExtend = "<CommandUIExtension><CommandUIDefinitions><CommandUIDefinition Location='Ribbon.ListForm.Edit.Commit.Controls._children'><Button Id='Fornecedores.NewForm.Submeter.FEAC3929-0B6D-4B71-A98D-686459F578DB' Alt='Submeter' Sequence='1' TemplateAlias='o1' Description='Submete o formulário para aprovação' LabelText='Submeter' Image32by32='/SiteAssets/PortalProcurement/Images/Icons/submit.png' Command='FornecedoresSubmeter'/> </CommandUIDefinition></CommandUIDefinitions><CommandUIHandlers><CommandUIHandler Command='FornecedoresSubmeter' CommandAction='javascript:CustomActions.Fornecedor.Submeter.NewForm.action()' EnabledScript='CustomActions.Fornecedor.Submeter.NewForm.enable()'></CommandUIHandler></CommandUIHandlers></CommandUIExtension>"
$fornecedorEditFormCUIExted = "<CommandUIExtension><CommandUIDefinitions><CommandUIDefinition Location='Ribbon.ListForm.Edit.Commit.Controls._children'><Button Id='Fornecedores.EditForm.Submeter.0EB305CC-258C-4607-918B-516C0F537019' Alt='Submeter' Sequence='1' TemplateAlias='o1' Description='Submete o formulário para aprovação' LabelText='Submeter' Image32by32='/SiteAssets/PortalProcurement/Images/Icons/submit.png' Command='FornecedoresSubmeter'/> </CommandUIDefinition> </CommandUIDefinitions> <CommandUIHandlers><CommandUIHandler Command='FornecedoresSubmeter' CommandAction='javascript:CustomActions.Fornecedor.Submeter.EditForm.action()' EnabledScript='CustomActions.Fornecedor.Submeter.EditForm.enable()'></CommandUIHandler></CommandUIHandlers></CommandUIExtension>"


function AddCustomActions($location, $title, $cuiextension) {

    $newUC = $list.UserCustomActions.Add()
    $newUC.Location = $location
    $newUC.Title = $title
    $newUC.CommandUIExtension = $cuiextension
    $newUC.Update();
}


try{
    if ((Get-PSSnapin Microsoft.SharePoint.Powershell -ErrorAction SilentlyContinue) -eq $null){
        Add-PSSnapin Microsoft.SharePoint.Powershell
    }


    $web = Get-SPWeb $SiteUrl
    $list = $web.Lists | ? Title -eq $ListTitle
    if ($list -eq $null) { throw "Lista nao encontrada" }

    #adiciona 
    AddCustomActions -location "CommandUI.Ribbon.NewForm" -title "FornecedorComprasSubmeter" -cuiextension $fornecedorNewFormCUIExtend
    AddCustomActions -location "CommandUI.Ribbon.EditForm" -title "FornecedorComprasSubmeter" -cuiextension $fornecedorEditFormCUIExted

}
catch{
    Write-Error -Exception $_.Exception.Message
}