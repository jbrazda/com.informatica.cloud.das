xquery version "3.0";

declare namespace sf = "http://schemas.active-endpoints.com/appmodules/screenflow/2010/10/avosScreenflow.xsd";
declare namespace soap = "http://schemas.xmlsoap.org/soap/envelope/";
declare namespace cvent = "http://api.cvent.com/2006-11";
declare namespace das = "http://schemas.active-endpoints.com/data-access/2010/04/data-access.xsd";


declare option saxon:output "indent=yes";
declare option saxon:output "saxon:indent-spaces=4";

declare function local:objectToDasRequest ($node as node()?) as item()* {
    typeswitch ($node)
        case element(tDataAccessRequest) return local:po_das_DataAccessRequest($node)
        case element(tMultiDataAccessRequest) return local:po_das_MultiDataAccessRequest($node)
        case element(sqlStatement) return local:po_das_sqlStatement($node)
        case element(statement) return local:po_das_statement($node)
        case element(parameter) return local:po_das_parameter($node)
        case element(procedureParameter) return local:po_das_parameter($node)
        case element(parameterBatch) return local:po_das_parameterBatch($node)
        case element(procedure) return local:po_das_procedure($node)
        case element(dataSource) return ()

        default  return for $child in $node/(node()|@*) return local:objectToDasRequest($child)
};


declare function local:elementToAttribute($node as node()) as node()? {
     if (empty($node/text())) then ()
     else 
        attribute { local-name($node) } {$node/text() }
};

declare function local:po_das_sqlStatement ($node as node()) as node() {
    <das:sqlStatement>
        {
        for $child in $node/* 
        where not(matches(local-name($child),"^statement$|parameter|parameterBatch|procedure"))
        return local:elementToAttribute($child),
        for $item in $node/*[matches(local-name(.),"^statement$|parameter|parameterBatch|procedure")] return local:objectToDasRequest($item)
        }
        
    </das:sqlStatement>
};

declare function local:po_das_DataAccessRequest ($node as node()) as node() {
    <das:dataAccessRequest>
        {
        for $child in $node/* 
        return local:objectToDasRequest($child)
        }
    </das:dataAccessRequest>
};

declare function local:po_das_MultiDataAccessRequest ($node as node()) as node() {
    <das:multiDataAccessRequest>
        {
        for $child in $node/* 
        return local:objectToDasRequest($child)
        }
    </das:multiDataAccessRequest>
};

declare function local:po_das_parameterBatch ($node as node()) as node() {
    <das:parameterBatch>
        {
        for $child in $node/(node()) return local:objectToDasRequest($child)
        }
    </das:parameterBatch>
};

declare function local:po_das_parameter ($node as node()) as node() {
    <das:parameter>
        {
        for $child in $node/* 
        where not(matches(local-name($child),"data"))
        return local:elementToAttribute($child),
        data($node/data)
        }
    </das:parameter>
};

declare function local:po_das_procedure ($node as node()) as node() {
    <das:procedure>
        {
        for $child in $node/(node()) return local:objectToDasRequest($child)
        }
    </das:procedure>
};

declare function local:po_das_statement ($node) as node() {
    <das:statement>{data($node)}</das:statement>
};


let $po_das_request := doc("../../../sample-data/processObjects/tDataAccessRequestStoredProcedure.xml")/*/.

return
local:objectToDasRequest($po_das_request)