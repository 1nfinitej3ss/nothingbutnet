//test user idcqxbi_fallersen_1473865936@tfbnw.net  

import processing.video.*;
import processing.sound.*;

int interval = 25000;//timer's interval
int lastRecordedTime = 0;
int interval2 = 15000;//timer's interval

Movie scene1Video;
Movie scene2Video;
SoundFile soundfile;
SoundFile pressPSound;
SoundFile orgasm;

//FYI: a "choreo" is Temboo's term for a series of functions that do work with an API.

//import Temboo libraries (Facebook API)
import com.temboo.core.*;
import com.temboo.Library.Facebook.OAuth.*;
import com.temboo.Library.Facebook.Reading.*;

//Create a session using your Temboo account application details
TembooSession session = new TembooSession("privatehq", "myFirstApp", "CCLEmA4kiZvcVxvBtUXga4lnaNJHtKfY");

//text to speech
String statusScript;
String allMessages[];
String textFile;
int inc;
int voiceIndex;
int voiceSpeed;
boolean startTalking;
boolean getNewWords;

PFont f;
PImage img;  // Declare variable "a" of type PImage


//wordcram
import wordcram.*;
WordCram wordCram;

boolean scene1;
boolean scene2;
boolean scene2Int;
boolean scene3;
boolean scene3Int;
boolean scene1Sensor;
boolean firstTime;
boolean pressK;
boolean pressKInt;
boolean pressP;
boolean pressPInt;
boolean restart;

//good stuff
String authURL;
String callbackID;
String accessToken;
String nextPage;
String intMsg;
String userData;
int msgCount;
int pgCount;
boolean feedEnd; 

JSONObject feed;
PrintWriter output;
PrintWriter output2;

void setup() {
  //size(640, 360);


  fullScreen();
  background(0);
  scene1=true;
  scene2=false;
  scene2Int=true;
  scene3=false;
  scene3Int=true;
  scene1Sensor=false;
  firstTime=true;
  pressK=false;
  pressKInt=true;
  pressP=false;
  pressPInt=true;
  restart=true;
  inc =0;

  //load video
  scene1Video = new Movie(this, "part1.mp4");
  scene2Video = new Movie(this, "part1sm.mov");
  println(scene1Video.duration());

  //Load a soundfile
  pressPSound = new SoundFile(this, "pressP.aif");
  orgasm = new SoundFile(this, "orgasm.aif");

  img = loadImage("login.png");  // Load the image into the program  

  //Initialize variables
  feedEnd=false;
  msgCount=0;
  pgCount=1;


  //textospeech
  getNewWords=true;
  noCursor();
}

void draw() {

  if (restart) {
    surface.setAlwaysOnTop(true);
    //on top but not in focus

    // Load and play the video in a loop
    //println("start over");
    scene1Video.loop();
    image(scene1Video, 0, 0, width, height);

    //did the interval' time pass?
    if (millis()-lastRecordedTime>interval) {
      //change FILL color
      statusScript = "up my keys UP my arrow key it's OKAY to touch";
      TextToSpeech.say(statusScript, TextToSpeech.voices[voiceIndex], voiceSpeed);
      //and record time for next tick
      lastRecordedTime = millis();
    }
  }

  if (pressK) {
    scene1Video.pause();
    feedEnd=false;
    //scene1Video.pause();
    surface.setAlwaysOnTop(false);
    runInitializeOAuthChoreo();
    delay(100);
    link(authURL);
    statusScript = "hehehehe that feels so good hehehe k";
    TextToSpeech.say(statusScript, TextToSpeech.voices[voiceIndex], voiceSpeed);
    delay(5000);
    statusScript = "login login login i’m looking for love login login login i’m looking for love trust me do you trust me love me login me";
    TextToSpeech.say(statusScript, TextToSpeech.voices[voiceIndex], voiceSpeed);
    delay(15000);
    statusScript = "LOOK LOOK LOOK LOOK at the keyboard and PRESS MY EYES THIS IS HOW YOU WILL CLOSE THE BROWSER ASAP AS SOON AS POSSIBLE PRESS MY EYES yellow in disguise";
    TextToSpeech.say(statusScript, TextToSpeech.voices[voiceIndex], voiceSpeed);
    delay(20000);
    pressK=false;
    scene2=true;
  }


  if (scene2) {
    //orgasm.loop();
    try { 
      statusScript = "I AM PROCESSING processing your net time stories";
      TextToSpeech.say(statusScript, TextToSpeech.voices[voiceIndex], voiceSpeed);
      delay(5000);
      runFinalizeOAuthChoreo();
      runProfileFeedChoreo();
      scene2=false;
      scene2Int=false;
      scene3=true;
    }   
    catch(NullPointerException e) {
      println("no Login received");
      //quite firefox
      restart=true;
      pressK=false;
      scene2=false;
    }
  }


  if (scene3 && scene3Int) {
    //talk 
    getNewWords=true;
    talkToMe();
  }
}

