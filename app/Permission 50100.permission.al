permissionset 70148 Permission
{
    Assignable = true;
    IncludedPermissionSets = "D365 BASIC";
    Permissions =
        tabledata "Reward Level" = RIMD,//Leer insetar modificar deletear
        tabledata "Customer Rewards Mgt. Setup" = RIMD,
        tabledata "Activation Code Information" = RIMD,
        table "Reward Level" = X,//X ejecucion
        table "Customer Rewards Mgt. Setup" = X,
        table "Activation Code Information" = X,
        page "Customer Rewards Wizard" = X,
        page "Rewards Level List" = X,
        codeunit "Customer Rewards Install Logic" = X,
        codeunit "Customer Rewards Ext. Mgt." = X;


}