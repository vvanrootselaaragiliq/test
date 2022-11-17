codeunit 50101 BartenderWebserviceConnector
{
    procedure Print(varSoapTxt: text);
    var
        LabelWebserviceSetupTable: Record LabelWebserviceSetupTable;
        HttpClient: HttpClient;
        content: HttpContent;
        contentHeaders: HttpHeaders;
        ResponseMessage: HttpResponseMessage;
        JsonToken: JsonToken;
        JsonValue: JsonValue;
        JsonObject: JsonObject;
        JsonArray: JsonArray;
        JsonText: text;
        RequestUrl: text;
        i: Integer;
        request: HttpRequestMessage;
    begin
        LabelWebserviceSetupTable.GET(2);

        // Simple webasd service call
        //HttpClient.DefaultRequestHeaders.Add('User-Agent', 'Dynamics 365');

        //HttpContent.WriteFrom(varSoapTxt);
        //HttpContent.GetHeaders(HttpHeadersContent);
        //HttpHeadersContent.Remove('Content-Type');
        //HttpHeadersContent.Add('Content-Type', 'text/plain');
        //HttpHeadersContent.Add('SOAPAction', SoapAction);
        //HttpClient.SetBaseAddress(LabelWebserviceSetupTable.Url);
        //HttpClient.DefaultRequestHeaders.Add('User-Agent', 'Dynamics 365');
        //HttpClient.Post(LabelWebserviceSetupTable.Url, HttpContent, ResponseMessage);
        content.GetHeaders(contentHeaders);
        contentHeaders.Clear();
        contentHeaders.Add('Content-Type', 'text/csv');

        //varSoapTxt := CreateJsonProcedure();

        content.WriteFrom(varSoapTxt);
        request.Content := content;

        RequestUrl := LabelWebserviceSetupTable.Url;// + '?Text1=Seagull&Barcode=12345678';
        Message(varSoapTxt);
        request.SetRequestUri(RequestUrl);

        request.Method := 'POST';


        if not HttpClient.Send(request, ResponseMessage) then
            Error('SENDERROR: %1', GetLastErrorText());


        //if not HttpClient.Get(LabelWebserviceSetupTable.Url,
        //                      ResponseMessage)
        //then
        //    Error('The call to the web service failed.');

        if not ResponseMessage.IsSuccessStatusCode then
            error('The web service returned an error message:\\' +
                  'Status code: %1\' +
                  'Description: %2',
                  ResponseMessage.HttpStatusCode,
                  ResponseMessage.ReasonPhrase);

        ResponseMessage.Content.ReadAs(JsonText);
        error(JsonText);

        // Process JSON response
        if not JsonArray.ReadFrom(JsonText) then
            Error('Invalid response, expected an JSON array as root object');

        /*for i := 0 to JsonArray.Count - 1 do begin
            JsonArray.Get(i, JsonToken);
            JsonObject := JsonToken.AsObject;

            ALIssue.init;
            if not JsonObject.Get('id', JsonToken) then
                error('Could not find a token with key %1');

            ALIssue.id := JsonToken.AsValue.AsInteger;

            ALIssue.number := GetJsonToken(JsonObject, 'number').AsValue.AsInteger;
            ALIssue.title := GetJsonToken(JsonObject, 'title').AsValue.AsText;
            //ALIssue.created_at := GetJsonToken(JsonObject,'created_at').AsValue.AsDateTime;
            ALIssue.user := SelectJsonToken(JsonObject, '$.user.login').AsValue.AsText;
            ALIssue.state := GetJsonToken(JsonObject, 'state').AsValue.AsText;
            ALIssue.html_url := GetJsonToken(JsonObject, 'html_url').AsValue.AsText;
            ALIssue.Insert;
        end;
        */
    end;

    procedure GetJsonToken(JsonObject: JsonObject; TokenKey: text) JsonToken: JsonToken;
    begin
        if not JsonObject.Get(TokenKey, JsonToken) then
            Error('Could not find a token with key %1', TokenKey);
    end;

    procedure SelectJsonToken(JsonObject: JsonObject; Path: text) JsonToken: JsonToken;
    begin
        if not JsonObject.SelectToken(Path, JsonToken) then
            Error('Could not find a token with path %1', Path);
    end;

    procedure GetMappedFieldsLabelBody(var RecRef: RecordRef; LabelNo: Integer; var LabelBodyTxt: text[250]; recurring: Boolean) LabelBody: text
    var
        LabelMappingTable: Record LabelMappingTable;
        item: Record Item;
        FldRef: FieldRef;
        RecVar: Variant;
        RelatedLabelMapping: Record LabelMappingTable;
        RelatedRecRef: RecordRef;
        RelatedFldRef: FieldRef;
        RelatedLabelMapping2: Record LabelMappingTable;
        MasterLabelMapping: Record LabelMappingTable;
        relatedLineNo: Integer;

    begin

        if recurring then begin
            MasterLabelMapping.SetRange("Table No.", RecRef.Number);
            if MasterLabelMapping.findset then
                relatedLineNo := MasterLabelMapping."Related to Line No.";
        end;


        LabelMappingTable.RESET;
        if recurring then
            LabelMappingTable.SetRange("Table No.", RecRef.Number)
        else
            LabelMappingTable.SETRANGE("Related to Line No.", 0);


        LabelMappingTable.setrange("Label No.", labelNo);
        IF LabelMappingTable.FINDFIRST THEN BEGIN
            REPEAT
                RelatedLabelMapping.reset;
                RelatedLabelMapping.SetRange("Related to Line No.", LabelMappingTable."No.");
                if RelatedLabelMapping.findset then begin
                    FldRef := RecRef.FIELD(LabelMappingTable."Field No.");
                    RelatedRecRef.open(RelatedLabelMapping."Table No.");
                    RelatedFldRef := RelatedRecRef.FIELD(RelatedLabelMapping."Relation Based on Field No.");//RelatedLabelMapping."Field No.");
                    //RelatedFldRef.value := (FldRef.Value);
                    RelatedFldRef.setfilter(FldRef.Value);
                    if RelatedRecRef.Find('+') then;

                    RelatedFldRef := RelatedRecRef.field(RelatedLabelMapping."Field No.");
                    if RelatedLabelMapping."Label field No." <> 0 then
                        LabelBody := LabelBody + ';' + FORMAT(RelatedFldRef.VALUE);

                    RelatedLabelMapping2.reset;
                    RelatedLabelMapping2.SetRange("Related to Line No.", RelatedLabelMapping."No.");
                    if RelatedLabelMapping2.findset then begin
                        GetMappedFieldsLabelBody(RelatedRecRef, LabelNo, LabelBody, true);
                    end;


                end else begin

                    FldRef := RecRef.FIELD(LabelMappingTable."Field No.");
                    if LabelMappingTable."Label field No." <> 0 then
                        LabelBody := LabelBody + ';' + format(FldRef.VALUE);



                end;
            // FldRef := RecRef.FIELD(LabelMappingTable."Field No.");
            // LabelBody := LabelBody + ';' + format(FldRef.VALUE);

            // IF EmailText."New Line" THEN BEGIN
            // BodyText.ADDTEXT := FORMAT(LFReturn,0,'<CHAR>');
            // BodyText.ADDTEXT := FORMAT(CrReturn,0,'<CHAR>') + FORMAT(LFReturn,0,'<CHAR>') ;
            //END;
            UNTIL LabelMappingTable.NEXT = 0;
            LabelBodyTxt := LabelBodyTxt + LabelBody;

        end;
        LabelBody := LabelBodyTxt;
    end;

    procedure CreateJsonProcedure() JsonText: text
    var
        VJsonObjectHeader: JsonObject;
        VJsonObjectLines: JsonObject;
        VJsonArray: JsonArray;
        VJsonArrayLines: JsonArray;
        VSalesHeader: Record "Sales Header";
        VSalesLines: Record "Sales Line";
    begin

        // Header
        VJsonObjectHeader.Add('Barcode', 'Barcode1');
        VJsonObjectHeader.Add('Text1', 'TestText1');



        VJsonArray.Add(VJsonObjectHeader);
        VJsonArray.WriteTo(JsonText);


    end;



}