void movieEvent(Movie m) {
  m.read();
}

void keyPressed() {
  if (keyCode == UP) {
    //scene1Sensor=true;
    pressK=true;
    restart=false;
  }
  //if (keyCode == DOWN) {
  // scene1Sensor=false;
  //scene1=true;
  //}
  if (keyCode ==DOWN) {
    pressK=true;
  }
  if (key =='p') {
    pressP=true;
  }
}


//collects facebook user messages from all time
void runProfileFeedChoreo() {
  //Create the Choreo object using your Temboo session
  ProfileFeed profileFeedChoreo = new ProfileFeed(session);
  User userChoreo = new User(session);

  //Set inputs
  profileFeedChoreo.setEdge("posts"); //retrieves posts; other options include photos, etc
  profileFeedChoreo.setFields("message"); //retrieves "message type posts"
  profileFeedChoreo.setAccessToken(accessToken); //accessToken is generated by runInitializeOAuthChoreo function 
  userChoreo.setAccessToken(accessToken);
  println(accessToken);

  //Unused Inputs
  //profileFeedChoreo.setSince("2000"); 
  //profileFeedChoreo.setOffset("2"); //offsets result by setLimit amount
  //profileFeedChoreo.setLimit("50"); //maxes at 300 or something, only useful if setting small limits.
  println("test3");

  //Run the Choreo and store the results
  ProfileFeedResultSet profileFeedResults = profileFeedChoreo.run();
  UserResultSet userResults = userChoreo.run();

  //Print raw results  
  //println(profileFeedResults.getResponse()); //gets max allowed amount of results  
  //println(profileFeedResults.getHasNext());  //indicates there are additional results beyond max (or setLimit)
  //println(userResults.getResponse());
  userData = userResults.getResponse();
  println(userData);

  //Parse results 
  feed = parseJSONObject(profileFeedResults.getResponse()); //Load the JSON file as a JSON object
  JSONArray data = feed.getJSONArray("data"); //Store the JSON Object content as an array

  //Print parsed results
  //println(feed);
  println("# of Results: "+data.size()+" FYI: next results may be available");

  //create text file for printWriter object - FYI: output.println below fails if this is in setup - weird.
  String fileName1 = "data/messagesOnly" + inc + ".txt";
  String fileName2 = "data/userFeed"+inc+".txt";
  //find me
  output = createWriter(fileName1);
  output2 = createWriter(fileName2);
  textFile = fileName1;

  //Step through the array and load the messages 
  for (int i = 0; i < data.size (); i++) {

    JSONObject post = data.getJSONObject(i);

    //not all post message types actually have a message, (i.e. a link), if/else statement culling just those posts with actual message content
    if (post.isNull("message") == true) {    
      i++;                                                    //if no message,  keep going through array
    } else {
      String createdTime = post.getString("created_time");  //save for later, may want to cull timestamp of message
      intMsg = post.getString("message");                     //get the message, store as intMsg
      String userFeed = "user:"+userData+" time: "+createdTime+" message: "+intMsg; //String date = createdTime.substring(0, 10);           //culls date sans time
      output.println(intMsg);                                 //print message to text file
      output2.println(userFeed);                                 //print message to text file
      msgCount++;                                             //keep track of how many messages we are storing
    }
  }

  //*IMPORTANT* After collecting all messages looks to see if there is more via "next" page
  JSONObject paging = feed.getJSONObject("paging");
  String next = paging.getString("next");
  nextPage = next;

  runTheRest();
}

void runTheRest() {
  if (!feedEnd) {
    println("Storing results from page #"+pgCount);
    pgCount++;
     if (millis()-lastRecordedTime>interval2) {
      //change FILL color
    statusScript = "please wait I AM still PROCESSING processing your net time stories";
    TextToSpeech.say(statusScript, TextToSpeech.voices[voiceIndex], voiceSpeed);
      //and record time for next tick
      lastRecordedTime = millis();
     }
    runNextPage();
  } else {
    println("**END OF USER FB FEED**");
  }
}

