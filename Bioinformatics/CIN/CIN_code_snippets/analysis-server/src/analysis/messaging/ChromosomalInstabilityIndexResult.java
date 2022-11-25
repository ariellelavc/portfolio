package gov.nih.nci.caintegrator.analysis.messaging;

import java.util.*;

/**
 * ChromosomalInstabilityIndexResults are in image form
 * @author Lavinia A. Carabet
 *
 */

public class ChromosomalInstabilityIndexResult extends AnalysisResult implements java.io.Serializable {

	private static final long serialVersionUID = -155937074300496539L;
	
	private Map<String, byte[]> cinFiles = Collections.synchronizedMap(new LinkedHashMap<String, byte[]>());
	
	public ChromosomalInstabilityIndexResult(String sessionId, String taskId) {
		super(sessionId, taskId);
	}
	
	public String toString() {
	  return "ChromosomalInstabilityIndexResult: sessionId=" + getSessionId() + " taskId=" + getTaskId();
	}
	
	public Map<String, byte[]> getCinFiles() {
		return cinFiles;
	}

	public void setCinFiles(Map<String, byte[]> cinFiles) {
		this.cinFiles = cinFiles;
	}
	
	public void addCinFiles(String key, byte[] cinFile) {
		cinFiles.put(key, cinFile);
	}

}

