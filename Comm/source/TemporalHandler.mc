using Toybox.Background;
using Toybox.Communications;
using Toybox.System;

using Toybox.ActivityMonitor;
using Toybox.Lang;


(:background)
class TemporalHandler extends System.ServiceDelegate 
{
    // When a scheduled background event triggers, make a request to
    // a service and handle the response with a callback function
    // within this delegate.
    
    function initialize() {
        ServiceDelegate.initialize();
        
        
    }
    
    function onTemporalEvent() 
    {
    	var prev = Background.getBackgroundData;
        var sensorIter = ActivityMonitor.getHeartRateHistory(null, false);
        var array = [];
        var previous = sensorIter.next();
        
        while (true) 
        {
		    var sample = sensorIter.next();
		    if (null != sample)
		    {                                           // null check
		        if (sample.heartRate != ActivityMonitor.INVALID_HR_SAMPLE    // check for invalid samples
		            && previous.heartRate
		            != ActivityMonitor.INVALID_HR_SAMPLE) {
		                //lastSampleTime = sample.when;
		                System.println("Previous: " + previous.heartRate);  // print the previous sample
		                System.println("Sample: " + sample.heartRate);      // print the current sample
		                array.add(sample.heartRate);
		        }
		    }
		}
        
        Background.exit(array);
        
    }
    
	// Create a method to get the SensorHistoryIterator object
	function getIterator(options) 
	{
	    return Toybox.SensorHistory.getHeartRateHistory(options);
	}
	
	
	

    
}