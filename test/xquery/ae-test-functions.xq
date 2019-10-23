(:
  Copyright (c) 2010-2012 Active Endpoints, Inc

  This code is free software: you can redistribute it and/or modify it subject to 
  agreeing to comply with Active Endpoints, Inc�s  export restrictions posted at
  http::www.activevos.com/legal.php#exportrestrictions.  

  Unless required by applicable law or agreed to in writing, software
  is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
  ANY KIND, either express or implied.
:)
xquery version "3.0";
module namespace aexqt = 'http://activevos.com/modules/unit-test/2.0/xquery';

declare namespace sd    = "http://schemas.active-endpoints.com/appmodules/screenflow/2010/10/avosServiceDiscovery.xsd";
declare namespace od    = "http://schemas.active-endpoints.com/appmodules/screenflow/2012/09/avosObjectDiscovery.xsd";
declare namespace sf    = "http://schemas.active-endpoints.com/appmodules/screenflow/2010/10/avosScreenflow.xsd";
declare namespace hes   = "http://schemas.active-endpoints.com/appmodules/screenflow/2011/06/avosHostEnvironment.xsd";
declare namespace das   = "http://schemas.active-endpoints.com/data-access/2010/04/data-access.xsd";

(:
 assert-equal
 Assertion Validates equality of two items it is using fn:deep-equal xquery function
 The fn:deep-equal function returns true if the $parameter1 and $parameter2 sequences 
 contains the same values, in the same order.
 Atomic values are compared based on their typed values, using the eq operator. 
 If two atomic values cannot be compared (e.g. because one is a number, and the other is a string), 
 the function returns false rather than raise an error.
 Informally, two nodes are deep-equal if they have all the same attributes and have 
 children (in the same order) who are themselves deep-equal.
 Parameters:
     $name - Assertion Name
     $actual item()*- item to compare
     $expected item()*- expected values
:)
declare function aexqt:assert-equal($name, $actual as item()*, $expected as item()*) {
	if (fn:deep-equal($expected, $actual)) then
        aexqt:response-success($name)
    else 
        aexqt:response-fail($name,$actual,$expected)
};

(:
 assert-equal
 Assertion Validates negative equality of two items it is using fn:deep-equal comparison
 Parameters:
     $name - Assertion Name
     $actual item()*- item to compare
     $expected item()*- expected values
:)
declare function aexqt:assert-not-equal($name, $actual as item()*, $expected as item()*) {
    if (not(fn:deep-equal($actual,$expected))) then
        aexqt:response-success($name)
    else 
        aexqt:response-fail($name,$actual,$expected)
};

(:
 assert-equal
 Assertion Validates negative equality of two items it is using value comparison
 Parameters:
     $name - Assertion Name
     $actual item()*- item to compare
     $expected item()*- expected values
:)
declare function aexqt:assert-value-not-equal($name, $actual as item()*, $neValue as item()*) {
    if ( $actual ne $neValue ) then
        aexqt:response-success($name)
    else 
        aexqt:response-fail($name,$actual,$neValue)
};

(:
 assert-saxon-deep-equal
 Assertion Validates equality of two items it is using fn:deep-equal xquery function is too sensitive on white space differences
 The saxon:deep-equal allows to control compare behavior. but is available only in Saxon-PE and Saxon-EE
  @see http://saxonica.com/documentation9.4-demo/html/extensions/functions/deepequal.html
 
 Parameters:
     $name - Assertion Name
     $actual item()*- item to compare
     $expected item()*- expected values
:)
declare function aexqt:assert-saxon-deep-equal($name, $actual as item()*, $expected as item()*) {
	if (saxon:deep-equal($expected, $actual,(),'JCPSw?')) then 
		aexqt:response-success($name)
	else 
		aexqt:response-fail($name,$actual,$expected)
};


(:
 assert-exists
 Assertion validate existence of elements
 Parameters
     $name - Assertion Name
     $actual item()* - xpath expression result
:)
declare function aexqt:assert-exists($name, $expressionresult as item()*) {
    if (not(empty($expressionresult))) then 
        aexqt:response-success($name)
    else 
        let $actual := "Empty"
        let $expected := "Expected non empty result"
        return 
        aexqt:response-fail($name,$actual,$expected)
};