void runNextPage() {

  // Create the Choreo object using your Temboo session
  Paginate paginateChoreo = new Paginate(session);

  // Set inputs
  paginateChoreo.setURL(nextPage);               // nextPage is the URL we grab from end of the feed results, it indicates more results on a next page

  // Run the Choreo and store the results
  PaginateResultSet paginateResults = paginateChoreo.run();

  //print results
  //println(paginateResults.getResponse());
  //println(paginateResults.getHasNext());
  //println(paginateResults.getHasPrevious());  // you can step back through results too

  //Parse results 
  feed = parseJSONObject(paginateResults.getResponse()); //Load the JSON file as a JSON object
  JSONArray data = feed.getJSONArray("data"); //Store the JSON Object content as an array

  //Print parsed results
  //println(feed);
  //println("# of Results: "+data.size()+" FYI: next results may be available");

  //Step through the array and load the messages 
  for (int i = 0; i < data.size (); i++) {

    JSONObject post = data.getJSONObject(i);

    //not all post message types actually have a message, (i.e. a link), if/else statement culling just those posts with actual message content
    if (post.isNull("message") == true) {    
      i++;                                                    //if no message,  keep going through array
    } else {
      String createdTime = post.getString("created_time");  //save for later, may want to cull timestamp of message
      intMsg = post.getString("message");                     //get the message, store as intMsg
      String userFeed = "user:"+userData+" time: "+createdTime+" message: "+intMsg; //String date = createdTime.substring(0, 10);           //culls date sans time
      output.println(intMsg);                                 //print message to text file
      output2.println(userFeed);                                 //print message to text file
      msgCount++;                                             //keep track of how many messages we are storing
    }
  }

  //looks for next page of feed (a URL that is stored as nextPage)
  try {
    JSONObject paging = feed.getJSONObject("paging"); 
    String next = paging.getString("next");
    nextPage = next;
  }

  //if no "next" page is found, we mark the end of the feed
  catch (Exception e) { 
    feedEnd=true;
    println("Total Results: "+msgCount);
    msgCount = 0;
    pgCount = 0;
    closeTextFile();                           //necessary to properly save text file
  }

  //pop us back in a loop looking for feedEnd true or not
  runTheRest();
}


void runInitializeOAuthChoreo() {
  callbackID="";
  // Create the Choreo object using your Temboo session
  InitializeOAuth initializeOAuthChoreo = new InitializeOAuth(session);

  // Set credential
  initializeOAuthChoreo.setCredential("FacebookOAuthAccount");

  // Set inputs
  initializeOAuthChoreo.setForwardingURL("http://www.beheadingboredom.com/wp-content/uploads/2016/09/first-time-eating-cotton-candy-best.gif");
  initializeOAuthChoreo.setScope("user_posts");

  // Run the Choreo and store the results
  InitializeOAuthResultSet initializeOAuthResults = initializeOAuthChoreo.run();

  // Print results
  println(initializeOAuthResults.getAuthorizationURL());
  authURL = initializeOAuthResults.getAuthorizationURL();
  println(initializeOAuthResults.getCallbackID());
  callbackID = initializeOAuthResults.getCallbackID();
}

void runFinalizeOAuthChoreo() {
  accessToken="";
  println("run fina");
  // Create the Choreo object using your Temboo session
  FinalizeOAuth finalizeOAuthChoreo = new FinalizeOAuth(session);

  // Set credential
  finalizeOAuthChoreo.setCredential("FacebookOAuthAccount");

  finalizeOAuthChoreo.setCallbackID(callbackID);

  // Run the Choreo and store the results
  FinalizeOAuthResultSet finalizeOAuthResults = finalizeOAuthChoreo.run();


  println(finalizeOAuthResults.getAccessToken());
  accessToken = finalizeOAuthResults.getAccessToken();

  // Print results
  //println(finalizeOAuthResults.getExpires());
}

