page 70100 "Customer Rewards Wizard"// asistente de las recompensas del cliente
{
    // Specifies that this page will be a navigate page. 
    PageType = NavigatePage; //Dialogo de varios pasos.
    Caption = 'Customer Rewards assisted setup guide';
    ContextSensitiveHelpPage = 'sales-rewards'; /*Especifica el tema de ayuda que se mostrará cuando el usuario 
    presione Ayuda en la interfaz de usuario. El servidor de ayuda en el que se encuentra este tema de ayuda 
    debe definirse en el archivo app.json.*/
    UsageCategory = Administration;
    ApplicationArea = All; //esta propiedad no funciona si no se establece un UsageCategory...

    layout
    {
        area(content)
        {
            group(MediaStandard)
            {
                Caption = '';
                Editable = false;
                Visible = TopBannerVisible;

                field("MediaResourcesStandard.""Media Reference"""; MediaResourcesStandard."Media Reference")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = false;
                }
            }

            group(FirstPage)
            {
                Caption = '';
                Visible = FirstPageVisible;

                group("Welcome")
                {
                    Caption = 'Welcome';
                    Visible = FirstPageVisible;

                    group(Introduction)
                    {
                        Caption = '';
                        InstructionalText = 'This Customer Rewards extension is a sample extension. It adds rewards tiers support for Customers.';
                        Visible = FirstPageVisible;

                        field(Spacer1; '')//es como una barra gris espaciadora
                        {
                            ApplicationArea = All;
                            ShowCaption = false;
                            Editable = false;
                            MultiLine = true;
                        }
                    }

                    group("Terms")
                    {
                        Caption = 'Terms of Use';
                        Visible = FirstPageVisible;

                        group(Terms1)
                        {
                            Caption = '';
                            InstructionalText = 'By enabling the Customer Rewards extension...';
                            Visible = FirstPageVisible;
                        }
                    }

                    group(Terms2)
                    {
                        Caption = '';

                        field(EnableFeature; EnableCustomerRewards)
                        {
                            ApplicationArea = All;
                            MultiLine = true;
                            Editable = true;
                            Caption = 'I understand and accept these terms.';

                            trigger OnValidate();
                            begin
                                ShowFirstPage;
                            end;
                        }
                    }
                }
            }

            group(FirstHalfPage)
            {
                Caption = '';
                Visible = FirstHalfPageVisible;

                group("Welcome User")
                {
                    Caption = 'Welcome';
                    Visible = FirstHalfPageVisible;

                    group(Message)
                    {
                        Caption = '';
                        InstructionalText = 'Please enter your user name or email address.';
                        Visible = FirstHalfPageVisible;

                        field(SpacerExtra; '')//es como una barra gris espaciadora
                        {
                            ApplicationArea = All;
                            ShowCaption = false;
                            Editable = false;
                            MultiLine = false;
                        }
                    }

                    group(entries)
                    {
                        Caption = '';

                        field(UserName; UserName)
                        {
                            ApplicationArea = All;
                            MultiLine = false;
                            Editable = true;
                            Caption = 'User Name: ';
                            ToolTip = 'Nombre de usuario, debe contener almenos 3 caracteres';

                            trigger OnValidate();
                            var
                                CustomerRewardWizard: Page "Customer Rewards Wizard";
                                tempUser: Text;

                            begin
                                tempUser := "UserName";
                                if Text.StrLen(tempUser) < 3 then begin
                                    Error('Un nombre de usuario no puede contener menos de 3 caracateres');
                                end;

                            end;
                        }
                    }
                }
            }

            group(SecondPage)
            {
                Caption = '';
                Visible = SecondPageVisible;

                group("Activation")
                {
                    Caption = 'Activation';
                    Visible = SecondPageVisible;

                    field(Spacer2; '')
                    {
                        ApplicationArea = All;
                        ShowCaption = false;
                        Editable = false;
                        MultiLine = true;
                    }

                    group(ActivationMessage)
                    {
                        Caption = '';
                        InstructionalText = 'Enter your 14 digit activation code to continue';
                        Visible = SecondPageVisible;

                        field(Activationcode; ActivationCode)
                        {
                            ApplicationArea = All;
                            ShowCaption = false;
                            Editable = true;
                        }
                    }
                }
            }

            group(FinalPage)
            {
                Caption = '';
                Visible = FinalPageVisible;

                group("ActivationDone")
                {
                    Caption = 'You''re done!';
                    Visible = FinalPageVisible;

                    group(DoneMessage)
                    {
                        Caption = '';
                        InstructionalText = 'Click Finish to setup your rewards level and start using Customer Rewards.';
                        Visible = FinalPageVisible;
                    }
                    group(User)
                    {
                        field(SpacerExt2; Format(UserName))//es como una barra gris espaciadora
                        {
                            ApplicationArea = All;
                            ShowCaption = false;
                            Editable = false;
                            MultiLine = false;
                        }

                    }
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionBack)
            {
                ApplicationArea = All;
                Caption = 'Back';
                Enabled = BackEnabled;
                Visible = BackEnabled;
                Image = PreviousRecord;
                InFooterBar = true;

                trigger OnAction();
                begin
                    NextStep(true);
                end;
            }

            action(ActionNext)
            {
                ApplicationArea = All;
                Caption = 'Next';
                Enabled = NextEnabled;
                Visible = NextEnabled;
                Image = NextRecord;
                InFooterBar = true;

                trigger OnAction();
                begin
                    NextStep(false);
                end;
            }

            action(ActionActivate)
            {
                ApplicationArea = All;
                Caption = 'Activate';
                Enabled = ActivateEnabled;
                Visible = ActivateEnabled;
                Image = NextRecord;
                InFooterBar = true;

                trigger OnAction();
                var
                    CustomerRewardsExtMgt: Codeunit "Customer Rewards Ext. Mgt.";
                    CodeunitHelper: Codeunit "CodeUnitHelper";
                begin
                    CodeunitHelper.SetCustomerRewardsPermissionSets();
                    if ActivationCode = '' then
                        Error('Activation code cannot be blank.');

                    if Text.StrLen(ActivationCode) <> 14 then
                        Error('Activation code must have 14 digits.');

                    if CustomerRewardsExtMgt.ActivateCustomerRewards(ActivationCode) then
                        NextStep(false)
                    else
                        Error('Activation failed. Please check the activtion code you entered.');
                end;
            }

            action(ActionFinish)
            {
                ApplicationArea = All;
                Caption = 'Finish';
                Enabled = FinalPageVisible;
                Image = Approve;
                InFooterBar = true;

                trigger OnAction();
                begin
                    FinishAndEnableCustomerRewards
                end;
            }
        }
    }

    trigger OnInit();
    begin
        LoadTopBanners;
    end;

    trigger OnOpenPage();
    begin
        Step := Step::First;
        EnableControls;
    end;

    local procedure EnableControls();
    begin
        ResetControls;

        case Step of
            Step::First:
                ShowFirstPage;

            Step::FirstHalf:
                ShowFirstHalfPage;

            Step::Second:
                ShowSecondPage;

            Step::Finish:
                ShowFinalPage;
        end;
    end;

    local procedure NextStep(Backwards: Boolean);
    begin
        if Backwards then
            Step := Step - 1
        ELSE
            Step := Step + 1;
        EnableControls;
    end;

    local procedure FinishAndEnableCustomerRewards();
    var
        CustomerRewardsExtMgt: Codeunit "Customer Rewards Ext. Mgt.";
    begin
        CurrPage.Close;
        CustomerRewardsExtMgt.OpenRewardsLevelPage;
    end;

    local procedure ShowFirstPage();
    begin
        FirstPageVisible := true;
        FirstHalfPageVisible := false;
        SecondPageVisible := false;
        FinishEnabled := false;
        BackEnabled := false;
        ActivateEnabled := false;
        NextEnabled := EnableCustomerRewards;
    end;

    local procedure ShowFirstHalfPage();
    begin
        FirstPageVisible := false;
        FirstHalfPageVisible := true;
        SecondPageVisible := false;
        FinishEnabled := false;
        BackEnabled := true;
        ActivateEnabled := false;
        NextEnabled := EnableCustomerRewards;
    end;

    local procedure ShowSecondPage();
    begin
        FirstPageVisible := false;
        FirstHalfPageVisible := false;
        SecondPageVisible := true;
        FinishEnabled := false;
        BackEnabled := true;
        NextEnabled := false;
        ActivateEnabled := true;
    end;

    local procedure ShowFinalPage();
    begin
        FinalPageVisible := true;
        BackEnabled := true;
        NextEnabled := false;
        ActivateEnabled := false;
    end;

    local procedure ResetControls();
    begin
        FinishEnabled := true;
        BackEnabled := true;
        NextEnabled := true;
        ActivateEnabled := true;
        FirstPageVisible := false;
        FirstHalfPageVisible := false;
        SecondPageVisible := false;
        FinalPageVisible := false;
    end;

    local procedure LoadTopBanners();
    begin
        if MediaRepositoryStandard.GET('AssistedSetup-NoText-400px.png', FORMAT(CURRENTCLIENTTYPE))
      then
            if MediaResourcesStandard.GET(MediaRepositoryStandard."Media Resources Ref")
        then
                TopBannerVisible := MediaResourcesStandard."Media Reference".HASVALUE;
    end;

    var
        MediaRepositoryStandard: Record 9400;
        MediaResourcesStandard: Record 2000000182;
        Step: Option First,FirstHalf,Second,Finish;///FirstHalf
        ActivationCode: Text;

        UserName: Text;

        TopBannerVisible: Boolean;
        FirstPageVisible: Boolean;
        FirstHalfPageVisible: Boolean;
        SecondPageVisible: Boolean;
        FinalPageVisible: Boolean;
        FinishEnabled: Boolean;
        BackEnabled: Boolean;
        NextEnabled: Boolean;
        ActivateEnabled: Boolean;
        EnableCustomerRewards: Boolean;
}