(:
 assert-contains
 Assertion validate if one string contains sunstring
 $arg1  xs:string?  the string to test
 $arg2  xs:string?  the substring to test for
:)
declare function aexqt:assert-contains($name, $string as xs:string? , $substring as xs:string? ) {
    if (contains($string,$substring)) then 
        aexqt:response-success($name)
    else 
        let $expected := concat('Expected substring: ',$substring)
        return 
        aexqt:response-fail($name,$string,$expected)
};


(:
 assert-exists
 Assertion validate count of items
 it is using fn:count function to count the items
 Parameters:
     $name - Assertion Name
     $actual item()*- item to count
     $expected xs:integer- expected count
:)
declare function aexqt:assert-count($name, $tocount as item()*, $expected as xs:integer) {
    if (fn:count($tocount)=$expected) then 
        aexqt:response-success($name)
    else 
        aexqt:response-fail($name,string(fn:count($tocount)),string($expected))

};

(:assert-string-equal
 Assertion validate if two strings are equal
 Parameters:
     $name - Assertion Name
     $actual xs:string- evaluated string
     $expected xs:integer- eexpected string
:)
declare function aexqt:assert-string-equal($name, $actual as xs:string, 
		$expected as xs:string) as xs:boolean {
		
	if (fn:boolean(fn:compare($actual, $expected))) then 
		aexqt:response-success($name)
    else 
        aexqt:response-fail($name,$actual,$expected)
};

(:~
 The aexqt:sequence-deep-equal function returns a boolean value indicating whether the two sequences have the same content or values, in the same order.
 To compare items, it uses the built-in fn:deep-equal function. The argument sequences can contain nodes or atomic values or both.
 For nodes, it compares them based on their contents and attributes, not their node identity. For atomic values, it compares them based on their typed values.
:)
declare function aexqt:sequence-deep-equal 
  ( $seq1 as item()* ,
    $seq2 as item()* )  as xs:boolean {
	
	every $i in 1 to max((count($seq1),count($seq2)))
	satisfies deep-equal($seq1[$i],$seq2[$i])
 } ;
 
(:
   The aexqt:sequence-node-equal function returns a boolean value indicating whether the two arguments have the same nodes, in the same order.
   They are compared based on node identity, not their contents.
    Name    Type        Description
    $seq1   node()*     the first sequence of nodes
    $seq2   node()*     the second sequence of nodes
    returns xs:boolean 
:)
 declare function aexqt:sequence-node-equal 
  ( $seq1 as node()* ,
    $seq2 as node()* )  as xs:boolean {
       
	every $i in 1 to max((count($seq1),count($seq2)))
	satisfies $seq1[$i] is $seq2[$i]
 } ;
 
(: 
    The response-fail function generates test result failure element
    Name        Type        Description
    $name       xs:string   test name
    $actual     item()*     actual value returned by tested assertion
    $expected   item()*     expected assertion result value
 :)
declare function aexqt:response-fail(
    $name as xs:string,
    $actual as item()*, 
    $expected as item()*) {
    
    <fail test="{$name}">
         <expected>{$expected}</expected>
         <actual>{$actual}</actual>
    </fail>  
        
};

(: 
    The response-fail function generates test succes element
    Name        Type        Description
    $name       xs:string   test name
 :)
declare function aexqt:response-success(
    $name as xs:string) {
    <pass test="{$name}"/>
};

(: 
    Function Validates string against regex patten it passes the test if regex matches the input string
    Name        Type        Description
    $name       xs:string   test name
    $input      xs:string   Input striing
    $pattern    xs:string   Match regex expression against the string
 :)
declare function aexqt:assert-matches ($name as xs:string, $input as xs:string?, $pattern as xs:string) {
    if (matches($input, $pattern)) then
        aexqt:response-success($name)
    else
        aexqt:response-fail($name,$input,concat("Expected string matching regex", $pattern))
    
};

(:
   The aexqt:assert-number function asserts that the output value is a number
    Name    Type        Description
    $name   xs:string   The arret name
    $value  item()    the first sequence of nodes
:)
declare function aexqt:assert-number ($name as xs:string, $value as item()) as item() {
    try {
    let $number := number($value)
    return aexqt:response-success($name)
    }
    catch * {
        aexqt:response-fail($name,$value,concat("Expected a number, got ", $value))
    }
};
