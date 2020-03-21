function createAgent(x, y) {
    var element=document.createElement("div");
    element.setAttribute("class", "agent");
    element.setAttribute("style", "left:"+x+"px;top:"+y+"px;");
    document.getElementById("view-panel").appendChild(element);
    return element;
};

function addAgent() {
    createAgent(Math.random()*500, Math.random()*500);
};

function initialize(population) {
	for(var i=0; i<population; i++) {
    	addAgent();
    };
}

window.onload = function() {
    var popSlider = document.getElementById("popSlider");
    initialize(popSlider.value); // Initialize with the default population

	var output = document.getElementById("output");
	output.innerHTML = popSlider.value; // Display the default slider value
	popSlider.oninput = function() {
  		output.innerHTML = this.value;
	}

	document.getElementById("reset-button").onclick = function() {
		document.getElementById("view-panel").innerHTML='';
    	initialize(popSlider.value); 
	};

};


