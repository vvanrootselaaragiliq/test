page 50101 LabelWebServiceSetup
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = LabelWebserviceSetupTable;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("No."; rec."No.")
                {
                    ApplicationArea = All;

                }
                field("Url"; rec."Url")
                {
                    ApplicationArea = All;

                }
                field("Name"; rec."Name")
                {
                    ApplicationArea = All;

                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {

        area(Processing)
        {



            action(TestWebservice)
            {

                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                trigger OnAction();
                var
                    WebServiceConnector: Codeunit BartenderWebserviceConnector;
                    Labeltext: text[250];
                    recRef: RecordRef;
                    SalesLine: Record "Sales Line";
                begin
                    SalesLine.Get(SalesLine."Document Type"::Order, '101001', 10000);
                    recRef.GetTable(SalesLine);
                    labeltext := WebServiceConnector.GetMappedFieldsLabelBody(recRef, 1, Labeltext, false);

                    WebServiceConnector.Print(Labeltext);
                end;
            }
            action(LabelMappingPage)
            {

                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                trigger OnAction();
                var
                    LabelMappingPageList: Page LabelMappingPageList;
                begin
                    LabelMappingPageList.Run();
                end;
            }
        }
    }
}
