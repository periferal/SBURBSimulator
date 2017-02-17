var players = [];

window.onload = function() {
    reroll();
}
function reroll(){
	makePlayers();
	describe();
}
function describe(){
	
	for(var i = 0; i<players.length; i++){
		decideTroll(players[i]);
		var intro = "";
		intro += "<h1> " + players[i].htmlTitle() +" </h1>"
		intro += "<ul>"
		intro += "<li> Land: " + players[i].land
		intro += "<li> Species: "
		if(players[i].isTroll){
			intro += "Troll"
		}else{
			intro += "Human"
		}
		intro += "<li>Blood Color:" 
		intro += "<font color= '" + players[i].bloodColor + "'> "
		intro +=  players[i].bloodColor + "</font>"
		if(players[i].isTroll && players[i].aspect == "Blood"){
			intro += " (Blood Player Default)";
		}
		if(players[i].bloodColor == "#610061"){
			intro += " (Seadweller) ";
		}else if(players[i].bloodColor == "#99004d"){
			intro += " (Heiress) ";
		}
		intro += "<li> Guardian: " + players[i].lusus
		
		intro += "<li> Moon: " +players[i].moon
		
		intro += "<Li> Defining Interests: " +getRandomElementFromArray(interests) + " and " + getRandomElementFromArray(interests);
		intro += "<Li>  Quirk: " + players[i].quirk.stringExplanation() +"</li>";
		intro += "Sample: " 
		if(players[i].isTroll){
			intro += "<font color= '" + players[i].bloodColor + "'> "
		}else{
			intro += getFontColorFromAspect(players[i].aspect)
		}
		intro += players[i].quirk.translate(" The quick brown fox (named Lacy) jumped over the lazy dog (named Barkey) over 1234567890 times for reasons. It sure was exciting! I wonder why he did that? Was he going to be late? I wonder....I guess we'll just have to wait and see.");
		intro += " <br><br> <div id = 'gibberish" +i+"'>"
		randomParagraph("#gibberish"+i, players[i]);
		intro += "</div></font>"
		
		intro += "</ul>"
		$("#player"+(i+1)).html(intro);
	}
}

function decideHemoCaste(player){
	if(player.aspect != "Blood"){  //sorry karkat
		player.bloodColor = getRandomElementFromArray(bloodColors);
	}
}

function decideLusus(player){
	if(player.bloodColor == "#610061" || player.bloodColor == "#99004d" || players.bloodColor == "#631db4" ){
		player.lusus = getRandomElementFromArray(seaLususTypes);
	}else{
		player.lusus = getRandomElementFromArray(landlususTypes);
	}
	
	
}

function randomParagraph(div, player){
	var url = "http://www.randomtext.me/api/gibberish/";
		$.get( url, function( data ) {
			//alert(data.text_out);
			$( div ).html( player.quirk.translate(data.text_out) );
		});
}

function decideTroll(player){
	if(Math.random() > .5){
		player.isTroll = true;
		decideHemoCaste(player);
		decideLusus(player);
		player.quirk = randomTrollQuirk();
	}else{
		player.quirk = randomHumanQuirk();
	}
}

function makePlayers(){
	players = [];
	available_classes = classes.slice(0); //re-init available classes. make deep copy
	available_aspects = nonrequired_aspects.slice(0);
	var numPlayers = 3;
	
	for(var i = 0; i<numPlayers; i++){
		players.push(randomPlayer());
	}
}