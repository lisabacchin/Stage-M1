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
		run("Set Scale...", "distance=1.5384 known=1 unit=µm global ");
		run("Scale Bar...", "width=1000 height=40 font=120 color=White background=None location=[Lower Right] bold");
		saveAs("Jpeg", outputsub + files[i]  + ".jpg");
		close();
		
	}

	}
}
