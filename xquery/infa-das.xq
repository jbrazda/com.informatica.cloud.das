xquery version "3.0";
module namespace dasx = 'http://www.informatica.com/das/1.0/xquery';
declare namespace das = "http://schemas.active-endpoints.com/data-access/2010/04/data-access.xsd";
declare namespace sf  = "http://schemas.active-endpoints.com/appmodules/screenflow/2010/10/avosScreenflow.xsd";

 
declare function dasx:objectToDasRequest ($node as node()?) as item()* {
    typeswitch ($node)
        case element(sqlStatement) return dasx:po_das_sqlStatement($node)
        case element(statement) return dasx:po_das_statement($node)
        case element(parameter) return dasx:po_das_parameter($node)
        case element(parameterBatch) return dasx:po_das_parameterBatch($node)
        case element(procedure) return dasx:po_das_procedure($node)
        case element(dataSource) return ()
        case element(sf:parameter) return 
              switch (true())
              case matches(data($node/@name),"dataAccessRequest") return dasx:po_das_DataAccessRequest($node/.)
              case matches(data($node/@name),"multiDataAccessRequest") return dasx:po_das_MultiDataAccessRequest($node/.)
              default return  for $child in $node/(node()|@*) return dasx:objectToDasRequest($child)
        default return for $child in $node/(node()|@*) return dasx:objectToDasRequest($child)
};


declare function dasx:elementToAttribute($node as node()) as node()? {
     if (empty($node/text())) then ()
     else 
        attribute { local-name($node) } {$node/text() }
};

declare function dasx:po_das_sqlStatement ($node as node()) as node() {
    <das:sqlStatement>
        {
        for $child in $node/* 
        where not(matches(local-name($child),"^statement$|parameter|parameterBatch|procedure"))
        return dasx:elementToAttribute($child),
        for $item in $node/*[matches(local-name(.),"^statement$|parameter|parameterBatch|procedure")] return dasx:objectToDasRequest($item)
        }
    </das:sqlStatement>
};

declare function dasx:po_das_DataAccessRequest ($node as node()) as node() {
    <das:dataAccessRequest>
        {
        for $child in $node/node() 
        where  local-name($child) != "dataSource"
        return dasx:objectToDasRequest($child)
        }
    </das:dataAccessRequest>
};

declare function dasx:po_das_MultiDataAccessRequest ($node as node()) as node() {
    <das:multiDataAccessRequest>
        {
        for $child in $node/node()
        where  local-name($child)!="dataSource"
        return dasx:objectToDasRequest($child)
        }
    </das:multiDataAccessRequest>
};

declare function dasx:po_das_parameterBatch ($node as node()) as node() {
    <das:parameterBatch>
        {
        for $child in $node/(node()) return dasx:objectToDasRequest($child)
        }
    </das:parameterBatch>
};

declare function dasx:po_das_parameter ($node as node()) as node() {
    <das:parameter>
        {
        for $child in $node/* 
        where not(matches(local-name($child),"data"))
        return dasx:elementToAttribute($child),
        data($node/data)
        }
    </das:parameter>
};

declare function dasx:po_das_procedure ($node as node()) as node() {
    <das:procedure>
        {
        for $child in $node/(node()) return dasx:objectToDasRequest($child)
        }
    </das:procedure>
};

declare function dasx:po_das_statement ($node) as node() {
    <das:statement>{data($node)}</das:statement>
};

declare function dasx:dasResponseToPO ($node as node()?) as item()* {
    typeswitch ($node)
        case element(das:dataAccessResponse) return dasx:das_po_tResponse($node)
        case attribute(*) return dasx:attributeToElement($node)
        case element(*) return dasx:das_po_element($node)
        case text() return $node
        default  return for $child in $node/(node()|@*) return dasx:dasResponseToPO($child)
};

declare function dasx:attributeToElement ($node as node()) as item() {
    element { node-name($node) } { data($node)}
};

declare function dasx:das_po_tResponse ($node) as node() {
    <tResponse>
        {for $child in $node/(node()|@*) return dasx:dasResponseToPO($child)}
    </tResponse>
};

declare function dasx:das_po_element($node as node()) as node() {
    element {local-name($node)} {for $child in $node/(node()|@*) return dasx:dasResponseToPO($child)}
};
 
declare function dasx:getASParam ($automatedStepRequest as node(), $paramName as xs:string) as item()? {
    $automatedStepRequest/sf:parameters/sf:parameter[@name=$paramName]
};

declare function dasx:getDataSourceID ($automatedStepRequest as node(),$paramName as xs:string) as item()? {
    $automatedStepRequest/sf:parameters/sf:parameter[@name=$paramName]/*/dataSource/text()
};
