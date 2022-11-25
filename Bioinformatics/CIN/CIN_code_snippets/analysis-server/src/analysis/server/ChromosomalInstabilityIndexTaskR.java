package gov.nih.nci.caintegrator.analysis.server;


import java.util.HashSet;
import java.util.Iterator;
import java.util.Set;

import gov.nih.nci.caintegrator.analysis.messaging.*;
import gov.nih.nci.caintegrator.exceptions.AnalysisServerException;

import org.apache.log4j.Logger;
import org.rosuda.REngine.REXP;
import org.rosuda.REngine.Rserve.RFileInputStream;


/**
 * 
 * Performs Chromosomal Instability Index using R.
 * 
 * @author Lavinia A. Carabet
 *
 *
 */

public class ChromosomalInstabilityIndexTaskR extends AnalysisTaskR {

	private ChromosomalInstabilityIndexResult cinResult = null;
	public static final int MIN_GROUP_SIZE = 3;
	private static Logger logger = Logger.getLogger(ChromosomalInstabilityIndexTaskR.class);

	public ChromosomalInstabilityIndexTaskR(
			ChromosomalInstabilityIndexRequest request) {
		this(request, false);
	}

	public ChromosomalInstabilityIndexTaskR(
			ChromosomalInstabilityIndexRequest request, boolean debugRcommands) {
		super(request, debugRcommands);
	}

