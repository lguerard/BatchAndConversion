macro "CZIToTiff"
{
	setBatchMode(true);
	//Get file/folder information:
	setOption("JFileChooser",true);
	Folder = getDirectory("Choose the folder where your images are located");
	setOption("JFileChooser",false);
	OutputFolderName = "Tiff";
	Output_Folder = Folder + File.separator+ OutputFolderName;
	File.makeDirectory(Output_Folder);

	Files = getFileList(Folder);
	NrOfFiles = Files.length;

	for (i=0; i<NrOfFiles;i++)
	{
		if (endsWith(Files[i],".czi"))
		{
			open(Folder+File.separator+Files[i]);
			run("8-bit");
			saveAs("tiff",Output_Folder+File.separator+File.nameWithoutExtension);
		}
	}
}