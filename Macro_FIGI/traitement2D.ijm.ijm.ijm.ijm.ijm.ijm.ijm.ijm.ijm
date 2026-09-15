input = getDirectory("entree")
output = getDirectory("sortie")
folders = getFileList(input);



for (f=0; f< folders.length; f++){
	if (File.isDirectory(input + folders[f])){
		inputsub = input + folders[f];
		outputsub = output + folders[f];
		
		File.makeDirectory(outputsub);
		files = getFileList(inputsub);
		
		for (i=0; i<files.length; i++) {
		open(inputsub + files[i]);
		
		run("Enhance Contrast", "saturated=0.35");
		run("Scale Bar...", "width=500 height=20 font=40 color=White background=None location=[Lower Right] bold");
		run("Set Scale...", "distance=0.6211 known=1 unit=µm global ");
		name = replace(files[i], ".tif", "");
		saveAs("Jpeg", outputsub + name + ".jpg");
		close();
		}
		
	}

	}

