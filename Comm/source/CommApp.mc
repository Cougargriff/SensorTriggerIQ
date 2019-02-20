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

using Toybox.SensorHistory;
using Toybox.Lang;

var page = 0;
var strings = ["","","","",""];
var stringsSize = 5;
var mailMethod;
var phoneMethod;
var crashOnMessage = false;
var HR = -1;
var HR_arr = [];

var candoBG = false;
var eventsTriggered = 0;

var STATUS = "OFF";

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
    	}
    	else if(s.find("OFF") != null)
    	{
    		STATUS = "OFF";
    	}
    	else if(s.find("test") != null)
    	{
    		test_history_send();
    	}
    	
    	
    	Ui.requestUpdate();
    	
    }
    
    function test_history_send()
    {
        var listener = new CommListener();
		Comm.transmit(HR_arr, null, listener);

    }
    
    
    
    function onHR(sensorInfo)
    {
    	HR = sensorInfo.heartRate;
    	//HR_arr.add(HR);
    	Ui.requestUpdate();
    }
    
    function onBackgroundData(data)
    {
    	eventsTriggered++;
    	HR_arr.addAll(data);
    	Ui.requestUpdate();
    }

    // onStart() is called on application start up
    function onStart(state) 
    {
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

    function onMail(mailIter) 
    {
        var mail;

        mail = mailIter.next();

        while(mail != null) 
        {
            var i;
            for(i = (stringsSize - 1); i > 0; i -= 1) 
            {
                strings[i] = strings[i-1];
            }
            strings[0] = mail.toString();
            page = 1;
            mail = mailIter.next();
        }

        Comm.emptyMailbox();
        Ui.requestUpdate();
    }

  
}