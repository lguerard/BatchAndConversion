dir = getDirectory("Choose Z-stack image folder");
//Get all the file in the folder
list = getFileList(dir);
//Create the output folder
dir2 = dir+"XZ"+File.separator;
File.makeDirectory(dir2);
setBatchMode(true);

//Loop through all the files
for(a=0;a<list.length;a++)
{
	//Check if the file is not a folder
	if(!File.isDirectory(dir+list[a]))
	{
	//Open it	
		open(list[a]);
		//waitForUser(list[a]);
		name = getTitle();
		dotIndex = lastIndexOf(name,".");
		shortTitle = substring(name, 0, dotIndex);
		//Check if the file is a stack
		if(nSlices() > 1)
		{
			run("Reslice [/]...", "output=1.000 start=Bottom avoid");
			run("Z Project...", "projection=[Max Intensity]");

			//selectWindow();
			//selectWindow("Composite");
			path = dir2+shortTitle;
			save(path+"XZ.tif");
			run("Close All");
		}
	}
}