declare namespace sf = "http://schemas.active-endpoints.com/appmodules/screenflow/2010/10/avosScreenflow.xsd";

declare option saxon:output "indent=yes";
declare option saxon:output "saxon:indent-spaces=4";


let $response := <aetgt:automatedStepResponse xmlns:aetgt="http://schemas.active-endpoints.com/appmodules/screenflow/2010/10/avosScreenflow.xsd"
                             xmlns:sf="http://schemas.active-endpoints.com/appmodules/screenflow/2010/10/avosScreenflow.xsd"
                             xmlns:S="http://schemas.xmlsoap.org/soap/envelope/"
                             xmlns:ns2="http://schemas.active-endpoints.com/engineapi/2010/09/ProcessManagementTypes.xsd"
                             xmlns:ns3="http://schemas.active-endpoints.com/engineapi/2010/05/EngineAPITypes.xsd">
   <sf:fields>
      <sf:field name="tResponse">
         <tResponse>
            <statementId>test_table_select_all</statementId>
            <metadata>
               <idtest_table>
                  <dataType>INT</dataType>
                  <displaySize>11</displaySize>
               </idtest_table>
               <col_varchar>
                  <dataType>VARCHAR</dataType>
                  <displaySize>45</displaySize>
               </col_varchar>
               <col_int>
                  <dataType>INT</dataType>
                  <displaySize>11</displaySize>
               </col_int>
               <col_datetime>
                  <dataType>DATETIME</dataType>
                  <displaySize>19</displaySize>
               </col_datetime>
               <col_bigint>
                  <dataType>BIGINT</dataType>
                  <displaySize>20</displaySize>
               </col_bigint>
            </metadata>
            <row>
               <idtest_table>1</idtest_table>
               <col_varchar>test</col_varchar>
               <col_int>23</col_int>
               <col_datetime>2017-07-07T14:00:28Z</col_datetime>
               <col_bigint>12345678</col_bigint>
            </row>
            <row>
               <idtest_table>2</idtest_table>
               <col_varchar>test</col_varchar>
               <col_int>2</col_int>
               <col_datetime>2017-07-07T14:00:29Z</col_datetime>
               <col_bigint>444444444</col_bigint>
            </row>
            <row>
               <idtest_table>3</idtest_table>
               <col_varchar>3</col_varchar>
               <col_int/>
               <col_datetime>2017-07-07T14:00:29Z</col_datetime>
               <col_bigint>987654321</col_bigint>
            </row>
         </tResponse>
      </sf:field>
   </sf:fields>
</aetgt:automatedStepResponse>

let $tResponse := $response/sf:fields/sf:field[@name="tResponse"]/*
return 
for $row in $tResponse/row
return
<processObject>
    <field1>{$row/idtest_table/text()}</field1>
    <field2>{$row/col_varchar/text()}</field2>
</processObject>