void talkToMe() {

  //load messages
  //String allMessages[] = loadStrings("messages.txt");
  //println("there are " + allMessages.length + " lines");

  if (getNewWords) {
    println("getting words from:"+textFile);
    wordCram = new WordCram(this)
      .fromTextFile(textFile)
      .withColor(#ededed)
      .sizedByWeight(1, 10);
    getNewWords=false;
  }

  if (wordCram.hasMore()) {
    //wordCram.drawNext();
    report();
  } else {
    noLoop();
  }

  //for (int i = 0; i < allMessages.length; i++) {
  //  println(allMessages[i]);
  //}

  //if (msgCnt < allMessages.length) {
  //  println(allMessages[msgCnt]);

  //  msgCnt++;
  //} else if (msgCnt == allMessages.length) {
  //  startTalking=false;
  // }
}

void report() {
  Word[] words = wordCram.getWords();
  String[] extractWords =  new String[words.length];

  for (int i = 0; i < words.length; i++) {
    Word word = words[i];

    String theWord = words[i].toString();
    String[] splitWord = split(theWord, ' ');
    // list[0] is now "Chernenko", list[1] is "Andropov"...
    //println(splitWord[0]);
    extractWords[i] = splitWord[0];
  }
  int howMany = words.length;

  float rando1 = random(words.length);
  int rando1Int = int(rando1);

  float rando2 = random(words.length);
  int rando2Int = int(rando2);

  float rando3 = random(words.length);
  int rando3Int = int(rando3);

  String test = "keep looking for "+extractWords[rando1Int]+" what you find will be a "+extractWords[rando2Int]+" it will be your saving "+extractWords[rando3Int];
  println(test);
  statusScript = test;
  float voiceType = random(11);
  int voiceTypeInt = int(voiceType);

  float voiceSpeed = random(100, 155);
  int voiceSpeedInt = int(voiceSpeed);

  float delayLength =  random (5000, 10000);
  int delayLengthInt = int(delayLength);

  TextToSpeech.say(statusScript, TextToSpeech.voices[voiceTypeInt], voiceSpeedInt);
  delay(10000);

  voiceType = random(11);
  voiceTypeInt = int(voiceType);
  voiceSpeed = random(50, 300);
  voiceSpeedInt = int(voiceSpeed);
  delayLength =  random (500, 5000);
  delayLengthInt = int(delayLength);

  TextToSpeech.say(statusScript, TextToSpeech.voices[voiceTypeInt], voiceSpeedInt);
  delay(delayLengthInt);

  voiceType = random(11);
  voiceTypeInt = int(voiceType);
  voiceSpeed = random(50, 300);
  voiceSpeedInt = int(voiceSpeed);
  delayLength =  random (500, 1000);
  delayLengthInt = int(delayLength);

  TextToSpeech.say(statusScript, TextToSpeech.voices[voiceTypeInt], voiceSpeedInt);
  delay(delayLengthInt);

  voiceType = random(11);
  voiceTypeInt = int(voiceType);
  voiceSpeed = random(50, 300);
  voiceSpeedInt = int(voiceSpeed);
  delayLength =  random (500, 5000);
  delayLengthInt = int(delayLength);

  TextToSpeech.say(statusScript, TextToSpeech.voices[voiceTypeInt], voiceSpeedInt);
  delay(delayLengthInt);

  voiceType = random(11);
  voiceTypeInt = int(voiceType);
  voiceSpeed = random(50, 300);
  voiceSpeedInt = int(voiceSpeed);
  delayLength =  random (500, 10000);
  delayLengthInt = int(delayLength);

  TextToSpeech.say(statusScript, TextToSpeech.voices[voiceTypeInt], voiceSpeedInt);
  delay(delayLengthInt);

  voiceType = random(11);
  voiceTypeInt = int(voiceType);
  voiceSpeed = random(50, 300);
  voiceSpeedInt = int(voiceSpeed);
  delayLength =  random (500, 10000);
  delayLengthInt = int(delayLength);

  TextToSpeech.say(statusScript, TextToSpeech.voices[voiceTypeInt], voiceSpeedInt);
  delay(delayLengthInt);

  voiceType = random(11);
  voiceTypeInt = int(voiceType);
  voiceSpeed = random(50, 300);
  voiceSpeedInt = int(voiceSpeed);
  delayLength =  random (500, 5000);
  delayLengthInt = int(delayLength);

  TextToSpeech.say(statusScript, TextToSpeech.voices[voiceTypeInt], voiceSpeedInt);
  delay(delayLengthInt);

  voiceType = random(11);
  voiceTypeInt = int(voiceType);
  voiceSpeed = random(50, 300);
  voiceSpeedInt = int(voiceSpeed);
  delayLength =  random (500, 1000);
  delayLengthInt = int(delayLength);

  TextToSpeech.say(statusScript, TextToSpeech.voices[voiceTypeInt], voiceSpeedInt);
  delay(delayLengthInt);

  voiceType = random(11);
  voiceTypeInt = int(voiceType);
  voiceSpeed = random(50, 300);
  voiceSpeedInt = int(voiceSpeed);
  delayLength =  random (500, 1000);
  delayLengthInt = int(delayLength);

  TextToSpeech.say(statusScript, TextToSpeech.voices[voiceTypeInt], voiceSpeedInt);
  delay(delayLengthInt);

  voiceType = random(11);
  voiceTypeInt = int(voiceType);
  voiceSpeed = random(50, 300);
  voiceSpeedInt = int(voiceSpeed);
  delayLength =  random (400, 900);
  delayLengthInt = int(delayLength);

  TextToSpeech.say(statusScript, TextToSpeech.voices[voiceTypeInt], voiceSpeedInt);
  delay(delayLengthInt);

  voiceType = random(11);
  voiceTypeInt = int(voiceType);
  voiceSpeed = random(50, 300);
  voiceSpeedInt = int(voiceSpeed);
  delayLength =  random (300, 800);
  delayLengthInt = int(delayLength);

  TextToSpeech.say(statusScript, TextToSpeech.voices[voiceTypeInt], voiceSpeedInt);
  delay(delayLengthInt);

  restart=true;
  scene3=false;
}

void closeTextFile() {
  output.close();
  output.flush();
  output2.flush();
  output2.close();
  inc++;
}