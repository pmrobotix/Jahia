$(document).ready(function() {

// set the date we're counting down to
  
var countdownDate = $('#countdownDate').text();
var target_date = new Date(countdownDate).getTime();

// get size (200 or 400)
var sizeCoef = 1;
var countdownSize = parseInt($('#countdownSize').text());

if (countdownSize = 200)
  sizeCoef = 2;
  
// variables for time units
var days, hours, minutes, seconds;
 
var $days = $("#days"),
    $hours = $("#hours"),
    $minutes = $("#minutes"),
    $seconds = $("#seconds");
  
var center = 200/sizeCoef,
    canvas = document.getElementById('timer'),
    ctx = canvas.getContext("2d"),
    daySetup = {
        radie:170/sizeCoef,
        lineWidth:30/sizeCoef,
        back:48/sizeCoef,
        color:"#306CED ",
        counter:0,
        old:0
    },
    hourSetup = {
        radie:130/sizeCoef,
        lineWidth:30/sizeCoef,
        back:48/sizeCoef,
        color:"#30AEED ",
        counter:0,
        old:0
    },
    minSetup = {
        radie:90/sizeCoef,
        lineWidth:30/sizeCoef,
        back:45/sizeCoef,
        color:"#30D4ED",
        counter:0,
        old:0
    },
    secSetup = {
        radie:50/sizeCoef,
        lineWidth:30/sizeCoef,
        back:65/sizeCoef,
        color:"#30EDE0",
        counter:0/sizeCoef,
        old:0
    },
    check = function(count, setup, ctx) {
        if (count < setup.old){
          setup.counter++
        }
        draw(setup.radie, setup.color, setup.lineWidth, count, ctx);
    },
    draw = function(radie, color, lineWidth, count, ctx) {
        ctx.beginPath();
        ctx.arc(center, center, radie, 0, count * Math.PI, false);
        ctx.lineWidth = lineWidth;
        ctx.strokeStyle = color;
        ctx.stroke();
    };
 
// update the tag with id "countdown" every 1 second
setInterval(function () {
    canvas.width = canvas.width;
    
    ctx.beginPath();
    ctx.arc(center, center, 50/sizeCoef, 0, 2 * Math.PI, false);
    ctx.lineWidth = 30/sizeCoef,
    ctx.fillStyle = 'transparent';
    ctx.fill();
  
    // find the amount of "seconds" between now and target
    var current_date = new Date().getTime();
    var seconds_left = (target_date - current_date) / 1000;
 
    // do some time calculations
    days = parseInt(seconds_left / 86400);
    seconds_left = seconds_left % 86400;
     
    hours = parseInt(seconds_left / 3600);
    seconds_left = seconds_left % 3600;
     
    minutes = parseInt(seconds_left / 60);
    seconds = parseInt(seconds_left % 60);
     
    $days.text(days);
    $hours.text(hours);
    $minutes.text(minutes);
    $seconds.text(seconds);

    var dayCount = (2 / 360) * days,
      hourCount = (2 / 24) * hours,
      minCount = (2 / 60) * minutes,
      secCount = (2 / 60) * seconds;
      
    check(secCount, secSetup, ctx);
    check(minCount, minSetup, ctx);
    check(hourCount, hourSetup, ctx);
    check(dayCount, daySetup, ctx);

    secSetup.old = secCount - 0.01;
    minSetup.old = minCount - 0.01;
    hourSetup.old = hourCount - 0.01; 
    daySetup.old = dayCount - 0.01; 

}, 1000);
});