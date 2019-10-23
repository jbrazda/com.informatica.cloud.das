xquery version "3.0";

declare namespace sf = "http://schemas.active-endpoints.com/appmodules/screenflow/2010/10/avosScreenflow.xsd";
declare namespace soap = "http://schemas.xmlsoap.org/soap/envelope/";
declare namespace cvent = "http://api.cvent.com/2006-11";
declare namespace das = "http://schemas.active-endpoints.com/data-access/2010/04/data-access.xsd";


declare option saxon:output "indent=yes";
declare option saxon:output "saxon:indent-spaces=4";

declare function local:sequenceToJsonList ($strings as xs:string* ) as xs:string {
    let $jsonValueSeq := for $value in $strings
                    return concat('{ label: "', normalize-space($value),'", value: "', normalize-space($value), '"}')                    
    return concat('[',string-join($jsonValueSeq,','),']')
};

let $das_schema := doc("../../../schema/data-access.xsd")/*/.
let $enumeratedTypes := $das_schema/xs:simpleType[not(empty(xs:restriction/xs:enumeration))]

return
<pickLists>
    {
    for $type in $enumeratedTypes
     return
     <option name="values">{local:sequenceToJsonList(data($type/xs:restriction/xs:enumeration/@value))}</option>
     , 
     <option name="values">{local:sequenceToJsonList(("DS1","DS2","DS3","DS4","DS5"))}</option>
    }
</pickLists>

 