import grails.converters.*
import java.text.*
import java.math.*

@Mixin(ControllerMixin)
@Extension(type=ExtensionType.ANALYSIS, menu="Chromosomal Instability Index")
class CinController {
	def analysisService
	def savedAnalysisService
	def annotationService
	def userListService
	def htDataService
	
    def index = { 
		if(session.study){
			if(params.baselineGroup && params.groups){
				CinCommand cmd  = new CinCommand();
				cmd.baselineGroup = params.baselineGroup 
				cmd.groups = params.groups
				flash.cmd = cmd
				flash.message = message(code:"cin.tempGroups")
			}
			StudyContext.setStudy(session.study.schemaName)
            if (session.study.hasCopyNumberData()) {
				session.files = htDataService.getCINDataMap()
				session.dataSetType = session.files.keySet()
				session.df = session.files.values().toArray()[0][0]
				session.cdf = session.files.values().toArray()[0][1]
				log.debug "my ht files for $session.study = $session.files $session.df $session.cdf"
			}
		}
		loadPatientLists()
		return [diseases:getDiseases(),myStudies:session.myStudies, params:params,availableSubjectTypes:getSubjectTypes()]
	}
	
	def view = {
		if(isAccessible(params.id)){
			def analysisResult = savedAnalysisService.getSavedAnalysis(params.id)
			if (analysisResult.type != AnalysisType.CIN) {
				log.debug "user CANNOT access analysis $params.id because is not a CIN analysis but a $analysisResult.type analysis"
				redirect(controller:'policies', action:'deniedAccess')
			}
			StudyContext.setStudy(analysisResult.query["study"])
			loadCurrentStudy()
			session.results = analysisResult.analysis.item
			session.analysis = analysisResult
		}
		else{
			log.debug "user CANNOT access analysis $params.id"
			redirect(controller:'policies', action:'deniedAccess')
		}
		
	}
	
	def submit = {CinCommand cmd ->
			log.debug "cin params : $params"
			log.debug "Command: " + cmd.groups
			log.debug "type : " + cmd.requestType
			log.debug analysisService
			log.debug "baseline group : " + cmd.baselineGroup
			log.debug "groups : " + cmd.groups
			log.debug "study:" + cmd.study 
			log.debug cmd.errors
		if(cmd.hasErrors()) {
			flash['cmd'] = cmd
			def study = Study.findBySchemaName(cmd.study)
			redirect(action:'index',id:study.id)
		} else {
			def tags = []
			tags << "cin"
			def author = GDOCUser.findByUsername(session.userId)
			def list1IsTemp = userListService.listIsTemporary(cmd.groups,author)
			def list2IsTemp = userListService.listIsTemporary(cmd.baselineGroup,author)
			if(list1IsTemp || list2IsTemp){
				tags << Constants.TEMPORARY
			}
			
			analysisService.sendRequest(session.id, cmd, tags)
			redirect(controller:'notification')
		}
		
	}
	
	def file = {
		def result = session.results
		try{
			if(params.name){
				byte[] fileBytes
				String chr
				if(params.name.indexOf('chr') >= 0 ) {		
					chr = params.name.substring(11)
					fileBytes = result.cinFiles.get(chr)
				}
				if(params.name.indexOf('heatmap') >= 0)
					fileBytes = result.cinFiles.get('heatmap')
				response.outputStream << fileBytes
			}
		}catch(java.io.FileNotFoundException fnf){
			log.debug fnf.toString()
			render message(code:"cin.fileNotFound", args:[params.name])
		} catch (Exception e) {
			e.printStackTrace()
		}
	}
	
	def saveHeatmap = {
		def result = session.results
		try{
			if(params.name){
				byte[] fileBytes
				String fileName
				if(params.name.indexOf('chr') >= 0 ) {
					String chr = params.name.substring(11)
					fileBytes = result.cinFiles.get(chr)
					fileName = "CHR" + chr + "_CytobandsCINheatmap.png"
				}
				if(params.name.indexOf('heatmap') >= 0) {
					fileBytes = result.cinFiles.get('heatmap')
					fileName="CINheatmap.png"
				}
				response.setHeader("Content-disposition", "attachment; filename=$fileName")
				response.contentType = "application/png" 
				response.outputStream << fileBytes
				response.outputStream.flush()
				response.outputStream.close()
			}
		}catch(java.io.FileNotFoundException fnf){
				log.debug fnf.toString()
				render message(code:"cin.fileNotFound", args:[params.name])
		} catch (Exception e) {
				e.printStackTrace()
		}
	}
	
}