	public void run() {
		ChromosomalInstabilityIndexRequest request = (ChromosomalInstabilityIndexRequest)getRequest();
		SampleGroup sampleGroup1 = request.getGroup1();
		SampleGroup sampleGroup2 = request.getGroup2();
		
		try {
			
			String dataFileName = request.getDataFileName();
			if (dataFileName != null) {
			  setDataFile(request.getDataFileName());
			}
			else {
			  throw new AnalysisServerException("Null cin data file name");
			}
			
			//For now assume that there are two groups. When we get data for two channel array then
			//allow only one group so leaving in the possibility of having only one group in the code below
			
			
			int sampleGrp1Len = 0, sampleGrp2Len = 0;
			
			sampleGrp1Len = sampleGroup1.size();
			
			String sampleGrp1RName = sampleGroup1.getGroupName();
			sampleGrp1RName = getSampleGrpRName(sampleGrp1RName);
			String sampleGrp2RName = sampleGroup2.getGroupName();
			sampleGrp2RName = getSampleGrpRName(sampleGrp2RName);
			
			String rCmd = null;
		
			rCmd = getRgroupCmd(sampleGrp1RName, sampleGroup1);
	
			doRvoidEval(rCmd);
		
			if (sampleGroup2 != null) {
				// two group comparison
				sampleGrp2Len = sampleGroup2.size();
					
				rCmd = getRgroupCmd(sampleGrp2RName, sampleGroup2);
				doRvoidEval(rCmd);
		
				// create the input data matrix using the sample groups
				rCmd = "cinInputMatrix <- getSubmatrix.twogrps(dataMatrix,"
						+ sampleGrp2RName + "," + sampleGrp1RName + ")";
				doRvoidEval(rCmd);
		
				// check to make sure all identifiers matched in the R data file
				rCmd = "dim(cinInputMatrix)[2]";
				int numMatched = doREval(rCmd).asInteger();
				if (numMatched != (sampleGrp1Len + sampleGrp2Len)) {
					AnalysisServerException ex = new AnalysisServerException(
							"Some sample ids did not match R data file for cin request.");
					ex.setFailedRequest(request);
					setException(ex);
					logger.error(ex.getMessage());
					return;
				}
			} else {
				// single group comparison
//				baselineGrpLen = 0;
//				rCmd = "cinInputMatrix <- getSubmatrix.onegrp(dataMatrix,"
//						+ grp1RName + ")";
//				doRvoidEval(rCmd);
				logger.error("Single group cin is not currently supported.");
				throw new AnalysisServerException("Unsupported operation: Attempted to do a single group cin.");
			}
			
			cinResult = new ChromosomalInstabilityIndexResult(getRequest().getSessionId(), getRequest().getTaskId());
			String baseFileName = "cin_" + getRequest().getSessionId() + "_" + System.currentTimeMillis();	
			
			String heatMapFileName = "heatMap_" + baseFileName;
			rCmd = "clinical.inf <- as.matrix( cbind( dimnames(cinInputMatrix)[[2]], c( rep(" + "'" + sampleGrp2RName + "'," + sampleGrp2Len +"), rep(" + "'" + sampleGrp1RName + "'," + sampleGrp1Len +") ) ) )";
			logger.debug(rCmd);
			doRvoidEval(rCmd);
			rCmd = "heatmap.draw(cinInputMatrix, clinical.inf, heatmap.title=" + "'" + heatMapFileName + "'" +")";
			doRvoidEval(rCmd);
			
			RFileInputStream is = getRComputeConnection().openFile(heatMapFileName + ".png");
			byte[] heatMapFile = getBytes(is);
			is.close();
			
			cinResult.addCinFiles("heatmap", heatMapFile);
			getRComputeConnection().removeFile(heatMapFileName + ".png");
			
			dataFileName = request.getCytobandsDataFileName();
			if (dataFileName != null) {
			  setDataFile(request.getCytobandsDataFileName());
			}
			else {
			  throw new AnalysisServerException("Null cin cytobands data file name");
			}
			
			doRvoidEval("cinInputMatrix <- dataMatrix");
			
			dataFileName = request.getCytobandsAnnotationFileName();
			if (dataFileName != null) {
				setDataFile(request.getCytobandsAnnotationFileName());
			}
			else {
				throw new AnalysisServerException("Null annotation file name");
			}
			doRvoidEval("annotInputMatrix <- hg18_annot");
			
			String cytobandsFileName = null;
			
			for (int i = 1; i < 23; i++) {
				cytobandsFileName = "chr" + i + "_cytobands_" + baseFileName;
				rCmd = "cytobands_cin.draw(cinInputMatrix, clinical.inf, " + i + ", annotInputMatrix, title_text=" + "'" + cytobandsFileName + "'" +")";
				doRvoidEval(rCmd);
				
				is = getRComputeConnection().openFile(cytobandsFileName + ".png");
				byte[] cytobandsFile = getBytes(is);
				is.close();
				
				cinResult.addCinFiles(i+"", cytobandsFile);
				getRComputeConnection().removeFile(cytobandsFileName + ".png");
			}
			
		} catch (AnalysisServerException e) {
			e.setFailedRequest(request);
			logger.error("Internal Error. " + e.getMessage());
			logStackTrace(logger, e);
			setException(e);
			return;
		} catch (Exception ex) {
			AnalysisServerException asex = new AnalysisServerException(
					"Internal Error. Caught AnalysisServerException in ChromosomalInstabilityIndexTaskR." + ex.getMessage());
			asex.setFailedRequest(request);
			setException(asex);	        
			logStackTrace(logger, ex);
			return;  
		}

	}

	@Override
	public AnalysisResult getResult() {
		return cinResult;
	}

	/**
	 * Clean up some R memory and release and remove the 
	 * reference to the R connection so that this task can be 
	 * garbage collected.
	 */
	public void cleanUp() {
		try {
			setRComputeConnection(null);
		} catch (AnalysisServerException e) {
		   logger.error("Error in cleanUp method");
		   logStackTrace(logger, e);
		   setException(e);
		}
	}
	
	private String getSampleGrpRName(String sampleGrpName) {
		char[] invalidChars4R = new char[]{' ','*','?','~','[',']','"','+','-','<','>','#', '%','@','=','!','^','(',')','|','{','}','/','`',';','&',',','$',':','\'','\\'};
		sampleGrpName = sampleGrpName.trim();
		for (char w : invalidChars4R) {
		    if (sampleGrpName.indexOf(w) > -1) {
		    	sampleGrpName = sampleGrpName.replace(w, '_');
		    }
		}
		return sampleGrpName;
	}

}

