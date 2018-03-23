import '../../SBURBSim.dart';
import '../../navbar.dart';
import 'dart:async';
import 'dart:html';
import 'dart:typed_data';
import 'dart:collection';

//TODO: have custom intro tick and aftermath. make dead sessions have X number of planets depending on theme.
class DeadSimController extends SimController {
  DeadSimController() : super();



  @override
  void startSession([bool keepSession = false]) {
    globalInit(); // initialise classes and aspects if necessary

    // //
    if(!keepSession)curSessionGlobalVar = new DeadSession(initial_seed);
    changeCanonState(getParameterByName("canonState",null));
    //  //
    reinit();
    ////
    curSessionGlobalVar.makePlayers();
    ////
    curSessionGlobalVar.randomizeEntryOrder();
    //authorMessage();
    curSessionGlobalVar.makeGuardians(); //after entry order established
    //easter egg ^_^
    if (getParameterByName("royalRumble", null) == "true") {
      debugRoyalRumble();
    }

    if (getParameterByName("COOLK1D", null) == "true") {
      cool_kid = true;
      coolK1DMode();
    }

    if (getParameterByName("pen15", null) == "ouija") {
      pen15Ouija();
    }



    if (getParameterByName("faces", null) == "off") {
      faceOffMode();
    }

    if (getParameterByName("tier", null) == "cod") {
      bardQuestMode();
    }

    if (getParameterByName("lollipop", null) == "true") {
      tricksterMode();
    }

    if (getParameterByName("robot", null) == "true") {
      roboMode();
    }

    if (getParameterByName("sbajifier", null) == "true") {
      sbahjMode();
    }

    if (getParameterByName("babyStuck", null) == "true") {
      babyStuckMode();
    }

    checkEasterEgg(easterEggCallBack, null);
  }

  @override
  void easterEggCallBack() {
    DeadSession ds = (curSessionGlobalVar as DeadSession);
    initializePlayers(curSessionGlobalVar.players, curSessionGlobalVar); //will take care of overriding players if need be.
    //has to happen here cuz initializePlayers can wipe out relationships.
    ds.players[0].deriveLand = false;
    //ds.players[0].relationships.add(new Relationship(ds.players[0], -999, ds.metaPlayer)); //if you need to talk to anyone, talk to metaplayer.
    //ds.metaPlayer.relationships.add(new Relationship(ds.metaPlayer, -999, ds.players[0])); //if you need to talk to anyone, talk to metaplayer.

    checkSGRUB();
    if (doNotRender == true) {
      intro();
    } else {
      load(curSessionGlobalVar.players, getGuardiansForPlayers(curSessionGlobalVar.players), "");
    }
  }

  @override
  void reckoning() {
    ////
    Scene s = new DeadReckoning(curSessionGlobalVar);
    s.trigger(curSessionGlobalVar.players);
    s.renderContent(curSessionGlobalVar.newScene(s.runtimeType.toString(),));
    renderAfterlifeURL();
  }

  @override
  void processCombinedSession() {
      //guaranteed to make one since it's a dead session
      curSessionGlobalVar.players[0].relationships.clear(); //forgot about that annoying voice in your head.
      Session tmpcurSessionGlobalVar = curSessionGlobalVar.initializeCombinedSession();
      SimController.instance = null;
      new StoryController();
      doComboSession(tmpcurSessionGlobalVar);

  }


  @override
  void callNextIntro(int player_index) {

    if (player_index >= curSessionGlobalVar.players.length) {
      tick(); //NOW start ticking
      return;
    }
    DeadIntro s = new DeadIntro(curSessionGlobalVar);
    Player p = curSessionGlobalVar.players[player_index];
    //var playersInMedium = curSessionGlobalVar.players.slice(0, player_index+1); //anybody past me isn't in the medium, yet.
    List<Player> playersInMedium = curSessionGlobalVar.players.sublist(0, player_index + 1);
    s.trigger(<Player>[p]);
    s.renderContent(curSessionGlobalVar.newScene(s.runtimeType.toString())); //new scenes take care of displaying on their own.
    curSessionGlobalVar.processScenes(playersInMedium);
    //player_index += 1;
    //new Timer(new Duration(milliseconds: 10), () => callNextIntro(player_index)); //sweet sweet async
    this.gatherStats();
    tick();
  }

  @override
  void doComboSession(Session tmpcurSessionGlobalVar) {
    int id = curSessionGlobalVar.session_id;

    if(tmpcurSessionGlobalVar == null) tmpcurSessionGlobalVar = curSessionGlobalVar.initializeCombinedSession();  //if space field this ALWAYS returns something. this should only be called on null with space field
      curSessionGlobalVar = tmpcurSessionGlobalVar;
      //maybe ther ARE no corpses...but they are sure as shit bringing the dead dream selves.
      List<Player> living = findLiving(curSessionGlobalVar.aliensClonedOnArrival);
     //window.alert("doing combo session in dead, cloned aliens: ${living.length}");

    if(living.isEmpty) {
          appendHtml(SimController.instance.storyElement, "<br><Br>You feel a nauseating wave of space go over you. What happened? Wait. Fuck. That's right. The Space Player made it so that they could enter their own child Session. But. Fuck. Everybody is dead. This...god. Maybe...maybe the other Players can revive them? ");
      }else {
          appendHtml(SimController.instance.storyElement, "<br><Br> Entering: session <a href = 'index2.html?seed=${curSessionGlobalVar.session_id}'>${curSessionGlobalVar.session_id}</a>");
      }
      checkSGRUB();
      if(curSessionGlobalVar.mutator.spaceField) {
          window.scrollTo(0, 0);
          querySelector("#charSheets").setInnerHtml("");
          SimController.instance.storyElement.setInnerHtml("You feel a nauseating wave of space go over you. What happened? Huh. Is that.... a new session? How did the Players get here? Are they joining it? Will...it...even FIT having ${curSessionGlobalVar.players.length} fucking players inside it? ");
      }
      if(id == 4037) {
        window.alert("Who is Shogun???");
        curSessionGlobalVar.session_id = 13;
        //okay well this is an entire new priority now that i notice who is dying. i'm so sorry sb.
/*holy fuck nothing i do keeps us from dying. oh well.
        for(Player p in curSessionGlobalVar.players) {
          p.addStat(Stats.HEALTH, 100);
          p.makeAlive(); //why is this necessary, shogun stop killing us before you even get in.
        }*/
      }
      if(id ==612) curSessionGlobalVar.session_id = 413;

      SimController.instance.startSession(true);
  }

  @override
  void shareableURL() {
    String params = window.location.href.substring(window.location.href.indexOf("?") + 1);
    if (params == window.location.href) params = "";
    String str = '<div class = "links"><a href = "dead_index.html?seed=$initial_seed&$params">Shareable URL </a> &nbsp&nbsp&nbsp&nbsp &nbsp&nbsp&nbsp&nbsp <a href = "character_creator.html?seed$initial_seed&$params" target="_blank">Replay Session  </a> &nbsp&nbsp&nbsp&nbsp &nbsp&nbsp&nbsp&nbsp<a href = "dead_index.html">Random Session URL </a> </div>';
    setHtml(querySelector("#seedText"), str);
    SimController.instance.storyElement.appendHtml("Session: $initial_seed", treeSanitizer: NodeTreeSanitizer.trusted);
  }


}


class StoryController extends SimController {
    StoryController() : super();
}