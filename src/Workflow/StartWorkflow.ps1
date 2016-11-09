
Param(
    # Site Url
    [Parameter(Mandatory=$true)]
    [string]$sourceWebURL,

    # List Title
    [Parameter(Mandatory=$true)]
    [string]$sourceListName,

    [Parameter(Mandatory=$true)]
    [string]$TargetWorkflow

)

$spSourceWeb = Get-SPWeb $sourceWebURL
$spSourceList = $spSourceWeb.Lists[$sourceListName]
 
#-- Getting a Workflow manager object to work with.
$wfm = New-object Microsoft.SharePoint.WorkflowServices.WorkflowServicesManager($spSourceweb)
#-- Getting the subscriptions
$sub = $wfm.GetWorkflowSubscriptionService()
#-- Getting the specific workflow within the list of subscriptions on the specific list. (SP2010 associated workflows basically)
$WF = $sub.EnumerateSubscriptionsByList($spSourcelist.ID) | Where-Object {$_.Name -eq "$TargetWorkflow"}
#-- Getting a Workflow instance in order to perform my commands.
$wfis=$wfm.GetWorkflowInstanceService()

Foreach($item in $spSourceList.Items){
    $countStart++;
    #-- Creating the dictionary object I need to parse into StartWorkflow. This could be most other workflow commands.
    $object = New-Object 'system.collections.generic.dictionary[string,object]'
    #--$object.Add("WorkflowStart", "StartWorkflow");
    $wfRun = $wfis.StartWorkflowOnListItem($WF, $item.ID, $object)
}


#-- source: http://social.technet.microsoft.com/wiki/contents/articles/23850.sharepoint-2013-workflow-management-starting-a-workflow-using-powershell.aspx