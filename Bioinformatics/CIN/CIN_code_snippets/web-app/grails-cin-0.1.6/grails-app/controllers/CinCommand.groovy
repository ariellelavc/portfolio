class CinCommand {
	
	String study
	String dataFile
	String cytobandsDataFile
	String cytobandsAnnotationFile = "hg18_annot.Rda"
	String baselineGroup
	String groups
	static AnalysisType requestType = (AnalysisType.CIN)
	def userListService
	def idService
	
	static constraints = {
		dataFile(blank:false)
		cytobandsDataFile(blank:false)
		baselineGroup(blank:false)
		groups(blank:false, validator: {val, obj ->
			if(obj.baselineGroup && obj.userListService.doListsOverlap(obj.baselineGroup, val))
				return "custom.overlap"
			if(obj.baselineGroup && obj.groups && obj.dataFile) {
				def groupHash = obj.userListService.checkGroupSizes([obj.groups, obj.baselineGroup], obj.dataFile)
				
				if(groupHash[obj.baselineGroup] < 3 && groupHash[obj.groups] < 3) {
					return "custom.groupSize"
				} else if(groupHash[obj.baselineGroup] < 3) {
					return "custom.baselineGroupSize"
				} else if(groupHash[obj.groups] < 3) {
					return "custom.comparisonGroupSize"
				}
			}
		})
	}
	
}