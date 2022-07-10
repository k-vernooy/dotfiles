function fillTime() {
    var time = document.getElementById("time");
    var d = new Date();

    var h = (d.getHours()<10?'0':'') + d.getHours(),
        m = (d.getMinutes()<10?'0':'') + d.getMinutes();
        s = (d.getSeconds()<10?'0':'') + d.getSeconds();
    
    document.getElementById("hour").innerText = h;
    document.getElementById("minute").innerText = m;
    document.getElementById("second").innerText = s;
}


function checkHidden() {
    const localStorageHidden = localStorage.getItem("hidden");
    
    var time = document.getElementById("time");
    
    if (localStorageHidden !== null && localStorageHidden == "true") {
        time.classList.remove("hidden");
    }
    else {
        time.classList.add("hidden");
    }
}


function showHideSeconds() {
    if (localStorage.getItem("hidden") == "false") {
        localStorage.setItem("hidden", "true");
    }
    else {
        localStorage.setItem("hidden", "false");
    }

    checkHidden();
}


fillTime();
checkHidden();

setInterval(function() {
    fillTime();
}, 900);

setInterval(function() {
    checkHidden();
}, 100);


// function sleep(ms) {
//     return new Promise(resolve => setTimeout(resolve, ms));
// }

// // function stringifyEl(el, truncate) {
// //     var truncateLen = truncate || 50;
// //     var outerHTML = el.outerHTML;
// //     var ret = outerHTML;
// //     ret = ret.substring(0, truncateLen);

// //     // If we've truncated, add an elipsis.
// //     if (outerHTML.length > truncateLen) {
// //       ret += "...";
// //     }
// //     return ret;
// // }

// async function titleFade() {
    
//     for ( var x = 0; x < document.getElementsByClassName("upText").length; x++ ){
//         var text = "";
//         for ( var i = 0; i < document.getElementsByClassName("upText")[x].childNodes.length; i++ ) {
//             var el = document.getElementsByClassName("upText")[x].childNodes[i];
//             for ( var j = 0; j < el.length; j++ ) {
//                 var str = new XMLSerializer().serializeToString(el).charAt(j);
//                 if ( str == " " ) {
//                     text += "<span>&nbsp;</span>"
//                 }
//                 else {
//                     text += "<span>" + str + "</span>"
//                 }
//             }
//         }

//         document.getElementsByClassName("upText")[x].removeChild(document.getElementsByClassName("upText")[x].childNodes[0])
//         var app = document.createElement("div");
//         app.innerHTML = text;
//         document.getElementsByClassName("upText")[x].appendChild(app);
//     }
//     await sleep(2000);
    
//     for ( var i = 0; i < document.getElementById("title").childNodes.length; i++ ) {
//         var el = document.getElementById("title").childNodes[i];
//         el.className += " animateUpOn";
//         console.log(el);
//         console.log("two");
//         await sleep(180);
//         // if ( el.childNodes[0].id == "moonImg" ) {
//         //     // console.log(el);

//         //     el.style.position = "fixed";
//         // }
//     }	

//     await sleep(700);



//     for ( var x = 0; x < document.getElementsByClassName("upText").length; x++ ){
//         if ( x == 0 ) {
//             var div = document.getElementsByClassName("upText")[x].childNodes[0];

//             for ( var i = 0; i < div.childNodes.length; i++ ) {
//                 div.childNodes[i].className += " animateUpOn";
//                 await sleep(10);
//             }
//             await sleep(1500);

//             for ( var i = 0; i < div.childNodes.length; i++ ) {
//                 div.childNodes[i].className = "";
//                 div.childNodes[i].className = "animateUpOut";
//                 await sleep(10);
//             }
//         }
//         else {
//             var div = document.getElementsByClassName("upText")[x].childNodes[0];

//             for ( var i = 0; i < div.childNodes.length; i++ ) {
//                 div.childNodes[i].className += " animateUpOn";
//                 await sleep(10);
//             }
//         }
//     }
// }

// titleFade();

// async function titleFadeOut() {
//     for ( var i = 0; i < document.getElementById("title").childNodes.length; i++ ) {
//         var el = document.getElementById("title").childNodes[i];
//         // console.log();
//         if ( !el.childNodes[0].id ) {
//             el.className += " animateUpOut";
//             await sleep(80);
//         }
//     }	

//     for ( var i = 0; i < document.getElementsByClassName("upText")[1].childNodes[0].childNodes.length; i++ ) {
//         var el = document.getElementsByClassName("upText")[1].childNodes[0].childNodes[i];
//         el.className += " animateUpOut";
//         await sleep(20);
//     }	
// }

// async function moonZoom() {
//     document.getElementById("moonImg").className += " moonScale"
// }