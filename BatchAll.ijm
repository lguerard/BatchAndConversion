//BATCH MERGE, MAX INTENSITY PROJECTION AND XZ PROJECTION MACRO

//Select the folder in which are the files
dir = getDirectory("Choose Z-stack image folder");
//Get all the file in the folder
list = getFileList(dir);
//Create the output folders
dir1 = dir+"Merged"+File.separator;
dir2 = dir1+"MergedMaxProj"+File.separator;
dir3 = dir1+"XZProjection"+File.separator;
File.makeDirectory(dir1);
File.makeDirectory(dir2);
setBatchMode(true);


//Variables
var Test=newArray(7);

//Loop through all the files
for(a=0;a<list.length;a++)
{
	showProgress(a+1, list.length*2);
	//Check if the file is not a folder
	if(!File.isDirectory(dir+list[a]))
	{
		//Open it	
		open(list[a]);
		//Get the name of the image
		imgname = list[a];
		//Set min and max value to 12bit
		setMinAndMax(0, 4095);
		//Get the name of the file and remove the extension, to save the new images
		name = getTitle();
		dotIndex = lastIndexOf(name,".");
		shortTitle = substring(name, 0, dotIndex);
		//Check if the file is a stack
		if(nSlices() > 1)
		{
			//Split channels on an open window
			run("Split Channels");
			
			//Put the channels in the correct order
			R = "C2-"+imgname;
			G = "C1-"+imgname;
			
			//Merge the channels with the correct channels
			run("Merge Channels...", "c1="+R+" c2="+G);
			path = dir1+shortTitle;
			//Add MERGED at the end of the image name
			save(path+"MERGED.tif");

			//Makes the Maximum Intensity Projection image
			selectWindow("RGB");
			run("Z Project...", "projection=[Max Intensity]");
			//selectWindow("Composite")
			path = dir2+shortTitle;
			//Add MAX at the end of the image name
			save(path+"MAX.tif");
			run("Close All");
		}
	}
}

//Get the merged images
list2 = getFileList(dir1);
//Create the new folder for XZ projection
File.makeDirectory(dir3);

//Loop through all the files
for(i=0;i<list2.length;i++)
{
	//Show progress
	showProgress(i+1+list.length, list.length*2);
	//Verify that it's not a folder
	if(!File.isDirectory(dir1+list2[i]))
	{
		//Open the image
		open(dir1+list2[i]);

		//Get the name without the extension
		name = getTitle();
		dotIndex = lastIndexOf(name,".");
		shortTitle = substring(name, 0, dotIndex);
		//Check if the file is a stack
		if(nSlices() > 1)
		{
			run("Reslice [/]...", "output=1.000 start=Top avoid");
			run("Z Project...", "projection=[Max Intensity]");
			run("Flip Vertically");

			//selectWindow();
			//selectWindow("Composite");
			path = dir3+shortTitle;
			save(path+"XZ.tif");
			run("Close All");
		}
	}
}

showMessage("Finished !");
setBatchMode(false);