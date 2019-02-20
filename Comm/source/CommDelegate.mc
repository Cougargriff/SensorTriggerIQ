//
// Copyright 2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Communications as Comm;
using Toybox.Sensor as sensor;

class CommListener extends Comm.ConnectionListener 
{
    function initialize() 
    {
        Comm.ConnectionListener.initialize();
    }

    function onComplete() 
    {
        Sys.println("Transmit Complete");
        
        HR_arr = [];
    }

    function onError() 
    {
        Sys.println("Transmit Failed");
    }
}

class CommInputDelegate extends Ui.BehaviorDelegate 
{
    function initialize() 
    
    {
        Ui.BehaviorDelegate.initialize();
    }

    function onMenu() 
    {
        var menu = new Ui.Menu();
        var delegate;

        menu.addItem("Send Heart Rate", :sendData);
        delegate = new BaseMenuDelegate();
        Ui.pushView(menu, delegate, SLIDE_IMMEDIATE);

        return true;
    }

    function onTap(event) 
    {
        if(page == 0) 
        {
            page = 1;
        } 
        else 
        {
            page = 0;
        }
        Ui.requestUpdate();
    }
}

class BaseMenuDelegate extends Ui.MenuInputDelegate 
{
    function initialize() 
    {
        Ui.MenuInputDelegate.initialize();
    }

    function onMenuItem(item) 
    {
        var menu = new Ui.Menu();
        var delegate = null;
        
        var listener = new CommListener();

        if(item == :sendData) 
        {
            Comm.transmit(HR, null, listener);
        } 
       
    }
}

//class SendMenuDelegate extends Ui.MenuInputDelegate 
//{
//    function initialize() 
//    {
//        Ui.MenuInputDelegate.initialize();
//    }
//
//    function onMenuItem(item) 
//    {
//        var listener = new CommListener();
//
//        if(item == :hello) 
//        {
//            Comm.transmit("Hello World.", null, listener);
//        }
//        else if(item == :hr) 
//        {        	
//        	
//        }
//
//        Ui.popView(SLIDE_IMMEDIATE);
//    }
//}

//class ListnerMenuDelegate extends Ui.MenuInputDelegate 
//{
//    function initialize() 
//    {
//        Ui.MenuInputDelegate.initialize();
//    }
//
//    function onMenuItem(item) 
//    {
//        if(item == :mailbox) 
//        {
//            Comm.setMailboxListener(mailMethod);
//        } 
//        else if(item == :phone) 
//        {
//            if(Comm has :registerForPhoneAppMessages) 
//            {
//                Comm.registerForPhoneAppMessages(phoneMethod);
//            }
//        } 
//        else if(item == :none) 
//        {
//            Comm.registerForPhoneAppMessages(null);
//            Comm.setMailboxListener(null);
//        } 
//        else if(item == :phoneFail) 
//        {
//            crashOnMessage = true;
//            Comm.registerForPhoneAppMessages(phoneMethod);
//        }
//
//        Ui.popView(SLIDE_IMMEDIATE);
//    }
//}

