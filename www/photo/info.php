<?PHP

   $handle=opendir("big");
   echo "Directory handle: $handle <br>\n";
   echo "Files: <br>\n";
   while ($file = readdir($handle))
   {
     if ((substr($file,0,1)!=".") and (substr($file,0,2)!="..")) { $FileList[]=$file; }
   }
   closedir($handle); 

   sort($FileList);
   $max=count($FileList);


   $files = "info.txt";
   $open = fopen($files, "a+");

   for ($i=0; $i<$max; $i++)
   {
     $FileName = "c:/www/photo/big/" . $FileList[$i];
     $FilesSize = round(filesize($FileName)/1000);
     $size = GetImageSize($FileName); 
     print ("$FileList[$i] ");
     print ("$size[0]x$size[1] ");
     print ("($FilesSize");
     print ("k)<br>\n");
     $rec = $FileList[$i] . " " . $size[0] . "x" . $size[1] . " (" . $FilesSize . "k)" . "\n";
     fwrite($open, $rec);
   }

   fclose($open);

?>