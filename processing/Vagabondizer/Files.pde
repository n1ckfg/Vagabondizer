import java.awt.Desktop;

PImage img;
PGraphics targetImg;
int counter=0;
boolean firstRun = true;
String openFilePath = "render";
String folderPath, filePath;
File dataFolder;
ArrayList imgNames;
String fileName = "frame";
boolean filesLoaded = false;
String saveName;
String exportFileType = "png";

void filesSetup() {
  nextImage(counter);
}

void fileLoop() {
  if (counter<imgNames.size()-1) {
    counter++;
    nextImage(counter);
  } else {
    exit();
  }
}

void chooseFileDialog() {
    selectInput("Choose a PNG, JPG, GIF, or TGA file.","chooseFileCallback");  
}

void chooseFileCallback(File selection){
    if (selection == null) {
      println("No folder was selected.");
      exit();
    } else {
      filePath = selection.getAbsolutePath();
      println(filePath);
    }
}

void chooseFolderDialog() {
    selectFolder("Choose a PNG, JPG, GIF, or TGA sequence.","chooseFolderCallback");
}

void chooseFolderCallback(File selection) {
    if (selection == null) {
      println("No folder was selected.");
      exit();
    } else {
      folderPath = selection.getAbsolutePath();
      println(folderPath);
      countFrames(folderPath);     
    }
}

boolean isImage(String s) {
  s = s.toLowerCase();
  if (s.endsWith("png") || s.endsWith("jpg") || s.endsWith("jpeg") || s.endsWith("gif") || s.endsWith("tga")) {
    return true;
  } else {
    return false;
  }
}

void countFrames(String usePath) {
    imgNames = new ArrayList();
    //loads a sequence of frames from a folder
    dataFolder = new File(usePath); 
    String[] allFiles = dataFolder.list();
    for (int j=0;j<allFiles.length;j++) {
      if (isImage(allFiles[j])) imgNames.add(usePath+"/"+allFiles[j]);
    }
    if (imgNames.size()<=0) {
      exit();
    } else {
      // We need this because Processing 2, unlike Processing 1, will not automatically wait to let you pick a folder!
      String s;
      if (imgNames.size() == 1) {
        s = "image";
      } else {
        s = "images";
      }
      println("FOUND " + imgNames.size() + " " + s);
      filesLoaded = true;
    }
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//reveal folder, processing 2 version

void openAppFolderHandler() {
  if (System.getProperty("os.name").equals("Mac OS X")) {
    try {
      print("Trying OS X Finder method.");
      Desktop.getDesktop().open(new File(sketchPath("") + "/" + openFilePath));
    } catch (Exception e){ }
  } else {
    try {
      print("Trying Windows Explorer method.");
      Desktop.getDesktop().open(new File(sketchPath("") + "/" + openFilePath));
    } catch (Exception e) { }
  }
}

//run at startup if you want to use app data folder--not another folder.
//This accounts for different locations and OS conventions
void scriptsFolderHandler(){
  String s = openFilePath;
  if(System.getProperty("os.name").equals("Mac OS X")){
    try{
      print("Trying OS X Finder method.");
      openFilePath = dataPath("") + "/" + s;
    }catch(Exception e){ }
  }else{
    try{
      print("Trying Windows Explorer method.");
      openFilePath = sketchPath("") + "/data/" + s;
    }catch(Exception e){ }
  }
}

/*
void saveGraphics(PGraphics pg,boolean last) {
  try {
    String savePath = sketchPath("") + "/render/" + fileName + "_" + zeroPadding(counter+1,imgNames.size()) + "." + exportFileType;
    pg.save(savePath); 
    println("SAVED " + savePath);
  } catch(Exception e) {
    println("Failed to save file.");  
  }
  if (last) {
    openAppFolderHandler();
    exit();
  }
}
*/

void nextImage(int _n) {
  String imgFile = (String) imgNames.get(_n);
  saveName = imgFile.split("[\\/]")[imgFile.split("[\\/]").length-1].split("[.]")[0];
  println(saveName);
  cg = new ContourGenerator(loadImage(imgFile));
  println("RENDERING source image " + (counter+1) + " of " + imgNames.size());
  opticalFlowSetup();  
}

String zeroPadding(int _val, int _maxVal){
  String q = ""+_maxVal;
  return nf(_val,q.length());
}

float tween(float v1, float v2, float e) {
  v1 += (v2-v1)/e;
  return v1;
}

void prepGraphics() {
  targetImg = createGraphics(img.width, img.height, P2D);
}
