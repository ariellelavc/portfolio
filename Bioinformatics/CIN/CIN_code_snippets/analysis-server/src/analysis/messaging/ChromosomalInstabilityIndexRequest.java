package gov.nih.nci.caintegrator.analysis.messaging;

/**
 * 
 * @author Lavinia A. Carabet
 *
 */

public class ChromosomalInstabilityIndexRequest extends AnalysisRequest implements java.io.Serializable {

	private static final long serialVersionUID = 4362735330341541403L;
	
	private SampleGroup group1 = null;
	private SampleGroup group2 = null;
	private String cytobandsDataFileName = null;
	private String cytobandsAnnotationFileName = null;
	
	public ChromosomalInstabilityIndexRequest(String sessionId, String taskId) {
		super(sessionId, taskId);
	}
	
	public String toString() {
		  
		  int group1Size = -1;
		  if (group1 !=null) {
		    group1Size = group1.size();
		  }
		  
		  int group2Size = -1;
		  if (group2!=null) {
		    group2Size = group2.size();
		  }
			
		  String retStr = "CINrequest: sessionId=" + getSessionId() + " taskId=" + getTaskId() + " group2Size=" + group2Size + " group1Size=" + group1Size;
		  
		  if (group1 != null) { 
		    retStr += " GRP1=" + group1.getGroupName();
		  }
		  
		  if (group2 != null) {
		    retStr += " GRP2=" + group2.getGroupName();
		  }
		  
		  return retStr;
	}
	
	public SampleGroup getGroup1() {
		return group1;
	}

	public void setGroup1(SampleGroup group1) {
		this.group1 = group1;
	}

	public SampleGroup getGroup2() {
		return group2;
	}

	public void setGroup2(SampleGroup group2) {
		this.group2 = group2;
	}
	
	/**
	 * Get the data file to be used to satisfy this request
	 * @return
	 */
	public String getCytobandsDataFileName() {
		return cytobandsDataFileName;
	}

	/**
	 * Set the data file to be used as input to the analysis
	 * @param dataFileName
	 */
	public void setCytobandsDataFileName(String cytobandsDataFileName) {
		this.cytobandsDataFileName = cytobandsDataFileName;
	}
	
	/**
	 * Get the data file to be used to satisfy this request
	 * @return
	 */
	public String getCytobandsAnnotationFileName() {
		return cytobandsAnnotationFileName;
	}

	/**
	 * Set the data file to be used as input to the analysis
	 * @param dataFileName
	 */
	public void setCytobandsAnnotationFileName(String cytobandsAnnotationFileName) {
		this.cytobandsAnnotationFileName = cytobandsAnnotationFileName;
	}

}

