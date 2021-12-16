codeunit 70102 "CodeUnitHelper"
{
    trigger OnRun()
    begin

    end;

    procedure AddPermissionSetToUser(UserSecurityID: Guid; RoleID: Code[100]; Company: Text[30])


    var

        AccessControl: Record "Access Control";

    begin

        AccessControl.SetRange("User Security ID", UserSecurityID);

        AccessControl.SetRange("Role ID", RoleID);

        AccessControl.SetRange("Company Name", Company);



        if not AccessControl.IsEmpty() then
            exit;



        AccessControl.Init();

        AccessControl."User Security ID" := UserSecurityID;

        AccessControl."Role ID" := RoleID;

        AccessControl."Company Name" := Company;

        AccessControl.Insert(true);

    end;

    procedure SetPLurePermissionSets()

    begin

        AddPermissionSetToUser(UserSecurityId(), 'Permission', '');

    end;
}