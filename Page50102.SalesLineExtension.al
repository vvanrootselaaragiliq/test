pageextension 50102 SalesLineExtensions extends "Sales Order Subform"

{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addfirst("&Line")
        {
            action("Print Labels")
            {
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                trigger OnAction();
                var
                    WebServiceConnector: Codeunit BartenderWebserviceConnector;
                    Labeltext: text[250];
                    recRef: RecordRef;


                begin
                    recRef.GetTable(Rec);
                    labeltext := WebServiceConnector.GetMappedFieldsLabelBody(recRef, 1, Labeltext, false);

                    WebServiceConnector.Print(Labeltext);
                end;
            }
        }
    }
    var
        myInt: Integer;
}
