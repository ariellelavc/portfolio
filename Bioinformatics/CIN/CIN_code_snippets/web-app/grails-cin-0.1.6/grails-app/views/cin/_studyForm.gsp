<g:javascript src="dataSet.js" plugin="gcore"/>

<g:if test="${session.study}">
<g:javascript>
$(document).ready( function () {
		$('input[type=submit]', this).attr('disabled', false);
	 	$('#analysisForm').submit(function() {
			$('#submit').attr("disabled", "true");
 		});
	});

</g:javascript>
<g:if test="${session.study.hasCopyNumberData()}">
	<p><g:message code="cin.selectGroups"/></p>
	<g:if test="${flash.message}">
	<div class="message" style="width:75%">
		${flash?.message}
	</div>
	</g:if>
	<g:form name="analysisForm" action="submit">

	<div class="clinicalSearch">
		<br />

		<g:message code="cin.baselineGroup"/>:
		<g:select name="baselineGroup"
				noSelection="${['':message(code:'cin.baselineGroup') + '...']}"
				value="${flash.cmd?.baselineGroup}"
				from="${session.patientLists}" optionKey="id" optionValue="name"	/>			
		<br/>
		<div class="errorDetail">
			<g:renderErrors bean="${flash.cmd?.errors}" field="baselineGroup" />
		</div>
		<br />
		<g:message code="cin.comparisonGroup"/>:
		<g:select name="groups"
			noSelection="${['':message(code:'cin.comparisonGroup')  + '...']}"
			value="${flash.cmd?.groups}"
			from="${session.patientLists}" optionKey="id" optionValue="name"	/>
		<br/>
		<div class="errorDetail">
			<g:renderErrors bean="${flash.cmd?.errors}" field="groups" />
		</div>
		<br/>
		<g:hiddenField name="dataFile" value="${session.df}" />
		<g:hiddenField name="cytobandsDataFile" value="${session.cdf}" />
		<g:hiddenField name="study" value="${session.study.schemaName}" />
	</div>
	<br/>
	<g:submitButton name="submit" value="${message(code: 'cin.submit')}"/>
	</g:form>
</g:if>
<g:else>
	<g:message code="cin.noCopyNumberData"/> ${session.study.shortName}
</g:else>
</g:if>

<g:else>
<p><g:message code="cin.noStudySelected"/></p>
</g:else>