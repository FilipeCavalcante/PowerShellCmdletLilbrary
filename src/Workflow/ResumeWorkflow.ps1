Param(
    # Url of Site
    [Parameter(Mandatory=$true, Position=1)]
    [string]$SiteUrl,

    # Lists Title that contains Workflow
    [Parameter(Mandatory=$true, Position=2)]
    [string]$ListTitle,

    # ID of Item
    [Parameter(Mandatory=$true, Position=3)]
    [int]$ItemId,

    # Workflow Name
    [Parameter(Mandatory=$true, Position=4)]
    [string]$WorkflowInstanceName
)
try{
    $site = Get-SPSite $SiteUrl
    $web = $site.OpenWeb()
    $list = $web.Lists[$ListTitle]
    $item = $list.GetItemById($ItemId)
    [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.WorkflowServicesBase")
    $wf_mgr = New-Object -TypeName Microsoft.SharePoint.WorkflowServices.WorkflowServicesManager -ArgumentList $web
    $wf_srv= $wf_mgr.GetWorkflowInstanceService()
    $wfs = $wf_srv.EnumerateInstancesForListItem($list.ID, $item.ID) | Where-Object { $_.Name -eq "$WorkflowInstanceName"}
    $wf_srv.ResumeWorkflow($wfs)
}
catch{
    Write-Error -Exception $_.Exception.Message
}
