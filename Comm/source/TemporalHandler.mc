using Toybox.Background;
using Toybox.Communications;
using Toybox.System;
using Toybox.Time;

using Toybox.ActivityMonitor;
using Toybox.Lang;
using Toybox.Application as App;

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
    	System.println("Starting Background Service");
    	var prev = Background.getBackgroundData();
    	var dict = {};
    	
    	var last_time = App.AppBase.getProperty("last_time");
    	System.println("last time = " + last_time);
    	
    	/*
    	if(prev != null)
    	{
    		var prev_keys = prev.keys;
    		for(var i = 0; i < prev_keys.size(); i++)
    		{
    			var key = prev_keys[i];
    			dict.put(key, prev.get(key));
    		}
    	}
    	else
    	{
    		// check for application data in storage
    	}
    	*/
        var sensorIter = ActivityMonitor.getHeartRateHistory(null, false);
        if(null == sensorIter)
        {
        	System.println("Error");
        	Background.exit(prev);
        }
        

        var count = 1;
        var sample = sensorIter.next();

        while(sample != null)
        {
	        if (sample.heartRate != ActivityMonitor.INVALID_HR_SAMPLE) 
			{
				// putting time and hr value into dictionary
				var when = sample.when.value();
		        dict.put(when, sample.heartRate);
		        System.println("added to array");
	        	count++;
	        	sample = sensorIter.next();
			}
			else
			{
				System.println("error");
				break;
			}
	        
        	
        }
        System.println("Number of data points received = " + count);
        System.println(dict);
        
        System.println("Trying to exit");
        
        Background.exit(dict);
        
    }
    
	// Create a method to get the SensorHistoryIterator object
	function getIterator(options) 
	{
	    return Toybox.SensorHistory.getHeartRateHistory(options);
	}
	
 
}