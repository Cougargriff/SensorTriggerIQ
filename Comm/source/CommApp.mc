//
// Copyright 2015-2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.Application as App;
using Toybox.Communications as Comm;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Sensor as sensor;
using Toybox.Time;

using Toybox.SensorHistory;
using Toybox.Lang;

var page = 0;
var strings = ["","","","",""];
var stringsSize = 5;
var mailMethod;
var phoneMethod;
var crashOnMessage = false;
var HR = -1;
var HR_hash = {};

var candoBG = false;
var eventsTriggered = 0;

var STATUS = "OFF";
const FIVE_MINUTES = new Time.Duration(5 * 60);

class CommExample extends App.AppBase 
{

    function initialize() 
    {
        App.AppBase.initialize();
        
        if(Comm has :registerForPhoneAppMessages) 
        {
            Comm.registerForPhoneAppMessages(method(:onMsg));
        } 
        
        sensor.setEnabledSensors([Sensor.SENSOR_HEARTRATE]);
        sensor.enableSensorEvents(method(:onHR));
                
        if(Toybox.System has :ServiceDelegate)
        {
        	candoBG = true;
        	Background.registerForTemporalEvent(new Time.Duration( (5 * 60) + 20));
        }
        else
        {
  			Sys.println("** no background");
  		}
        
    }
    
    // Create a method to get the SensorHistoryIterator object
	function getIterator(options) 
	{
	    return Toybox.SensorHistory.getHeartRateHistory(options);
	}
    
    function getServiceDelegate()
    {
    	return [new TemporalHandler()];
    }
    
    function onMsg(msg)
    {
    	var s = msg.data.toString();
    	
    	if(s.find("ON") != null)
    	{
    		STATUS = "ON";
    		if(candoBG == true)
    		{
    			Background.registerForTemporalEvent(new Time.Duration( (5 * 60) + 20));
    			System.println("started temporal event");
    		}
        	
    	}
    	else if(s.find("OFF") != null)
    	{
    		STATUS = "OFF";
    	}
    	else if(s.find("sync") != null)
    	{
    		test_history_send();
    	}
    	
    	
    	Ui.requestUpdate();
    	
    }
    
    function test_history_send()
    {
        var listener = new CommListener();
		Comm.transmit(HR_hash, null, listener);
		
		eventsTriggered = 0;
		Ui.requestUpdate();
    }
    
    
    
    function onHR(sensorInfo)
    {
    	HR = sensorInfo.heartRate;
    	var curr_time = Time.now().value();
    	HR_hash.put(curr_time, sensorInfo.heartRate);
    	App.AppBase.setProperty("last_time", curr_time); // update last received time
    	Ui.requestUpdate();
    }
    
    function onBackgroundData(data)
    {
    	// TODO : trigger code.
    	eventsTriggered++;
    	concatHash(data);
    	System.println(HR_hash);
    	Ui.requestUpdate();
    }

    // onStart() is called on application start up
    function onStart(state) 
    {
    	// todo check current day over previous day
    	// if compare today and current day >  1 day
    	// 		set current day = today
    	//		set data = {}
    	
    	
    }
    
    function concatHash(hash)
    {
    	var keys = hash.keys();
		for(var i = 0; i < keys.size(); i++)
		{
			var key = keys[i];
			HR_hash.put(key, hash.get(key));
		}
    }

    // onStop() is called when your application is exiting
    function onStop(state) 
    {
    }

    // Return the initial view of your application here
    function getInitialView() 
    {
        return [new CommView(), new CommInputDelegate()];
    }

 
}