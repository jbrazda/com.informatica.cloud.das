xquery version "3.0";

declare namespace sf = "http://schemas.active-endpoints.com/appmodules/screenflow/2010/10/avosScreenflow.xsd";
declare namespace soap = "http://schemas.xmlsoap.org/soap/envelope/";
declare namespace cvent = "http://api.cvent.com/2006-11";
declare namespace das = "http://schemas.active-endpoints.com/data-access/2010/04/data-access.xsd";


declare option saxon:output "indent=yes";
declare option saxon:output "saxon:indent-spaces=4";

declare function local:dasResponseToPO ($node as node()?) as item()* {
    typeswitch ($node)
        
        case element(das:dataAccessResponse) return local:das_po_tResponse($node)
        case attribute(*) return local:attributeToElement($node)
        case element(*) return local:das_po_element($node)
        case text() return $node
        default  return for $child in $node/(node()|@*) return local:dasResponseToPO($child)
};

declare function local:attributeToElement ($node as node()) as item() {
    element { node-name($node) } { data($node)}
};

declare function local:das_po_tResponse ($node) as node() {
    <tResponse>
        {for $child in $node/(node()|@*) return local:dasResponseToPO($child)}
    </tResponse>
};

declare function local:das_po_element($node as node()) as node() {
  element {local-name($node)} {for $child in $node/(node()|@*) return local:dasResponseToPO($child)}
};
 

let $das_restponse := doc("../../../sample-data/das/gDataAccessResponse.xml")/*/.

return
local:dasResponseToPO($das_restponse)