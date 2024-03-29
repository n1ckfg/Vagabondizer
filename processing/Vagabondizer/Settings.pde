class Settings {

  String[] data;

  Settings(String _s) {
    try {
      data = loadStrings(_s);
      for (int i=0;i<data.length;i++) {
        if (data[i].equals("Export File Type")) exportFileType = setString(data[i+1]); 
        if (data[i].equals("Use Fills")) useFills = setBoolean(data[i+1]); 
        if (data[i].equals("Clear Background")) doClear = setBoolean(data[i+1]); 
        if (data[i].equals("Render Limit")) renderLimit = setInt(data[i+1]); 
        if (data[i].equals("Scale Window")) scaler = setInt(data[i+1]); 
        if (data[i].equals("Record")) record = setBoolean(data[i+1]); 
        if (data[i].equals("Refine")) refine = setBoolean(data[i+1]); 
        if (data[i].equals("Child Step")) childStep = setInt(data[i+1]); 
        if (data[i].equals("Point Step")) pointStep = setInt(data[i+1]); 
        if (data[i].equals("Alpha")) alpha = setInt(data[i+1]); 
        if (data[i].equals("Stroke")) strokeWeightVal = setFloat(data[i+1]); 
        if (data[i].equals("Shake")) shake = setFloat(data[i+1]); 
        if (data[i].equals("Bloom Strength")) bloomMult = setFloat(data[i+1]); 
        if (data[i].equals("Bloom Radius")) bloomRadius = setFloat(data[i+1]); 
        if (data[i].equals("Optical Flow Detail")) levelOfDetail = setInt(data[i+1]); 
        if (data[i].equals("Optical Flow Scale")) videoScale = setInt(data[i+1]); 
      }
    } 
    catch(Exception e) {
      println("Couldn't load settings file. Using defaults.");
    }
  }

  int setInt(String _s) {
    return int(_s);
  }

  float setFloat(String _s) {
    return float(_s);
  }

  boolean setBoolean(String _s) {
    return boolean(_s);
  }
  
  String setString(String _s) {
    return ""+(_s);
  }
  
  String[] setStringArray(String _s) {
    int commaCounter=0;
    for(int j=0;j<_s.length();j++){
          if (_s.charAt(j)==char(',')){
            commaCounter++;
          }      
    }
    //println(commaCounter);
    String[] buildArray = new String[commaCounter+1];
    commaCounter=0;
    for(int k=0;k<buildArray.length;k++){
      buildArray[k] = "";
    }
    for (int i=0;i<_s.length();i++) {
        if (_s.charAt(i)!=char(' ') && _s.charAt(i)!=char('(') && _s.charAt(i)!=char(')') && _s.charAt(i)!=char('{') && _s.charAt(i)!=char('}') && _s.charAt(i)!=char('[') && _s.charAt(i)!=char(']')) {
          if (_s.charAt(i)==char(',')){
            commaCounter++;
          }else{
            buildArray[commaCounter] += _s.charAt(i);
         }
       }
     }
     println(buildArray);
     return buildArray;
  }

  color setColor(String _s) {
    color endColor = color(0);
    int commaCounter=0;
    String sr = "";
    String sg = "";
    String sb = "";
    String sa = "";
    int r = 0;
    int g = 0;
    int b = 0;
    int a = 0;

    for (int i=0;i<_s.length();i++) {
        if (_s.charAt(i)!=char(' ') && _s.charAt(i)!=char('(') && _s.charAt(i)!=char(')')) {
          if (_s.charAt(i)==char(',')){
            commaCounter++;
          }else{
          if (commaCounter==0) sr += _s.charAt(i);
          if (commaCounter==1) sg += _s.charAt(i);
          if (commaCounter==2) sb += _s.charAt(i); 
          if (commaCounter==3) sa += _s.charAt(i);
         }
       }
     }

    if (sr!="" && sg=="" && sb=="" && sa=="") {
      r = int(sr);
      endColor = color(r);
    }
    if (sr!="" && sg!="" && sb=="" && sa=="") {
      r = int(sr);
      g = int(sg);
      endColor = color(r, g);
    }
    if (sr!="" && sg!="" && sb!="" && sa=="") {
      r = int(sr);
      g = int(sg);
      b = int(sb);
      endColor = color(r, g, b);
    }
    if (sr!="" && sg!="" && sb!="" && sa!="") {
      r = int(sr);
      g = int(sg);
      b = int(sb);
      a = int(sa);
      endColor = color(r, g, b, a);
    }
      return endColor;
  }
}
