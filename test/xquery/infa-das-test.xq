xquery version "3.0";
declare namespace das = "http://schemas.active-endpoints.com/data-access/2010/04/data-access.xsd";
declare namespace sf  = "http://schemas.active-endpoints.com/appmodules/screenflow/2010/10/avosScreenflow.xsd";

import module namespace aexqt = "http://activevos.com/modules/unit-test/2.0/xquery" at "ae-test-functions.xq";
import module namespace dasx = "http://www.informatica.com/das/1.0/xquery" at "../../xquery/infa-das.xq";

declare option saxon:output "indent=yes";
declare option saxon:output "saxon:indent-spaces=4";


declare function local:test-objectToDasRequest() {
    let $gAutomatedStepRequest :=  doc("../../sample-data/execSQL/gAutomatedStepRequest.xml")/*/.
    let $dasRequest :=  dasx:getASParam( $gAutomatedStepRequest,"dataAccessRequest" )
    let $actual := dasx:objectToDasRequest($dasRequest)
    let $expected := <das:dataAccessRequest xmlns:das="http://schemas.active-endpoints.com/data-access/2010/04/data-access.xsd">
                    <das:sqlStatement columnCase="unchanged"
                                      hasResultSet="true"
                                      statementId="test_statement">
                        <das:statement>SELECT * FROM source_metadata</das:statement>
                    </das:sqlStatement>
                </das:dataAccessRequest>
    
    
    return aexqt:assert-saxon-deep-equal("test dasx:objectToDasRequest batch request",$actual,$expected)
};

declare function local:test-dasResponseToPO ()  {
    let $gDataAccessResponse :=  doc("../../sample-data/das/gDataAccessResponse.xml")/*/.

    let $actual := dasx:dasResponseToPO($gDataAccessResponse)
    let $expected := <tResponse>
                    <statementId>statement-1</statementId>
                    <metadata>
                        <lb_emd_post_id>
                            <dataType>nvarchar</dataType>
                            <displaySize>255</displaySize>
                        </lb_emd_post_id>
                    </metadata>
                    <row>
                        <lb_emd_post_id>1232573624110583520_1675157082</lb_emd_post_id>
                    </row>
                    <row>
                        <lb_emd_post_id>1234017673904426845_1675157082</lb_emd_post_id>
                    </row>
                    <row>
                        <lb_emd_post_id>1236249478070046424_1675157082</lb_emd_post_id>
                    </row>
                </tResponse>
    
    return aexqt:assert-saxon-deep-equal("test dasx:dasResponseToPO ",$actual,$expected)
};



<test-suite title="Data Access Service xquery module test case" timestamp="{current-dateTime()}">
    <test-case name="dcx:getExistingPosts">
    { local:test-objectToDasRequest()}
    </test-case>
    <test-case name="dcx:getExistingPosts">
    { local:test-dasResponseToPO()}
    </test-case>
    
</test-suite>