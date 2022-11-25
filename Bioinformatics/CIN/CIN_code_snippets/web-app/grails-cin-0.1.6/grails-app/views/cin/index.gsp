<html>
    <head>
        <meta name="layout" content="main" />
        <title><g:message code="cin.title"/></title>  
       <g:javascript library="jquery" plugin="gcore"/>

    </head>
    <body>
	<p style="font-size:14pt"><g:message code="cin.title"/></p>
	
	<div id="studyPicker">
		<g:render template="/studyDataSource/studyPicker" plugin="gcore"/>
	</div>

	<div id="searchDiv">
		<g:render template="/cin/studyForm" plugin="cin"/>
	</div>
	
	</body>
	
</html>