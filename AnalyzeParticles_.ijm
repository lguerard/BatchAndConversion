//######### ANALYZE PARTICLES MACROS ##############
//######## By Laurent Guerard #############

//Close every unwanted histogram windows
//close("Histo*")

//Auto treshold with the Yen method and a dark background
setAutoThreshold("Yen dark");
run("Convert to Mask");

run("Make Binary");
//Real title of the window
StackTitle = getTitle(); 

//Duplicate the window to do a watershed and compare
run("Duplicate..."," ");
//Name of the duplicate
StackTitle2 = getTitle();
//Run Watershed on the duplicate
selectWindow(StackTitle2);
run("Watershed");
//Put side by side the two images
run("Tile");
NameList = getList("image.titles");

//Exit if there is a problem and no image are open
if (NameList.length <1) 
{
  exit("No Stack Window Open"); 
}

//Allows the user to choose which he likes most
Dialog.create("Which looks better ?"); 
Dialog.addChoice("Name", NameList); 
Dialog.show(); 
selectWindow(Dialog.getChoice());
WindowSelected = getTitle();

//Allow a threshold of particle analyses
Dialog.create("What is the minimal size of your objects of interest ?");
Dialog.addNumber("Size :",0);
Dialog.addMessage("If you don't know, put 30 in order to avoid the noise");
Dialog.show();
size = Dialog.getNumber();

//Analyze particles
run("Analyze Particles...","size="+size+"-Infinity show=Outlines summarize display in_situ");