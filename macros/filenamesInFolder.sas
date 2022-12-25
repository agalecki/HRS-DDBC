

%macro filenamesInFolder (fpath);
/* Creates dataset with filenames in a given folder */
data _filenames;
length fref $8 fname $200;
did = filename(fref,"&fpath");
did = dopen(fref);
do i = 1 to dnum(did);
  fname = dread(did,i);
  output;
end;
did = dclose(did);
did = filename(fref);
keep fname;
run;
%mend filenamesInFolder;



