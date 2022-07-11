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