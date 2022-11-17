page 50100 LabelMappingPageList
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = LabelMappingTable;

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
                field("Table Name"; rec."Table Name")
                {
                    ApplicationArea = All;

                }
                field("Field Name"; rec."Field Name")
                {
                    ApplicationArea = All;

                }

                field("Label Field No."; rec."Label Field No.")
                {
                    ApplicationArea = All;

                }
                field("Related to Line No."; rec."Related to Line No.")
                {
                    ApplicationArea = All;
                }
                field("Relation Filter"; rec."Relation Filter")
                {
                    ApplicationArea = All;
                }
                field("Relation Based on Field No."; rec."Relation Based on Field No.")
                {
                    ApplicationArea = All;
                }
                field("Label No."; rec."Label No.")
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
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}