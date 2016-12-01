dir = getDirectory("Choose Z-stack image folder");
//Get all the file in the folder
list = getFileList(dir);
//Create the output folder
dir2 = dir+"MergedMaxProj"+File.separator;
dir3 = dir2+"XZProjection"+File.separator;
File.makeDirectory(dir2);
setBatchMode(true);


//Variables
var Test=newArray(7);

//Loop through all the files
for(a=0;a<list.length;a++)
{
	showProgress(a+1, list.length);
	//Check if the file is not a folder
	if(!File.isDirectory(dir+list[a]))
	{
	//Open it	
		open(list[a]);
		setMinAndMax(0, 4095);
		//waitForUser(list[a]);
		name = getTitle();
		dotIndex = lastIndexOf(name,".");
		shortTitle = substring(name, 0, dotIndex);
		//Check if the file is a stack
		if(nSlices() > 1)
		{
			//Split channels on an open window
			run("Split Channels");
			//Get the name of all the open windows
			NameList = getList("image.titles");
			//waitForUser(NameList.length);
			//Array.print(NameList);
			for(i=0;i<NameList.length;i++)
			{
				//run("RGB Color");
				//Array.print(NameList);
				if(matches(NameList[i],"C1.*"))
				{
					//waitForUser(NameList[i]);
					G = NameList[i];
				}
				if(matches(NameList[i],"C2.*"))
					R = NameList[i];
			}
			

			
			//waitForUser("Merge Channels...", "c1="+R+" c2="+G);
			run("Merge Channels...", "c1="+R+" c2="+G);

			selectWindow("RGB");
			run("Z Project...", "projection=[Max Intensity]");
			//selectWindow("Composite");
			path = dir2+shortTitle;
			save(path+"MERGEDMAX.tif");
			run("Close All");
		}
	}
}

list2 =

showMessage("Finished !");
setBatchMode(false);