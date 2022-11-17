table 50100 LabelMappingTable
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Label No."; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(10; "Table No."; Integer)
        {
            DataClassification = ToBeClassified;
            // TableRelation = AllObjWithCaption."Object ID" WHERE("Object Type" = CONST(Table));

        }
        field(11; "Field No."; Integer)
        {
            DataClassification = ToBeClassified;
            // TableRelation = Field."No." WHERE(TableNo = FIELD("Table No."));
        }
        field(12; "Related to Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Relation Filter"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Relation Based on Field No."; Integer)
        {

        }

        Field(20; "Label field No."; Integer)
        {

        }
        Field(22; "Field Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            ValidateTableRelation = false;
            TableRelation = Field."Field Caption" WHERE(TableNo = FIELD("Table No."));
            trigger OnValidate()
            var
                Fields: Record Field;

            begin
                fields.reset;
                Fields.SetRange("Field Caption", "Field Name");
                Fields.SetRange(TableNo, "Table No.");
                if Fields.findfirst then
                    "Field No." := fields."No.";

            end;
        }
        field(21; "Table Name"; text[50])
        {
            DataClassification = ToBeClassified;
            ValidateTableRelation = false;
            TableRelation = AllObjWithCaption."Object Name" WHERE("Object Type" = CONST(Table));
            trigger OnValidate()
            var
                Objects: Record AllObjWithCaption;
            begin
                Objects.reset;
                Objects.SetRange("Object Type", Objects."Object Type"::Table);
                objects.SetRange("Object Name", "Table Name");
                if Objects.findfirst then
                    "Table No." := Objects."Object ID";

            end;
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}