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

var page = 0;
var strings = ["","","","",""];
var stringsSize = 5;
var mailMethod;
var phoneMethod;
var crashOnMessage = false;
var HR = -1;

var STATUS = "OFF";

class CommExample extends App.AppBase 
{

    function initialize() 
    {
        App.AppBase.initialize();
        
        sensor.setEnabledSensors([Sensor.SENSOR_HEARTRATE]);
        sensor.enableSensorEvents(method(:onHR));
  
        if(Comm has :registerForPhoneAppMessages) 
        {
            Comm.registerForPhoneAppMessages(method(:onMsg));
        } 
        
    }
    
    function onMsg(msg)
    {
    	var s = msg.data.toString();
    	STATUS = s;
    	
    	var listener = new CommListener();
    		
			Comm.transmit(HR, null, listener);
		
    }
    
    
    
    function onHR(sensorInfo)
    {
    	HR = sensorInfo.heartRate;
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

    function onPhone(msg) 
    {
        var i;


        for(i = (stringsSize - 1); i > 0; i -= 1) 
        {
            strings[i] = strings[i-1];
        }
        strings[0] = msg.data.toString();
        page = 1;

        Ui.requestUpdate();
    }

}