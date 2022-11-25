import gov.nih.nci.caintegrator.analysis.messaging.ChromosomalInstabilityIndexRequest
import gov.nih.nci.caintegrator.analysis.messaging.SampleGroup

class CinService {
	def idService
	
	def handle(userId, cmd) {
		def request = new ChromosomalInstabilityIndexRequest(userId, "CIN_" + System.currentTimeMillis())
		request.dataFileName = cmd.dataFile
		request.cytobandsDataFileName = cmd.cytobandsDataFile
		request.cytobandsAnnotationFileName = cmd.cytobandsAnnotationFile
		def ul1 = UserList.get(cmd.groups)
		def group1 = new SampleGroup(ul1?.name)
		log.debug "my group1 is $group1"
		def samples = idService.samplesForListId(cmd.groups)
		def allIds = idService.sampleIdsForFile(cmd.dataFile)
		samples = allIds.intersect(samples)
		group1.addAll(samples)
		log.debug "group 1: " + samples
		def ul2 = UserList.get(cmd.baselineGroup)
		def baseline = new SampleGroup(ul2?.name)
		log.debug "my baselineGroup is $cmd.baselineGroup"
		def baselineSamples = idService.samplesForListId(cmd.baselineGroup)			
		baselineSamples = allIds.intersect(baselineSamples)
		log.debug "baseline samples: $baselineSamples"
		baseline.addAll(baselineSamples)
		request.group1 = group1
		request.group2 = baseline
		return request
	}
}