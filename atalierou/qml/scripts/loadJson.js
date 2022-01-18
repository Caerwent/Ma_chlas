.pragma library
// This JavaScript resource is only
// ever loaded once by the engine,
// even if multiple instances of
// Calculator.qml are created.
function loadJSON(file, callback) {
    var xobj = new XMLHttpRequest();
    //xobj.overrideMimeType("application/json");
    xobj.open('GET', file, true);
    xobj.onreadystatechange = function () {
        if (xobj.readyState === XMLHttpRequest.DONE) {
            if (xobj.status === 200) {
                try{
                    var response = JSON.parse(xobj.responseText);
                    callback(response);
                }
                catch(e){
                    console.log("Error", e.name+" "+e.message);

                }

            } else {
                console.log("Error", xobj.statusText);
            }

        }
    };
    xobj.open("GET",file)
    xobj.send(null);
}
