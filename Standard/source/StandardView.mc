import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Sensor;
import Toybox.Time.Gregorian;
import Toybox.Activity;

class StandardView extends WatchUi.WatchFace {
    
    var hrValue = 0.0f;
    var rectLength = 2;
    var rectWidth = 53;
    var x = 185;
    var y = 102;
    var batteryX = 198;
    var batteryY = 104;                  
    var verticalBatteryLines = 20;
    var horizontalBatteryLines = 40;
    var batteryState;
    var batteryDecrease = 6;
    var steps;
    var cals;
    var stepDisplay;
    var hrRecX = 0;
    var hrRecY = 190;
    var hrRecWidth = 35;
    var herRectheight = 5;
    var intMinutes;

    function initialize() {
        WatchFace.initialize();
        
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {

         // Get and show the current time
        var clockTime = System.getClockTime();
        var timeString = Lang.format("$1$:$2$", [clockTime.hour, clockTime.min.format("%02d")]);
        var view = View.findDrawableById("TimeLabel") as Text;
        view.setText(timeString);

        // Get the total steps for today and format it correctly
        steps = ActivityMonitor.getInfo().steps;
        var stepDisplay = View.findDrawableById("Steps") as Text;
        var stepsString = "Steps: " + steps.format("%d");
        stepDisplay.setText(stepsString);

        // Get the total Calories for today and format it correctly
        cals = ActivityMonitor.getInfo().calories;
        var calsDisplay = View.findDrawableById("Cals") as Text;
        var calsString = "Cals: " + cals.format("%d");
        calsDisplay.setText(calsString);

        // Get HeartRate value and format it correctly
        hrValue = Activity.getActivityInfo().currentHeartRate;
        var hrDisplay = View.findDrawableById("hrValue") as Text;
        if (hrValue != null){
            var hrString = "HR: " + hrValue.format("%d");
            hrDisplay.setText(hrString);
        } else {
            var hrString = "HR: --";
            hrDisplay.setText(hrString);
        }

        // Get the intensity minutes
        intMinutes = ActivityMonitor.getInfo().activeMinutesWeek.total;
        System.println(intMinutes);
        var intMinutesDisplay = View.findDrawableById("IntMinutes")  as Text;
        if (intMinutes != null){
            var intMinutesString = "Int Minutes: " + intMinutes.format("%d");
            intMinutesDisplay.setText(intMinutesString);  
        } else {
            var intMinutesString = "Int Minutes: --";
            intMinutesDisplay.setText(intMinutesString);  
        }
              
        
        //Get Day of the week
        var date = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        var dayOfWeek = View.findDrawableById("DayOfWeek") as Text;
        dayOfWeek.setText(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"][date.day_of_week - 1]);

        // Get the current battery percentage and format it correctly
        var systemStat = System.getSystemStats();
        batteryState = systemStat.battery;

        //Get the date of today
        var today = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
        var dayString = today.day.format("%d");
        var dayView = View.findDrawableById("DayOfMonth") as Text;
        dayView.setText(dayString);

        View.onUpdate(dc);
        
        // Draw Rect
        dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_BLACK);
        dc.fillRectangle(x, y, rectLength, rectWidth);   

        // Draw a battery to present battery Status
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.drawRectangle(batteryX, batteryY, horizontalBatteryLines, verticalBatteryLines);

        
        // Determine batttery color
        if (batteryState>70){
            dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_BLACK);
        }else if (batteryState > 30){
            dc.setColor(Graphics.COLOR_ORANGE, Graphics.COLOR_BLACK);
        }else {
            dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_BLACK);
        }
        dc.fillRectangle(batteryX + 2,  batteryY + 2, (horizontalBatteryLines-4)*batteryState/100, verticalBatteryLines-4);
        // Draw HR bars
        if(hrValue != null){
        
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.fillRectangle(hrRecX + hrRecWidth , hrRecY, hrRecWidth, herRectheight);

        dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_BLACK);
        dc.fillRectangle(hrRecX + hrRecWidth*2 + 5, hrRecY, hrRecWidth, herRectheight);

        dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_BLACK);
        dc.fillRectangle(hrRecX + hrRecWidth*3 + 10, hrRecY, hrRecWidth, herRectheight);

        dc.setColor(Graphics.COLOR_ORANGE, Graphics.COLOR_BLACK);
        dc.fillRectangle(hrRecX + hrRecWidth*4 + 15, hrRecY, hrRecWidth, herRectheight);

        dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_BLACK);
        dc.fillRectangle(hrRecX + hrRecWidth*5 + 20, hrRecY, hrRecWidth, herRectheight);
       
       
            if (hrValue.toNumber() >=154){
                    dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_BLACK);
                    dc.fillRectangle(hrRecX + hrRecWidth*5 + 20, hrRecY-2, hrRecWidth, herRectheight+4);             
            }else if (hrValue.toNumber() >=128){
                    dc.setColor(Graphics.COLOR_ORANGE, Graphics.COLOR_BLACK);
                    dc.fillRectangle(hrRecX + hrRecWidth*4 + 15, hrRecY-2, hrRecWidth, herRectheight+4);                
            }else if (hrValue.toNumber() >=102){
                    dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_BLACK);
                    dc.fillRectangle(hrRecX + hrRecWidth*3 + 10, hrRecY-2, hrRecWidth, herRectheight+4);
            }else if (hrValue.toNumber() >=76){
                    dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_BLACK);
                    dc.fillRectangle(hrRecX + hrRecWidth*2 + 5, hrRecY-2, hrRecWidth, herRectheight+4);
            }else if (hrValue.toNumber() >=50){
                    dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
                    dc.fillRectangle(hrRecX + hrRecWidth , hrRecY-2, hrRecWidth, herRectheight+4);
            }
 	    }

    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {

    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }

}
